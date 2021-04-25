@IsTest
private class ExpireDateOnDonglesTester {

	static testmethod void runTest()
	{
		// create dummy account of a reseller
		Account testAccount = new Account(Name = 'simon', Type = 'Customer',ShippingCountry = 'Germany');
		insert testAccount;
		// get Sales object
		Sales__c seals_obj = [Select Id From Sales__c limit 1];
		// create new dummy dongle
		Date todayDate = Date.today();
		Date expirteDate = date.newInstance(todayDate.year(), todayDate.month(), (todayDate.day()+ 10));
	 	
		Dongle__c dummyDongle = new Dongle__c(Name = '666', 
											  Orders__c = seals_obj.Id, 
											  Serial_No__c = '212' , 
											  Date_Of_Order__c = todayDate,
											  Supply_Status__c = 'Loan',
											  Dongle_Type__c = 'USB',
											  Version__c = '2010',
											  Reseller__c = testAccount.Id,
											  Customer__c = testAccount.Id,
											  Evaluation_Module__c = 'HSM',
											  Maintance__c = 'None',
											  Dongle_Expiry_Date__c = expirteDate);
		insert dummyDongle;
	
		//ExpireDateOnDongles dongle_expireDate = new ExpireDateOnDongles(60, ExpireDateOnDongles.CheckMode.Subscription);
  		ExpireDateOnDongles dongle_expireDate2 = new ExpireDateOnDongles(14, ExpireDateOnDongles.CheckMode.ExpireDay);
  		dongle_expireDate2.Limitation = '10';
  		// finaly - test batch part of the class
   		Test.startTest();
		 ID batch_job_id2 = Database.executeBatch(dongle_expireDate2, 30);
   		Test.stopTest();
   	 
   		// check manualy Batch!
   		List<Dongle__c> dongles = [Select Id, Customer__c , Reseller__c, SubReseller__c, Name,
   									Reseller_Country__c, Dongle_Expiry_Date__c
								From Dongle__c 
								Where IsRelevant_Expiry__c = 1 And Dongle_Expiry_Date__c >= TODAY 
								And Dongle_Expiry_Date__c <= NEXT_N_DAYS:14 limit 10]; 
   		
   		 // dongle_expireDate2.treate_about_to_expire_dongles(dongles);
   		// test html code producing
   		test_html_writer();
   		
		List<Contact> contacts = [Select Email From Contact Where Email != null limit 4];
		
		// test coding of emails
		Automation_Mails__c newEmail = new Automation_Mails__c();
		newEmail.Account__c = [Select Id from Account limit 1][0].Id;
		newEmail.CC__c = contacts[0].Email;
		newEmail.BCC__c = contacts[1].Email;
		newEmail.To__c = contacts[2].Email+'\n'+ contacts[3].Email;
		
		// insert new mail
		insert newEmail;
		
		String code1 = ApexUtils.get_map_email_key(newEmail);
		System.debug('code1 = '+code1);	
		
		Automation_Mails__c newEmail2 = new Automation_Mails__c();
		newEmail2.CC__c = newEmail.CC__c;
		newEmail2.BCC__c = newEmail.BCC__c;
		newEmail2.To__c = contacts[3].Email+'\n'+ contacts[2].Email;
		
		String code2 = ApexUtils.get_map_email_key(newEmail2);
		System.assert(code1 == code2);	
		
		System.debug('code2 = '+code2);
		
		delete dummyDongle;
	}
	
	public static void test_html_writer(){
		HtmlWriter html_writer = new HtmlWriter();
		
		HtmlTable html_table = html_writer.addTable();
		// set table border 2 pixels
		html_table.BorderWidth = 2;
		// add table columns 
		html_table.addColumn('Dongle Number');
		html_table.addColumn('Customer Name');
		html_table.addColumn('Reseller');
		
		HtmlParagrapth head_paragraph = html_writer.addParagraph();
		head_paragraph.Text = '<b>Dear Reseller,</b>';
		
		HtmlLink link = html_writer.addLink();
		link.Height = 3;
		link.Title = 'google';
		link.Url = 'www.google.com';
		html_writer.ToHtmlString();
	}
}