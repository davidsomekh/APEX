@isTest(SeeAllData=true)
private class Dongle_Generate_Test {

    static testMethod void dongle_Generate_VF_And_Dongle_Version_Upsate_VF() {
    	Account acc = new Account();
    	acc.Name = 'testapextest';
    	acc.ShippingCountry = 'Germany';
    	insert acc;
    	Opportunity opp = new Opportunity();
    	opp.name='test';
    	opp.StageName='test';
    	opp.Licens_type__c	= 'USB Dongle';
    	opp.CloseDate=Date.today();
    	opp.Order_Type__c = 'Subscription';
    	insert opp;
    	Sales__c sales = new Sales__c();
    	sales.Name = 'test';
    	sales.Customer__c = acc.id;
    	insert sales;
    	Dongle__c dongle = new Dongle__c();
    	dongle.Name = 'test';
    	dongle.Serial_No__c ='1234';
    	dongle.Order__c = opp.id;
    	dongle.Orders__c = sales.id;
    	dongle.Reseller__c = acc.id;
    	dongle.Customer__c = acc.id;
    	dongle.Network_Profiles_Dongle__c = true;
    	dongle.Net_Dongle__c = true;
    	dongle.Actual_Users__c = 2;
    	insert dongle;
    	
        Profiles__c TestProfile = new Profiles__c();
    	
    	TestProfile.Profile_No__c = 2;
         TestProfile.DongleNo__c = dongle.id;
        TestProfile.Profile_Users__c = 2;
        
        insert TestProfile;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(dongle);
        Dongle_Generate ctrl = new Dongle_Generate(sc);
        
        ctrl.GetEureka3X(dongle);
        ctrl.GetEurekaMA1C(dongle);
       	ctrl.GetEurekaMAMC(dongle);
        
        ctrl.GetEureka3XProfile(TestProfile);
        ctrl.GetEurekaMA1CProfile(TestProfile);
        
        DongleAccountData d = new DongleAccountData();
    	
    	d.dongleId = dongle;
    	d.resellerName = 'dd';
    	d.subresellerName = 'dd';
    	d.customerName = 'dd';
    	d.to_string();
    	
    	HtmlTable HTML = new HtmlTable();
       	List<HtmlCell> l;
    	
    	l = HTML.Columns;
    	HTML.Columns = l;
    	
    	integer iii = HTML.BorderWidth;
    	
    	List<HtmlRow> ROW;
    	ROW = HTML.Rows;
    	HTML.Rows = ROW;
    	
        
        PageReference pageRef = Page.Dongle_Generate;
        pageRef.getParameters().put('id', String.valueOf(dongle.Id));
        Test.setCurrentPage(pageRef);
        
        ctrl.GenerateDongle();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
	    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
	    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
	    LocaleSidKey='en_US', ProfileId = p.Id,
	    TimeZoneSidKey='America/Los_Angeles', UserName='standardus@testorg.com');
	    insert u;
	    System.runAs(u) {
        	ctrl.updateDongle();
	    }
    }
    
    static testMethod void dongle_Generate_Batch() {
		test.startTest();
    	Account acc = new Account();
    	acc.Name = 'testapextest2';
    	acc.ShippingCountry = 'Germany';
    	insert acc;
    	Opportunity opp = new Opportunity();
    	opp.name='test';
    	opp.StageName='test';
    	opp.CloseDate=Date.today();
    	opp.Licens_type__c	= 'USB Dongle';
    	opp.Order_Type__c = 'Subscription';
    	insert opp;
    	Sales__c sales = new Sales__c();
    	sales.Name = 'test';
    	sales.Customer__c = acc.id;
    	insert sales;
    	Dongle__c dongle = new Dongle__c();
    	dongle.Name = 'test';
    	dongle.Serial_No__c ='1234';
    	dongle.Order__c = opp.id;
    	dongle.Orders__c = sales.id;
    	dongle.Reseller__c = acc.id;
    	dongle.Customer__c = acc.id;
		insert dongle;
		
    	Dongle_Batch ctrl = new Dongle_Batch(); 
        PageReference pageRef = Page.Dongle_Batch;
        Test.setCurrentPage(pageRef);
		ctrl.idList = dongle.Name ;
		ctrl.bInternalUse = false;
		ctrl.bVersion = false;
		ctrl.execBatch();
		ctrl.checkBatchStatus();

		Dongle_Batch ctrl2 = new Dongle_Batch(); 
	    Test.setCurrentPage(pageRef);
		ctrl2.bInternalUse = true;
		ctrl2.idList = dongle.Name ;
		ctrl2.bInternalUse = true;
		ctrl2.bVersion = false;
		ctrl2.execBatch();
		ctrl2.checkBatchStatus();

		Dongle_Batch ctrl3 = new Dongle_Batch(); 
	    Test.setCurrentPage(pageRef);
		ctrl3.bInternalUse = false;
		ctrl3.bVersion = true;
        ctrl3.idList = dongle.Name ;
		ctrl3.execBatch();
		ctrl3.checkBatchStatus();
	
    }
}