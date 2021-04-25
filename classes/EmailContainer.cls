/******************************
*	EmilK
*	class contains data about mail to sand
*	dongles data mails addresses to send
*
********************************/
public class EmailContainer { 

	// acount of days to check dongle expire or subscription date 
	protected Integer m_num_of_days;
	
	// the mode the class is being used : expire mode \ subscription mode
	protected ExpireDateOnDongles.CheckMode m_mode;
	
	// hold number of expected dongles
	protected Integer m_numDongles;
	
	// list of expiring / ending subscription dongles that belong to current reseller
	protected map<Id, DongleAccountData> m_donglesMap; 
	
	protected List<String> m_ToMails;
	protected List<String> m_CcMails;
	protected List<String> m_BccMails;
	protected map<ID, Boolean> m_resellersIds;
	
	/**
	*	EmilK
	*	Ctor
	**/
	public EmailContainer(ExpireDateOnDongles.CheckMode mode, Integer numOfDays){
		// think about mail subject! (pick list)
		m_mode = mode;
		m_num_of_days = numOfDays;
		m_donglesMap = new map<Id, DongleAccountData>();
		m_ToMails = new List<String>();
		m_CcMails = new List<String>();
		m_BccMails = new List<String>();
		m_resellersIds = new map<ID, Boolean>();
		m_numDongles = 0;
	}
	
	/**
	*	EmilK
	*	add dongle data
	**/
	public void add_dongle_data(ID dongleId, DongleAccountData data){
		m_donglesMap.put(dongleId, data);
		
		// if saw a new Reseller increase index
		if (data.dongleId.SubReseller__c != null){
			m_resellersIds.put(data.dongleId.SubReseller__c, true);
		}
		// else - put reseller
		else{
			m_resellersIds.put(data.dongleId.Reseller__c, true);
		}
		 m_numDongles--;
		// collections with more than 150 values are not allowed! 
		if (m_donglesMap.size() > 150){
			sendMailToReseller();
		}
	}
	
	/**
	*	EmilK
	*	is Saw All Resellers
	**/
	public Boolean isSawAllResellers(){
		for(Boolean anySaw : m_resellersIds.values()){
			System.debug('************** anySaw' + anySaw);
			if (anySaw == false)
				return false;	
		}
		system.debug('***NumDongles: '+m_numDongles);
		return m_numDongles == 0;
	}
	
	/**
	*	EmilK
	*	has reseller
	**/
	public Boolean has_reseller(ID resellerId){
		return m_resellersIds.containsKey(resellerId);
	}
	
	/**
	*	EmilK
	*	add to mail
	**/
	public void add_to_mail(String mailAddress){
		m_ToMails.add(mailAddress);
	}
	
	/**
	*	EmilK
	*	has dongles
	**/
	public Boolean has_dongles(){
		return m_donglesMap.size() != 0;
	}
	
	/**
	^	EmilK
	*	manager update resellers list
	**/
	public void manager_update_resellers_list(Automation_Mails__c mailsObj, string managerMail){
		string likeQuery = '%'+managerMail+'%';//added by ilan
		System.debug('Query #19 - EmailContainer');
		if (mailsObj.To_Managers__c != null){
		List<Automation_Mails__c> sameMailslist = [Select Account__c 
							  From Automation_Mails__c
							  //Where Automation_Mail_Code_Managers__c =: mailsObj.Automation_Mail_Code_Managers__c and Mail_Subject__c includes (:(m_mode == ExpireDateOnDongles.CheckMode.ExpireDay)?'Dongles Expiring':'Subscription Status')]; by ilan
							  Where Automation_Mail_Code_Managers__c like :likeQuery and Mail_Subject__c includes (:(m_mode == ExpireDateOnDongles.CheckMode.ExpireDay)?'Dongles Expiring':'Subscription Status') and To_Managers__c!=null];
			for(Automation_Mails__c anyMail : sameMailslist){
				m_resellersIds.put(anyMail.Account__c, false);
			}
			update_number_of_total_dongles(m_resellersIds.keySet());
		}
	}
	
	/**
	*	EmilK
	*	update number of total dongles
	**/
	 private void update_number_of_total_dongles(Set<ID> resellers){

		m_numDongles = 0;
		for (ID resellerId : resellers){
			System.debug('***Reseller: '+resellerId);
			if (m_mode == ExpireDateOnDongles.CheckMode.ExpireDay){
				// possible bug Apex makes me use 14 as number!
				System.debug('Query #20 - EmailContainer');
				/*m_numDongles += [Select count() 
								From Dongle__c 
								Where (Reseller__c =: resellerId OR SubReseller__c = : resellerId)
								And IsRelevant_Expiry__c = 1 And Dongle_Expiry_Date__c >= TODAY 
								And Dongle_Expiry_Date__c <= NEXT_N_DAYS:14];*/
				Integer nb = [Select count() 
								From Dongle__c 
								Where SubReseller__c = : resellerId
								And IsRelevant_Expiry__c = 1 And Dongle_Expiry_Date__c >= TODAY 
								And Dongle_Expiry_Date__c <= NEXT_N_DAYS:14];
				Set<Id> subLst = new Set<id>(); 
				for( Automation_Mails__c am:[Select Account__c From Automation_Mails__c Where Mail_Subject__c includes (:(m_mode == ExpireDateOnDongles.CheckMode.ExpireDay)?'Dongles Expiring':'Subscription Status')]){
					subLst.add(am.Account__c);
				}
				nb += [Select count() 
								From Dongle__c 
								Where (Reseller__c = : resellerId AND (SubReseller__c =null or subReseller__c not in:subLst))
								And IsRelevant_Expiry__c = 1 And Dongle_Expiry_Date__c >= TODAY 
								And Dongle_Expiry_Date__c <= NEXT_N_DAYS:14];
				if(nb==0){
					m_resellersIds.put(resellerId,true);
				}
				m_numDongles += nb;								
			}
			else{
				System.debug('Query #21 - EmailContainer');
				/*m_numDongles += [Select count() 
								From Dongle__c 
								Where (Reseller__c =: resellerId OR SubReseller__c = : resellerId)
								And Is_Relevant__c = 1 And New_Maintenance_End_Date__c >= TODAY 
								And New_Maintenance_End_Date__c <= NEXT_N_DAYS:60];*/
				Set<Id> subLst = new Set<id>(); 
				for( Automation_Mails__c am:[Select Account__c From Automation_Mails__c Where Mail_Subject__c includes (:(m_mode == ExpireDateOnDongles.CheckMode.ExpireDay)?'Dongles Expiring':'Subscription Status')]){
					subLst.add(am.Account__c);
				}				
				Integer nb = 	[Select count() 
								From Dongle__c 
								Where SubReseller__c = : resellerId and SubReseller__c in :subLst
								And Is_Relevant__c = 1 And New_Maintenance_End_Date__c >= TODAY 
								And New_Maintenance_End_Date__c <= NEXT_N_DAYS:60];		
				
				nb += 	[Select count() 
								From Dongle__c 
								Where (Reseller__c = : resellerId and Reseller__c in :subLst And (SubReseller__c =null or SubReseller__c not in:subLst))
								And Is_Relevant__c = 1 And New_Maintenance_End_Date__c >= TODAY 
								And New_Maintenance_End_Date__c <= NEXT_N_DAYS:60];
				if(nb==0){
					m_resellersIds.put(resellerId,true);
				}
				m_numDongles +=nb;							
			}
		}
	}

	/**
	*	EmilK
	*	initialize
	**/
	public Boolean initialize(Automation_Mails__c mailsObj){
		
			System.debug('Query #22 - EmailContainer');
			List<Automation_Mails__c> sameMailslist = [Select Account__c 
							  From Automation_Mails__c
							  Where Automation_Mail_Code__c =: mailsObj.Automation_Mail_Code__c and Mail_Subject__c includes (:(m_mode == ExpireDateOnDongles.CheckMode.ExpireDay)?'Dongles Expiring':'Subscription Status')];
						  	
			for(Automation_Mails__c anyMail : sameMailslist){
				m_resellersIds.put(anyMail.Account__c, false);
			}

			update_number_of_total_dongles(m_resellersIds.keySet());
			
			// split maild adresses by '\n'
			m_ToMails = ApexUtils.text_get_mails_to_send(mailsObj.To__c);
			if (mailsObj.BCC__c != null)
				m_BccMails = ApexUtils.text_get_mails_to_send(mailsObj.BCC__c);
			if(mailsObj.CC__c != null)
				m_CcMails = ApexUtils.text_get_mails_to_send(mailsObj.CC__c);
		
		// put emails in mailing lists (from dongle data)
		return true;
	}
	
	/**
	*	EmilK
	*	send Mail To Reseller
	**/
	public void sendMailToReseller(){
								   
		Messaging.Singleemailmessage mailToSend = new Messaging.Singleemailmessage();

		// set adresses to which the mail will be sent
		List<String> l = new list<String>();
		//== l.add('emil.kalin@gmail.com');
		mailToSend.setToAddresses(m_ToMails);
		mailToSend.setBccAddresses(m_BccMails);
		mailToSend.setCcAddresses(m_CcMails);
		//mailToSend.setToAddresses( new list<string> {'David.Somekh@solidcam.com'} );
		//mailToSend.setToAddresses( new list<string> {'ilanl@balink.net'} );
		
		// set sender display name
		mailToSend.setSenderDisplayName('SolidCAM Team');
		
		String expireDateColumnName;
		if (m_mode == ExpireDateOnDongles.CheckMode.ExpireDay){
			mailToSend.setSubject(' SolidCAM licenses expiring in the next two weeks');
			expireDateColumnName = 'Expiration Date';
		}
		else{
			mailToSend.setSubject(' SolidCAM subscription renewals');
			expireDateColumnName = 'Subscription End Date';
		}
		// get mail text
		HtmlWriter html_writer = getEmailContents(m_donglesMap, expireDateColumnName);
		// get html string
		String htlmDocString = html_writer.ToHtmlString();
		
		//for debug use:
		/*htlmDocString += 'TO: '+m_ToMails;
		htlmDocString += 'BCC: '+m_BccMails;
		htlmDocString += 'CC: '+m_CcMails;
		htlmDocString += 'nb dungles: '+ m_donglesMap.size();
		htlmDocString += 'dungles restants: '+ m_numDongles;
		htlmDocString +=' Resellers non visites:';
		for(Id key:m_resellersIds.keySet()){
			if(!m_resellersIds.get(key))
				htlmDocString += 'id:'+key;
		}*/
		
		//System.debug('dudu = '+htlmDocString);
		mailToSend.setHtmlBody(htlmDocString);
		
		mailToSend.setBccSender(false); 
		// send mail
		Messaging.Singleemailmessage[] mails = new Messaging.Singleemailmessage[]{mailToSend};
		LIST<Messaging.SendEmailResult> result_list = Messaging.sendEmail(mails, false);
		// check senging mail result
		for(Messaging.SendEmailResult res : result_list){
			if(res.isSuccess()){
				System.debug('send mail');
			}
			else{
				// show email sending errors on debug
				List<Messaging.SendEmailError> errors = res.getErrors();
				for(Messaging.SendEmailError err : errors){
					System.debug('error '+err.getMessage());
				}	
			}
		}
		
		// Clear all dongles
		m_donglesMap.clear();
	}
		
	/**
	*	EmilK
	*	Write SoldiCAM email HTML contents  
	**/
	private HtmlWriter getEmailContents(map<Id, DongleAccountData> dongles_about_to_expire,
										String expireDateColumnName){
		
		HtmlWriter html_writer = new HtmlWriter();
		
		writeEmailHeader(html_writer);
		writeTebleToHtml(html_writer, dongles_about_to_expire, expireDateColumnName);
		writeEmailBottomPart(html_writer);
		 
		 return html_writer;
	}
	
	/**
	*	EmilK
	*	write email header
	**/
	private void writeEmailHeader(HtmlWriter html_writer){
		
		// write email title
		HtmlParagrapth head_paragraph = html_writer.addParagraph();
		head_paragraph.Text = '<b>Dear Reseller,</b>';
		
		HtmlParagrapth title_paragraph = html_writer.addParagraph();
		
		String expireDateColumnName;
		String mailHeader;
		// Set mail subject and header of expire mode
		if (m_mode == ExpireDateOnDongles.CheckMode.ExpireDay){
			
			// write mail header
			mailHeader = 'The following licenses are about to expire.'+
						'<p>Please make sure to extend them so your customers will not be affected.';
		}
		// else - Set mail subject and header of subscription mode
		else{
			// add subscription paragraph
			HtmlParagrapth subscription_paragraph = html_writer.addParagraph();
			subscription_paragraph.Text = 'In order to keep your customers receiving software updates and the best service available,<br>'
						+'please renew them as soon as possible.';
			// write mail header
			mailHeader = 'Subscription for the following licenses is about to expire.';
		}
		// write mail body as HTML string
		title_paragraph.Text = mailHeader;
	}
	
	/**
	*	EmilK
	*	write expiring dongles table on html format
	**/
	private void writeTebleToHtml(HtmlWriter html_writer,
								 /* Account resellerAccount,*/ 
								  map<Id, DongleAccountData> dongles_about_to_expire,
								  String expireDateColumnName){
	
		HtmlTable html_table = html_writer.addTable();
		// set table border 2 pixels
		html_table.BorderWidth = 2;
		// add table columns 
		html_table.addColumn('Dongle / Product key');
		html_table.addColumn('Customer');
		html_table.addColumn('Reseller');
		if (m_mode == ExpireDateOnDongles.CheckMode.ExpireDay){
			html_table.addColumn('Reason');
		}
		html_table.addColumn(expireDateColumnName);
		
		List<Dongle__c> dongles_list = new List<Dongle__c>();
		// get all dongles
		for (DongleAccountData anyData : dongles_about_to_expire.values()){
			dongles_list.add(anyData.dongleId);
		}
		// sort dongles according to Customer id
		ApexUtils.bubbleSort(new CustomerComparator(dongles_about_to_expire, m_mode), dongles_list);
		
		 for(Dongle__c any_dongle : dongles_list){
		 	DongleAccountData anyData = dongles_about_to_expire.get(any_dongle.Id);
		 	// create cells containing dongle number customer name and reseller name
			HtmlRow html_row = new HtmlRow();
			html_row.Cells.add(new HtmlCell(any_dongle.Name, false));
			html_row.Cells.add(new HtmlCell(anyData.customerName, false));
			
			if (anyData.subresellerName != null){
		 		// pud sebreseller name in table
		 		html_row.Cells.add(new HtmlCell(anyData.subresellerName, false));
			}
			else{
				html_row.Cells.add(new HtmlCell(anyData.resellerName, false));
			}
			if (m_mode == ExpireDateOnDongles.CheckMode.ExpireDay){
				html_row.Cells.add(new HtmlCell(any_dongle.Evaluation_Module__c, false));
			}
			DateTime dateToShow;
			if (m_mode == ExpireDateOnDongles.CheckMode.ExpireDay){
				// get dongle expire date
				dateToShow = any_dongle.Dongle_Expiry_Date__c;		
			}
			// else - get dongle maintence date
			else{
				dateToShow = any_dongle.New_Maintenance_End_Date__c;
			}
			String expireDateString = '';
			if (dateToShow == null){
				System.debug('dongle null = '+any_dongle.Name);
			}
			// convert date to readable format
			else{
				expireDateString = dateToShow.format('dd/MM/yyyy');
			}
			html_row.Cells.add(new HtmlCell(expireDateString, false));
			
			html_table.Rows.add(html_row);
		 }
	}
	
	/**
	*	EmilK
	*	write Email Bottom Part
	**/
	private void writeEmailBottomPart(HtmlWriter html_writer){
		 	
		 // add bottom paragraphs with "best regrades" ect. 
		 HtmlParagrapth bottom_paragraph = html_writer.addParagraph();
		 bottom_paragraph.Text = '<b>Best Regards,<br>SolidCAM Team</b>';
	
	}
	

}