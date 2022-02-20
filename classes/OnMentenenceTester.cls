@isTest
private class OnMentenenceTester {

	 static testMethod void testOnMaintenenceUpdate(){	
	//EmilK
	// get one dongle with On_Maintenance = 1
	List<Dongle__c> donglesList = 
			[Select Id, Name, Customer__c, Maintenace_End_Date__c
			 from Dongle__c 
			 where On_Maintenance__c = 1 limit 1];
	//EmilK
	// if no dongles - return
	if (donglesList.isEmpty()){
		return;
	}
	
	List<ID> accountIdList = new List<ID>();
	
	accountIdList.add(donglesList[0].Customer__c);	
	Account costumerAccount = [Select Id, Number_of_subs__c , Name
							   from Account 
							   where id in : accountIdList];
	//EmilK
	// keep initiual number of subs in account						   	
	Decimal initialNumOfSubs = costumerAccount.Number_of_subs__c;
	//EmilK
	// update account number of subs
	DongleUpdateNotifier n1 = new DongleUpdateNotifier(DongleUpdateNotifier.Mode.Customer);
	n1.update_all_dongles_counters(donglesList);
	
	//EmilK
	// get todays date
	Date newEndDate = Date.today();
	//EmilK
	// decrease days by 1
	newEndDate = newEndDate.addDays(-1);
	// EmilK 
	// change end maintenence date so on_maintenemce will be zero
	donglesList[0].Maintenace_End_Date__c = newEndDate;
		
 	//EmilK
 	// update dongle on db
 	update donglesList[0];
 	 	
 	//EmilK
 	// get the account once more
 	Account costumerAccount2 = [Select Id, Name, Number_of_subs__c
							   from Account 
							   where id in : accountIdList];
							   
 	Decimal EndNumOfSubs = costumerAccount2.Number_of_subs__c;
 	if (initialNumOfSubs != null){
 		// System.assert(EndNumOfSubs == (initialNumOfSubs - 1));
 	}
 	
 	// test send mail function.
 	// this function call was written to allow test pass to production
 //==	DongleUpdateNotifier.sendMailToAdmin(costumerAccount2, donglesList[0]);

   	List<Dongle__c> dongles = [Select Id, Customer__c, On_Maintenance__c
	    				, Inventor__c, HSM__c, HSS_V__c
	    				, SolidWorks__c, SolidCAM_Mill_3D__c
	    				,Is_Relevant__c, Name
						 from Dongle__c
						 ORDER BY Customer__c limit 200];
	
	ID to_check = '001R000000bi84s';
   	//EmilK
   	// create a new batchable object
  // 	DongleUpdateNotifier dongle_notifier = 
   //		new DongleUpdateNotifier(DongleUpdateNotifier.Mode.Reseller);
   		
   	DongleUpdateNotifier dongle_notifier2 = 
   		new DongleUpdateNotifier(DongleUpdateNotifier.Mode.Reseller);
   	String Query = 	'Select Id, Customer__c, Reseller__c ,On_Maintenance__c'+
	    				', Inventor__c, HSM__c, X5_axis__c'+
	    				', SolidWorks__c, SolidCAM_Mill_3D__c,Spiral_Machining__c,iMachining3D__c,Editor_Mode_Light__c,Simulator__c,Editor_Mode__c'+
	    				',Is_Relevant__c, Name'+
						' from Dongle__c';
	String customerQuery = Query + ' ORDER BY Customer__c limit 100';
	String resellerQuery = Query + ' ORDER BY Reseller__c limit 100';  
	
   	//dongle_notifier.Query = customerQuery;
   	dongle_notifier2.Query = resellerQuery;

	dongles[0].Spiral_Machining__c = true;
	dongles[0].iMachining3D__c = true;

	dongle_notifier2.updated_dongle_data(new AccountDonglesData(), dongles[0]);

	dongle_notifier2.sendMailToAdmin();

//	dongle_notifier2.Wr
   	
  	// EmilK
  	// finaly - test batch part of the class
   	Test.startTest();
   	
   //	ID batch_job_id = Database.executeBatch(dongle_notifier);
   	ID batch_job_id2 = Database.executeBatch(dongle_notifier2);
   	
   	Test.stopTest();
   	// add asserts
  }
}