public class LeadsTriggerTester {
	static testmethod void runTest(){
		
		 Lead new_lead = new Lead();
		 
		 new_lead.LastName = 'lead1';
		 new_lead.Email = 'some.one@gmali.com';
		 new_lead.Company = 'Test';
		 new_lead.Country = 'United States';
		 new_lead.State = 'NY';
		 new_lead.LeadSource = 'Web site (SolidCAM)';
		// new_lead.Sales_Person__c = 'Momo';
		 
		 // insert lead with comments
		 Lead new_lead2 = new Lead();
		 new_lead2.LastName = 'lead1';
		 new_lead2.Comments__c = 'zulu';
		 new_lead2.Email = 'some.one2@gmali.com';
		 new_lead2.Company = 'Test';
		 new_lead2.Country = 'United States';
		 new_lead2.State = 'NYY';
		 new_lead2.LeadSource = 'Web site (SolidCAM)';

		 Lead new_lead3 = new Lead();
		 new_lead3.LastName = 'lead1';
		 new_lead3.Comments__c = 'zulu';
		 new_lead3.Email = 'some.one.test@gmali.com';
		 new_lead3.Company = 'Test2';
		 new_lead3.Country = 'US';
		 new_lead3.State = 'New York';
		 new_lead3.LeadSource = 'Facebook (Trial)';
		 
		 insert new_lead;
		 insert new_lead2;								   
		 insert new_lead3;
	}
}