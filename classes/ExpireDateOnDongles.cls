/**********************************************************************
*	EmilK
*	this Batch Apex class sends emails to Resellers 15 days  
*	before their dongles will be expired
***********************************************************************/
global class ExpireDateOnDongles implements Database.Batchable<sObject>, Database.Stateful{
										
	public enum CheckMode {Subscription, ExpireDay}
	
	// SQL query used for bach Apex 
	private String m_query;
	
	// amount of days to check dongle expire or subscription date 
	private Integer m_num_of_days;
	
	// current reseller Batch apllication is treating
	private ID m_last_reseller_id;
	
	// the mode the class is being used : expire mode \ subscription mode
	private CheckMode m_mode;
	
	// email subject
	private String m_mailSubject;
	
	// access 4email containers by ther key
	map<String, EmailContainer> m_emailContainers;
	
	private Integer m_numQueries = 0;
	
	// Eddie mail
	EmailContainer m_mailToEddie;
	
	
	/**
	*	EmilK
	*	get , set SQl query that initializes Batch Apex
	**/
	public String Query{
		set{m_query = value;}
		get{return m_query;}
	} 
	
	public String Limitation{
		set;
		get;
	}
		
	/**
	*	EmilK
	* 	ctor 
	**/
	public ExpireDateOnDongles(Integer numDays, CheckMode mode){
		
		m_num_of_days = numDays;
		m_mode        = mode;
		m_emailContainers = new map<String, EmailContainer>();
		m_mailToEddie = new EmailContainer(m_mode, m_num_of_days);
		//m_mailToEddie.add_to_mail('eddie.pevzner@solidcam.comToEddy');//ToEddy added at end. it's for debug purpose
		m_mailToEddie.add_to_mail('David.Somekh@solidcam.com');
		if (m_mode == CheckMode.ExpireDay){
			m_mailSubject = 'Dongles Expiring';
		}
		else{
			m_mailSubject = 'Subscription Status';
		}
	}
	
	/*
	*	EmilK
	*	Start
	*/
	global Database.Querylocator start(Database.BatchableContext BC)
	{
		if (m_query == null){
			 
			String field_to_check;
			String relevanceFieldName;
			// on expire date mode the dongle expire day will be checked
			if (m_mode == CheckMode.ExpireDay){
				field_to_check = 'Dongle_Expiry_Date__c';
				relevanceFieldName = 'IsRelevant_Expiry__c';
			}
			// else - end of maintenece date will be checked
			else{ 
				field_to_check = 'New_Maintenance_End_Date__c';
				relevanceFieldName = 'Is_Relevant__c';
			}
			// SQl query return all dongles in system that are relevant
			// and their expire date/end subscription is between today and today + m_num_of_days
			System.debug('Query #18 - ExpireDateOnDongles');
			m_query = 'Select Id, Customer__c , Reseller__c, SubReseller__c, Name , Evaluation_Module__c'+
					  ', ' + field_to_check + ', Reseller_Country__c'+ 
					  ' From Dongle__c '+
					  ' where ' + relevanceFieldName + ' = 1 AND ' 
					    + field_to_check + ' >= TODAY '+
					  ' AND ' + field_to_check + 
					  ' <= NEXT_N_DAYS : '+ m_num_of_days + 
					  //' AND (Reseller__r.Name = \'Applied Engineering Technologies\' or subReseller__r.Name=\'Applied Engineering Technologies\')'+
					  ' order by Reseller__c , SubReseller__c'; 
			
				if (Limitation != null){
					m_query += ' limit '+Limitation;
				}
		}
		return Database.getQueryLocator(m_query);
	}
	
	/**
	*	EmilK
	*	execute batch
	**/
	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{
		List<Dongle__c> donglesList = new List<Dongle__c>();
		
		for(sObject sobj : scope){
			donglesList.add((Dongle__c)sobj);
		}

		
		treate_about_to_expire_dongles(donglesList);
	}
	
	/***
	*	EmilK
	*	finish batch
	*/
	global void finish(Database.BatchableContext BC){
		// send mail to All emails if any
		Integer mailsSent = 0;
		system.debug(LoggingLevel.INFO,'***Numbers of EMAILS RESTANTS: '+m_emailContainers.values().size());
		for(EmailContainer anyMail : m_emailContainers.values()){
			system.debug(LoggingLevel.INFO,'***Numbers of EMAILS RESTANTS: '+m_emailContainers.values().size());
			system.debug(LoggingLevel.INFO,'***EMAILS RESTANTS: '+anyMail);
			system.debug(LoggingLevel.INFO,'***Numbers of EMAILS RESTANTS: '+m_emailContainers.values().size());
			if (mailsSent == 8)//Corrected by BA-LINK. 0->8 = 9 mails, and we need 1 to Eddie. Before the correction: (mailsSent == 10) 
				break;
			if (anyMail.has_dongles()){
				anyMail.sendMailToReseller();
				mailsSent++;
			}
		}
		m_emailContainers.clear();
		// avoid send mail exception
		if (mailsSent == 9)//Corrected by BA-LINK. Before the correction: (mailsSent == 10)
			return;
		// flush mail to eddie
		system.debug('***Before mail to Eddie');
		if (m_mailToEddie.has_dongles()){
			system.debug('***m_mailToEddie: '+m_mailToEddie);
			m_mailToEddie.sendMailToReseller();
		}
	}
	
	/*
	*	EmilK
	*	contact dongles that are about to expire
	*	to their reseller id
	*/
	public void treate_about_to_expire_dongles(List<Dongle__c> expire_dongles){
		
		// Loop over the dongles - add them to their reseller id
		// It is assumed that the list is ordered by reseller id
		for(Dongle__c any_dongle : expire_dongles){
			// No reseller - step over dongle
			if ( any_dongle.Reseller__c == null){
				continue;
			}
			ID requiredAccount = any_dongle.SubReseller__c;
			if (requiredAccount == null){
				requiredAccount =  any_dongle.Reseller__c;
			}
			Set<Id> resellersId = new Set<Id>();
			if(any_dongle.Reseller__c != null)
				resellersId.add(any_dongle.Reseller__c);
			if(any_dongle.subReseller__c != null)
				resellersId.add(any_dongle.subReseller__c);	
			// get dongle data
			DongleAccountData dongleData = get_dongle_details(any_dongle);
			// get redeller email object
			System.debug('Query #19 - ExpireDateOnDongles');
			List<Automation_Mails__c> emailListGlobal = [Select Id, To__c, CC__c , 
			 											   Automation_Mail_Code__c,
			 											   Automation_Mail_Code_Managers__c,
			 											   BCC__c, Mail_Subject__c, 
			 											   To_Managers__c, Account__c
			 								From Automation_Mails__c
			 								//Where Account__c = : requiredAccount];
			 								Where Account__c in: resellersId and Mail_Subject__c includes (:m_mailSubject)];
			 List<Automation_Mails__c> emailList = new List<Automation_Mails__c>();
			 
			 for(Automation_Mails__c am:emailListGlobal){
			 	if(am.Account__c==any_dongle.subReseller__c)
			 		emailList.add(am);
			 }
			 
			 if(emailList.size()==0){
			 	for(Automation_Mails__c am:emailListGlobal){
				 	if(am.Account__c==any_dongle.Reseller__c)
				 		emailList.add(am);
				 }
			 }
			 
			 Integer numEmailObjects = emailList.size();
			 
			 // remove email objects withot required subject
			 // this is made 'manualy' because 'like' keyword does not works
			 // with picklists
			 /*for(Integer i = numEmailObjects-1 ; i >= 0 ; --i){
			 	String mailSubject = emailList.get(i).Mail_Subject__c;
			 	// dongle belogns only to expire \ subscription
			 	// dont treat him
			 	if (mailSubject == null || mailSubject.contains(m_mailSubject) == false){
			 		continue;	
			 	}
			 }*/ //it's done in the above query with the includes function
			 // if no relevant objects send domgle to eddie
			 if (emailList.size() == 0){
			 	m_mailToEddie.add_dongle_data(any_dongle.Id, dongleData);
			 	continue;
			 }
			 
			 for(Automation_Mails__c anyMail : emailList){
			 	// if Automation_Mails__c has manager part - treat it
			 	if (anyMail.To_Managers__c != null){
			 		List<String> mailsList = ApexUtils.text_get_mails_to_send(anyMail.To_Managers__c);
			 		// look over all resellers
			 		for(String managerMail : mailsList){
				 		EmailContainer mailContainer = m_emailContainers.get(managerMail);
						// if no such manager
						if (mailContainer == null){
							// create new email container for manager
							mailContainer = new EmailContainer(m_mode, m_num_of_days);
							mailContainer.add_to_mail(managerMail);
							// update resellers in manager mail
							mailContainer.manager_update_resellers_list(anyMail,managerMail);//managerMail added by ilan
							m_emailContainers.put(managerMail, mailContainer);
						}
						mailContainer.add_dongle_data(any_dongle.Id, dongleData);
			 		}
			 	}
			 	
			 	// Here we treat (to, cc, bcc part of Automation_Mails__c)
			 	String key = ApexUtils.get_map_email_key(anyMail);
			 	if(!(anyMail.CC__c==null && anyMail.BCC__c==null && anyMail.To__c==null)){
				 	EmailContainer mailContainer = m_emailContainers.get(key);
				 	
				 	if (mailContainer == null){
				 		mailContainer = new EmailContainer(m_mode, m_num_of_days);
				 		// initialize container
				 		mailContainer.initialize(anyMail);
				 		m_emailContainers.put(key, mailContainer);
				 	}
				 	mailContainer.add_dongle_data(any_dongle.Id, dongleData);
			 	}
			 	System.debug('******* any_dongle.Id' + any_dongle.Id + ' && ' + dongleData);
			 }
		}
		
		Integer lastDongleIndex = expire_dongles.size() - 1;
		Dongle__c lastDongle = expire_dongles.get(lastDongleIndex);
		ID lastDongleAccountId = lastDongle.SubReseller__c;
		if (lastDongleAccountId == null){
			lastDongleAccountId = lastDongle.Reseller__c;
		}

		List<String> keyToRemove = new List<String>();
		// check if any email has to be sent
		for(String anyKey : m_emailContainers.keySet()){
			
			EmailContainer anyContainer = m_emailContainers.get(anyKey);
			// if saw all dongles 
			// and the last dongle has an other reseller
			// it means that all the non seen yet dongles are have different resellers
			// send mail snd delete from map
			boolean logSend = anyContainer.isSawAllResellers() && !anyContainer.has_reseller(lastDongleAccountId);
			System.debug('*******' + m_emailContainers.values());
			System.debug('*******' + anyKey + ' && ' + logSend  + ' && ' + anyContainer.isSawAllResellers() + ' && ' + !anyContainer.has_reseller(lastDongleAccountId));
			if (anyContainer.isSawAllResellers() && !anyContainer.has_reseller(lastDongleAccountId)){
				System.debug('******* Send Email'); 
				anyContainer.sendMailToReseller();
				keyToRemove.add(anyKey);
			}
		}
		// delete irelevant keys
		for(String anyKey : keyToRemove){
			System.debug('******* Remove key' + anyKey);
			m_emailContainers.remove(anyKey);
		}
	}
	
	/**
	* 	get dongle details
	* 	Cost 3 queries 3 rows
	**/
	private DongleAccountData get_dongle_details(Dongle__c theDongle)
	{
		DongleAccountData data = new DongleAccountData();
		
		data.dongleId = theDongle;
		if (theDongle.Reseller__c != null){
		 	// get dongle reseller
		 	System.debug('Query #15 - ExpireDateOnDongles');
		 	Account reseller = [Select Name from Account where Id = :theDongle.Reseller__c];
			data.resellerName = reseller.Name;
		}
		if (theDongle.SubReseller__c != null){
		 	// get dongle reseller
		 	System.debug('Query #17 - ExpireDateOnDongles');
		 	Account subreseller = [Select Name from Account where Id = :theDongle.SubReseller__c];
			data.subresellerName = subreseller.Name;
		}
		
		if (theDongle.Customer__c != null){
		 	// get dongle reseller
		 	System.debug('Query #17 - ExpireDateOnDongles');
		 	Account customer = [Select Name from Account where Id = :theDongle.Customer__c];
			data.customerName = customer.Name;
		}
		return data;
	}
}