@isTest
private class GeneratePKSyncTest {

    static testMethod void myUnitTest() {
       GeneratePKSync PKS = new GeneratePKSync();
       dongle__c	[] LIST_DONGLES = new List<dongle__c	>();
       
       dongle__c RECORD = new dongle__c(Name='testmethod1234',	Serial_No__c = '1233', 	Date_Of_Order__c = date.today(),Supply_Status__c = 'Purchase',Version__c = '190' ,Reseller__c = '00120000003k3Nm',Customer__c = '00120000003k3Nm' ,Order__c='006D000000ZQojP' );
	   LIST_DONGLES.add(RECORD);
	   insert LIST_DONGLES;
	   
	   dongle__c tester;
	   
	   List<Dongle__c> arrDongles = [Select Id
	   From Dongle__c	Where Name = 'testmethod1234' Limit 1];
	   
	    if(arrDongles.size() > 0)
	   	{
	   		tester = arrDongles[0];
	  		PKS.GetDongle(tester.Id);
	  		PKS.Web('dave',tester,true);
	  		
	    }
    }
}