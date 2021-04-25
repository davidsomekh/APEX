@IsTest
private class ContactsCounterTester {
	
	/*
	* EmilK - test the way contacts counter acts
	*/
	static testmethod void runTest(){
		
		ContactsInAccountCounter count_contacts = new ContactsInAccountCounter();
		count_contacts.Query = 'Select Id, Number_of_Contacts__c from Account limit 50';
		// Check batch methods
		Test.startTest();
						
   		ID batch_job_id = Database.executeBatch(count_contacts);
   	
   		Test.stopTest();
   		// get some account
   		List<Account> account_list = [Select Id from Account limit 2];
   		if (account_list.size() == 0){
   			return;
   		}
   		
   		Account testAccount = new Account(Name = 'simon', Type = 'Customer',ShippingCountry ='Germany');
		insert testAccount;
		
   		// test contacts trigger
   		Contact new_contact = new Contact();
   		new_contact.Type_Of_Contact__c = 'Customer';
   		new_contact.LastName = 'test_contact';
   		new_contact.AccountId = testAccount.Id;
		new_contact.Email = 'dsomekh@solidcam.com';
		insert new_contact;
		
		if (account_list.size() == 2){
			new_contact.AccountId = account_list[1].Id;
			update new_contact;
		}
		
		delete new_contact;					   
	}
}