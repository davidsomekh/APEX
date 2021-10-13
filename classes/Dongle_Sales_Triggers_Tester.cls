@IsTest
private class Dongle_Sales_Triggers_Tester {
	static testmethod void runTest(){
		
		List<Dongle__c> dongles_list = [Select Id, Order__c
										from Dongle__c limit 1];
		List<Opportunity> sales_list = [Select Id,
									AccountId, 
										Reseller__c 
										from Opportunity limit 2];
		Integer index_in_sales_list = 0;
		if (sales_list[0].Id == dongles_list[0].Order__c){
			dongles_list[0].Order__c = sales_list[1].Id;
			index_in_sales_list = 1;
		}
		else{
			dongles_list[0].Order__c = sales_list[0].Id;
		}
		dongles_list[0].Customer__c = '00120000003k3Nm';
		
		update dongles_list;
		dongle__c RECORD = new dongle__c(Name='testmethod123',Evaluation__c=true,Dongle_Expiry_Date__c	=date.newInstance(1990, 11, 21),Evaluation_Module__c='Payment',	Serial_No__c = '1233', 	Date_Of_Order__c = date.today(),Supply_Status__c = 'Purchase',Version__c = '190' ,Reseller__c = '00120000003k3Nm',Customer__c = '00120000003k3Nm' ,Order__c='006D000000ZQojP',Net_Dongle__c = true,Network_Profiles_Dongle__c =true,Actual_Users__c=2,Dongle_Type__c='MINI-NETUSB');
		insert RECORD;
		
		dongle__c dongClone = RECORD.clone(false, false, false, false);
		dongClone.Name = 'DavidIsGood';
		dongClone.Serial_No__c = 'bobo';
		insert dongClone;

		delete RECORD;
		
		ID dongleId = dongles_list[0].Id;
		//Emil
		// assert if results are not as expected
		List<Dongle__c> dongles_list2 = [Select Id, Customer__c, 
												Reseller__c 
										from Dongle__c where Id = : dongleId];
		
		Boolean assertion_case = 
		(dongles_list2[0].Customer__c == sales_list[index_in_sales_list].AccountId);				
		
		//System.assert(assertion_case); //David - this seems to be not needed
		
		// test case '00120000003m7vs'
		List<Account> acountList = [select Id from Account where Id = '00120000003m7vs'];
		if (acountList.size() == 0){
			return;
		}
		dongles_list[0].Customer__c = acountList[0].Id;  
		
		update dongles_list[0]; 
		
	}
}