/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Stock_dongles_test {

    static testMethod void myUnitTest() {
         Stock_dongles s = new Stock_dongles();
         Opportunity opp = new Opportunity();
    	opp.name='test';
    	opp.StageName='test';
    	opp.CloseDate=Date.today();
    	opp.Licens_type__c	= 'USB Dongle';
    	opp.Stock_numbres__c='1234512345';
    	opp.Dongles_type__c = 'Network 50';
    	opp.Reseller__c = '00120000003k3Pm';
    	opp.Order_Type__c = 'Subscription';
    	insert opp;
    	
    	DeletePK.DeleteKey('ddd',true);
    	
    	Opportunity opp2 = new Opportunity();
		opp2.name='test';
		opp2.AccountID='00120000003m5Uv';
		opp2.StageName='test';
		opp2.Final_Price__c = 50;
	   	opp2.CloseDate=Date.today();
    	opp2.Licens_type__c	= 'USB Dongle';
    	opp2.Stock_numbres__c='1239512345';
    	opp2.Dongles_type__c = 'Standalone';
    	opp2.Reseller__c = '00120000003k3Pm';
    	opp2.Order_Type__c = 'Subscription';
		insert opp2;
		

		Id pricebookId = Test.getStandardPricebookId();

		//Create your product
		Product2 prod = new Product2(
			Name = 'Product X',
			ProductCode = 'Pro-X',
			isActive = true
		);
		insert prod;

		//Create your pricebook entry
		PricebookEntry pbEntry = new PricebookEntry(
			Pricebook2Id = pricebookId,
			Product2Id = prod.Id,
			UnitPrice = 10,
			IsActive = true
		);
		insert pbEntry;

		//create your opportunity line item.  This assumes you already have an opportunity created, called opp
		OpportunityLineItem oli = new OpportunityLineItem(
			OpportunityId = opp2.Id,
			Quantity = 5,
			PricebookEntryId = pbEntry.Id,
			TotalPrice = 5 * pbEntry.UnitPrice
		);
		insert oli;

		delete opp2;

    	 
    	 dongle__c RECORD = new dongle__c(Name='testmethod123',Evaluation__c=true,Dongle_Expiry_Date__c	=date.newInstance(1990, 11, 21),Evaluation_Module__c='Payment',	Serial_No__c = '1233', 	Date_Of_Order__c = date.today(),Supply_Status__c = 'Purchase',Version__c = '190' ,Reseller__c = '00120000003k3Nm',Customer__c = '00120000003k3Nm' ,Order__c='006D000000ZQojP',Net_Dongle__c = true,Network_Profiles_Dongle__c =true,Actual_Users__c=2,Dongle_Type__c='MINI-NETUSB');
    	 insert RECORD;
    	
    //   Opportunity  Opp = [Select Stock_numbres__c,Reseller__c,Description From Opportunity Where Id =: '006D000000ZQojPIAT'][0];
    //    Opportunity tester =  [Select Stock_numbres__c,Reseller__c,Description From Opportunity Where id = '006D000000ZQojP'];
         s.Import(opp,true,RECORD);
         s.IsNetwork(opp2);
         s.GetDongleType(opp2);
         s.Import(opp2,true,RECORD);
        
    }
}