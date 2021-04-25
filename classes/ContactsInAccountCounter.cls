/* **********************************************************************
* EmilK 
* Schedulable class that enables to count number of contacts of an account 
* 
*************************************************************************/
global class ContactsInAccountCounter implements Database.Batchable<sObject>, 
									Schedulable, Database.Stateful{
										
	private String m_query;
	
	public String Query{
		set{m_query = value;}
		get{return m_query;}
	} 
	
	/*
	*	EmilK
	*	start
	*/
	global Database.Querylocator start(Database.BatchableContext BC)
	{
		System.debug('Query #31 - ContactsInAccountCounter');
		if (m_query == null){
			// Get All Accounts 
			m_query = 'Select Id, Number_of_Contacts__c from Account';
		}
		return Database.getQueryLocator(m_query);
	}
	
	/*
	*	EmilK
	*	execute
	*/
	global void execute(Database.BatchableContext BC, List<sObject> scope)
	{
			List<Account> accounts_to_update = new List<Account>();
			// loop over all accounts
			for (sObject sobj : scope){
				Account anyAccount = (Account)sobj;
				ID any_account_id = anyAccount.Id; 
				// assumnig no more than 200 contacts to each account - else we get CRASH
				List<Contact> contactsInAccountList  =
				 											[select Email 
									   						from Contact 
									   						where AccountId = : any_account_id];
									   						
				Integer numContacts = 0;
				// Remove from list account with empty email
				for (Contact c : contactsInAccountList){
					if (!String.isEmpty(c.Email) )
						numContacts++;
				}
				Decimal account_contacts_num = anyAccount.Number_of_Contacts__c;
				if (account_contacts_num == null || account_contacts_num != numContacts)
				{
					// update number of contacts in account
					anyAccount.Number_of_Contacts__c = numContacts;
					accounts_to_update.add(anyAccount);
				}
			}
			
			if (accounts_to_update.size() > 0){
				update accounts_to_update;
			}
	}
	
	/** 
	*	EmilK
	*	finish
	*/
	global void finish(Database.BatchableContext BC){}
	
		/**
	 implementation of execute - required by SChedulable interface
	*/
	global void execute(SchedulableContext sc){
		
		ContactsInAccountCounter notifier = new ContactsInAccountCounter();
   		database.executebatch(notifier, 100);
	}
}