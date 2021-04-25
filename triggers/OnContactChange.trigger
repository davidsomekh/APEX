/*************************************************
*	EmilK
*	update number of contacts in account - assuming no more that 998 
*	contacts. if so this trigger will crush.
*	there is another version that works for ever number of xontacts
*	but I found one buggy case.
*************************************************/
trigger OnContactChange on Contact (after delete, 
									before insert,
									before update,
									after insert, 
									after undelete, 
									after update) {
										
	List<ID> affected_account_ids = new List<ID>();
	ID new_Account_id;
	
	// before inserting to the system we want to chek only the email address
	if ((Trigger.isInsert || (Trigger.isUpdate && !Test.isRunningTest())) && Trigger.isBefore)
	{
		if(Trigger.isInsert ||(Trigger.isUpdate && Trigger.new[0].Email != Trigger.old[0].Email))
			ContactUtils.check_contacts_email(Trigger.new[0]);
		return;
	}
	
	if (Trigger.isDelete) {
		new_Account_id = Trigger.old[0].AccountId;
	}
	else{
		new_Account_id = Trigger.new[0].AccountId;	
	}
	affected_account_ids.add(new_Account_id);
	
	// if we upodate an contact
	if (Trigger.isUpdate){
		ID old_Account_id = Trigger.old[0].AccountId;
		// if account id has been changed update the old account also
		if (new_Account_id != old_Account_id){
			affected_account_ids.add(old_Account_id);
		}
	}

	// Get accounts that will be modified
	List<Account> accountsList = [Select Id ,Number_of_Contacts__c ,
										Gelilot_attendees__c,
										North_register__c
								  from Account 
								  where Id in :affected_account_ids];
								  
	// loop other the account that will be updated
	// 12.4.2012 - added 2 more queries. Those may be replaced in a 
	for(Account anyAccount : accountsList){
		anyAccount.Number_of_Contacts__c = 0;
		anyAccount.Gelilot_attendees__c  = 0;
		anyAccount.North_register__c     = 0;
		// Take list of Contacts that belong to account
		List<Contact> contactsOfAccount = [Select Gelilot_attendees__c,
											 North_Conferens__c, Email
											From Contact 
											where AccountId = :anyAccount.Id];
		// Update data in account according to contact
		for (Contact anyContact : contactsOfAccount){
			if (!String.isEmpty(anyContact.Email))
				anyAccount.Number_of_Contacts__c++;
		}
	}
	update accountsList;
}