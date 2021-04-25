@isTest
private class Test_SystemSelectionComponent {

    static testMethod void myUnitTest() {
        
        Account testAccount = new Account(name='Test Company Name',shippingcountry='Koria');
        insert testAccount;
        
        Contact testContact = new Contact(Type_Of_Contact__c='Customer',Lastname='Test Last Name',AccountId=testAccount.Id);
        insert testContact;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = new Product2(Name = 'Laptop X200',Family = 'Hardware',Description='123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X201',Family = 'Hardware',Every_Bundle__c=true,Description='123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890');
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Laptop X202',Family = 'Hardware',Every_Bundle__c=true);
        insert prod2;
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true,CurrencyIsoCode='USD');
        insert standardPrice;
         PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true,CurrencyIsoCode='USD');
        insert standardPrice1;
         PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true,CurrencyIsoCode='USD');
        insert standardPrice2;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true,CurrencyIsoCode='USD');
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true,CurrencyIsoCode='USD');
        insert customPrice;
        
        PricebookEntry customPrice1= new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod1.Id,UnitPrice = 12000, IsActive = true,CurrencyIsoCode='USD');
        insert customPrice1;
        PricebookEntry customPrice2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod2.Id,UnitPrice = 12000, IsActive = true,CurrencyIsoCode='USD');
        insert customPrice2;
        
        Bundle__c testBundle = new Bundle__c(CurrencyIsoCode='USD',Name='my Bundle',Price_Book__c=customPB.Id);
        insert testBundle;
        
        Opportunity testOpportunity = new Opportunity(Licens_type__c	= 'USB Dongle',Name='Test Opp Name',primary_bundle__c=testBundle.Id,Type='New Customer', Reseller__c=testAccount.Id,CloseDate=date.today().addDays(10),StageName='A Power Promoter Prospect',Dongle_Details__c='Test Opportunity',CurrencyIsoCode='USD', Pricebook2Id=customPrice.Pricebook2Id);
        testOpportunity.Order_Type__c = 'Subscription';
        insert testOpportunity;
        
        Optional_Ad_Ons__c testOptional = new Optional_Ad_Ons__c(  Bundle__c=testBundle.Id,Product__c=prod.Id);
        insert testOptional;
        
        Included_Product__c testInclude = new Included_Product__c(Product__c=prod.Id,Bundle__c=testBundle.Id,Quantity__c=10,CurrencyIsoCode='USD');
        insert testInclude;
        
        OpportunityLineItem testOppItem = new OpportunityLineItem(Quantity=13,UnitPrice=1100,Included_Product__c=testInclude.Id,OpportunityId=testOpportunity.Id,PriceBookEntryId=customPrice.id);
        insert testOppItem;
        
        OpportunityLineItem testOppItem1 = new OpportunityLineItem(Quantity=13,UnitPrice=1200,Optional_Ad_Ons__c=testOptional.Id,OpportunityId=testOpportunity.Id,PriceBookEntryId=customPrice.id);
        insert testOppItem1;
        
        OpportunityLineItem testOppItem2 = new OpportunityLineItem(Quantity=13,UnitPrice=1300,Product__c=prod.Id,OpportunityId=testOpportunity.Id,PriceBookEntryId=customPrice.id);
        insert testOppItem2;
        
          
        List<Bundle__c> bundlelist=new List<Bundle__c>(); 
        for(integer i=0;i<=10;i++)
        {
        Bundle__c testBundle1 = new Bundle__c(CurrencyIsoCode='USD',Name='Test Bundle',Price_Book__c=testOpportunity.Pricebook2Id);
        bundlelist.add(testBundle1 );
        }
        insert bundlelist;
             
        ApexPages.currentPage().getParameters().put('id', testOpportunity.Id);
        Ctrl_SystemSelectionComponent controller = new Ctrl_SystemSelectionComponent();
       
                   
        controller.selectedBundleId=testBundle.Id;
        controller.selectedPicebookIds=customPB.Id;
        controller.callBundlesPicklist();
        controller.clearProducts();
        controller.DisplayRelatedOptionalAdOnProducts();
        controller.updateTotalOfProducts();
        controller.updateTotal();
        controller.methodOne();
        controller.listOfOptionalAdOnWrapper[0].quantity =1;
        system.debug('** ' +controller.allProductsEveryBundleCheckboxcheckedList);
        controller.allProductsEveryBundleCheckboxcheckedList[0].product.Quantity__C=2;
        controller.Bundlequantity=2;
        controller.dispProducts();
        OpportunityLineItem testOppItem4 = new OpportunityLineItem(Quantity=13,UnitPrice=1100,Included_Product__c=testInclude.Id,OpportunityId=testOpportunity.Id,PriceBookEntryId=customPrice.id);
        insert testOppItem4;
        
        OpportunityLineItem testOppItem5 = new OpportunityLineItem(Quantity=13,UnitPrice=1200,Optional_Ad_Ons__c=testOptional.Id,OpportunityId=testOpportunity.Id,PriceBookEntryId=customPrice.id);
        insert testOppItem5;
        
        OpportunityLineItem testOppItem6 = new OpportunityLineItem(Quantity=13,UnitPrice=1300,Product__c=prod.Id,OpportunityId=testOpportunity.Id,PriceBookEntryId=customPrice.id);
        insert testOppItem6;
        
        controller.listOfOptionalAdOnWrapper[0].quantity =1;
        controller.allProductsEveryBundleCheckboxcheckedList[0].quantity=2;
        controller.doupdateAllProductRecords();
       

    }
   
    

}