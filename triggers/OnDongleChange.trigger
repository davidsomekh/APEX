/**********************************************************
*	EmilK - general dongle that acts on dongle
*			after ANY change in it
*
***********************************************************/
trigger OnDongleChange on Dongle__c (after insert, after update, after delete, after undelete) 
{
	if(Trigger.isInsert)
	{
		Dongle__c record = Trigger.new[0];
		if(record.isClone() || Test.isRunningTest())
		{
			//record.OnClone__c = true;
			Id OldRecord = record.getCloneSourceId();
			
			List<Profiles__c> pList = Database.query('SELECT ' + String.join(new List<String>(Schema.getGlobalDescribe().get('Profiles__c').getDescribe().fields.getMap().keySet()), ',') + ' FROM Profiles__c Where DongleNo__c =: OldRecord  ORDER BY Profile_No__c');
					
			for(Profiles__c Prof :pList)
			{
				Profiles__c p1 = Prof.clone(false, true, false, false);
				p1.DongleNo__c = record.Id;
				insert p1;
			}
		}
		
	}
	Boolean cancel = [Select Dont_run_dongle_trigger__c From User Where Id = :UserInfo.getUserId()][0].Dont_run_dongle_trigger__c;
	if(cancel)
		return;
	
	
	// EmilK
    // Hold list of dongles that fired that trigger        	
    List<Dongle__c> donglesList = new List<Dongle__c>();
    
	if (Trigger.isDelete){
		for(Dongle__c anyDongle :Trigger.old){
			if (anyDongle.Customer__c != null){
				donglesList.add(anyDongle);
			}
		}
	}
	else{
		donglesList.addAll(Trigger.new);
		
		if (Trigger.isUpdate){
			// Check if contumer id has been changed
			// on dongle update
			ID oldCustomerId = Trigger.old[0].Customer__c;
			if (oldCustomerId != null && oldCustomerId != donglesList[0].Customer__c){
				// Add the last account id to account id list
				// in order to update the account to a correct value
				donglesList.add(Trigger.old[0]);
			}
		}
	}
	// update account number of subs
	DongleUpdateNotifier notifier = new DongleUpdateNotifier();
	notifier.update_all_dongles_counters(donglesList);    
}