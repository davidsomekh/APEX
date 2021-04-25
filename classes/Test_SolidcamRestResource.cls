@isTest(seeAllData=true)
private class Test_SolidcamRestResource {

    static testMethod void myUnitTest() {
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
    	String accId = '001D000002Fchx8';//[select Reseller__c from Dongle__c][0].Reseller__c;
    	
    	req.requestURI = 'https://cs7.salesforce.com/services/apexrest/Reseller/' + accId;  
    	req.httpMethod = 'GET';
    	RestContext.request = req;
    	RestContext.response = res;
    	
    	SolidcamRestResource.doGet();
    }
    
    static testMethod void myUnitTestAll() {
        RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
    	req.requestURI = 'https://cs7.salesforce.com/services/apexrest/Reseller/all';  
    	req.httpMethod = 'GET';
    	RestContext.request = req;
    	RestContext.response = res;
    	
    	SolidcamRestResource.doGet();
    }
}