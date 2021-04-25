trigger OnDongleDelete on Dongle__c (before delete) {
	
	List<Dongle__c> donglesList = new List<Dongle__c>();
	//DeletePK remove = new DeletePK();
	
	for(Dongle__c record : Trigger.old)
	{
		if(record.Sentinel__c)
			record.addError('Please use the "delete product key" button to delete software licenses.');
		
			
		
		
		
	}

    
}