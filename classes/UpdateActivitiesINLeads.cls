/********************************************************************
*	EmilK
*	This class updates the number of tasks in every Lead object
*	Notice : For now it is assumed that every lead has no more than 100
*	Tasks.
********************************************************************/

global class UpdateActivitiesINLeads implements Schedulable, 
												Database.Batchable<sObject>, 
												Database.Stateful{
	
	/**
	*	EmilK
	*	test method
	***/
	public static testMethod void testMe(){
	 	UpdateActivitiesINLeads leads_test = new UpdateActivitiesINLeads();
  		// finaly - test batch part of the class
   		Test.startTest();
						
   		ID batch_job_id = Database.executeBatch(leads_test);
   		Test.stopTest();
   		
   		// test sending mail
   		leads_test.sendmail('epes',null);
	}
	
	/*
	*	EmilK
	*	Start
	*/
	global Database.Querylocator start(Database.BatchableContext BC)
	{
	 
		System.debug('Query #9 - UpdateActivitiesINLeads');
		String query = 'Select Id ,LastName ,Number_of_Activities__c'+
					  ' From Lead ';
		return Database.getQueryLocator(query);
	}
	
	/**
	*	EmilK
	*	execute Batch
	**/
	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{
		List<Lead> lead_list = new List<Lead>();
		
		for(sObject sobj : scope){
			lead_list.add((Lead)sobj);
		}
		update_Activities(lead_list);
	}
	
	/**
	*	EmilK
	*	finish batch
	**/
	global void finish(Database.BatchableContext BC){
	}
	
	/**
	*	EmilK
	*	execute - schdulable
	**/
	global void execute(SchedulableContext SC){
		UpdateActivitiesINLeads updateLeads = 
				  new UpdateActivitiesINLeads();
   		database.executebatch(updateLeads, 100);
	}
	
	/**
	*	EmilK
	*	update activities
	**/
	private void update_Activities(List<Lead> current_leads){
		
		List<ID> leads_ids = new List<ID>();
		
		List<Lead> leads_to_update = new List<Lead>();
		
		for(Lead anyLead : current_leads){
			 ID lead_id = anyLead.Id;
			 // get number of activities in system with this lead
			 System.debug('Query #10 - UpdateActivitiesINLeads');
			 Integer numActivities = [Select count() 
			 						  from Task 
			 						  where WhoId =: lead_id limit 100];
			 // update number of tasks
			 Decimal currentActivities = anyLead.Number_of_Activities__c;
			 if (currentActivities == null || currentActivities != numActivities){
			 	anyLead.Number_of_Activities__c = numActivities;
			 	leads_to_update.add(anyLead);
			 }
			 try{
			 update anyLead;
			 }
			 catch(Exception e){
			 	//System.debug('Error: lead name'+anyLead.LastName+' id = '+anyLead.Id);
			 	//System.debug('Exception = '+e.getMessage());
			 	sendmail(anyLead.LastName, anyLead.Id);
			 }
		}
		
		//update leads_to_update;
	}
	
	public void sendmail(String name, ID object_id){
		Messaging.Singleemailmessage mailToSend = new Messaging.Singleemailmessage();
			 	
			 	String[] mailAdresses = 
					new String[] {'emil.kalin@solidcam.com'}; 
				// set adresses to which the mail will be sent
				mailToSend.setToAddresses(mailAdresses);
				// set sender display name
				mailToSend.setSenderDisplayName('Solidcam - salesforce enviroment');
 
			 	mailToSend.setSubject('BUG');
				mailToSend.setHtmlBody('<p>Exception while updating: '+name+' id '+object_id+ '</p>');
		
				mailToSend.setBccSender(false); 
				// send mail
				Messaging.Singleemailmessage[] mails = new Messaging.Singleemailmessage[]{mailToSend};
				Messaging.sendEmail(mails, false);
	}
}