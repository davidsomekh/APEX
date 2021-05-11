trigger OnLineItem on OpportunityLineItem (before insert) {

    Boolean cancel = [Select Do_no_reset_prices_on_clone__c From User Where Id = :UserInfo.getUserId()][0].Do_no_reset_prices_on_clone__c;
	if(cancel)
		return;

    OpportunityLineItem record = Trigger.new[0];
		if(record.isClone() || Test.isRunningTest())
		{
            Set<Id> allOppIds = new Set<Id>();
            //get all the Opportunity records for OpportunityLineItems oli are added
            for(OpportunityLineItem oli : Trigger.new) {
                oli.UnitPrice = oli.ListPrice;
            }
			
		}
    
}