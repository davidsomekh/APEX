@isTest
public with sharing class SolidWorksTester 
{
	
	static testMethod void myTest() 
	{
		Opportunity opp = new Opportunity();
    	opp.name='testswporucccc';
    	opp.StageName='test';
    	opp.Licens_type__c	= 'USB Dongle';
    	opp.CloseDate=Date.today();
    	opp.Order_Type__c = 'Subscription';
    	insert opp;
    	
    	SolidWork_Order__c SW = new SolidWork_Order__c();
    	SW.name = 'textapex';
    	SW.Country__c = 'Israel';
    	SW.Date_Of_Order__c = Date.today();
    	SW.Customer_1__c = '00120000004pku0';
    	SW.Maintenance_Start_Date__c = Date.today();
    	SW.Reseller_order__c = '006D000000dyNIJ';
    	
    	insert SW;
    	
    	List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry 
    	WHERE Product2Id='01uD000000Rel9E' AND PriceBook2.isStandard=false LIMIT 1];    	
    	OpportunityLineItem line = new OpportunityLineItem();
    	line.OpportunityId = opp.id;
    	//line.Product2Id = 01uD000000Rel9P;
    	//insert line;
    	
	}
}