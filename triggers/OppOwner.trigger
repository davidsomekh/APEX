trigger OppOwner on Opportunity (before insert, before update) {
	
	Opportunity pCurrentOPP = Trigger.new[0]; //Pointer to the opp

	if(pCurrentOPP != null)
	{
		String owner = pCurrentOPP.Opp_owner__c;
		if(owner != null)
			pCurrentOPP.OwnerId = owner;
			
		if(pCurrentOPP.Requested_Amount__c > 1 && pCurrentOPP.OwnerId == '00520000000kQ84AAE')
		{
			pCurrentOPP.Transfer_price__c = integer.valueOf(pCurrentOPP.Requested_Amount__c);
		}
			
		if(pCurrentOPP.Subscription_end_date__c != null || pCurrentOPP.Subscription_start_date__c == null )
			return;
			
		Date SubStart = date.valueOf(pCurrentOPP.Subscription_start_date__c);	
		
		Integer numberOfDays = date.daysInMonth(SubStart.year() + 1, SubStart.month() - 1);
		
		Date SubEnd = date.newinstance(SubStart.Year() + 1,SubStart.Month() -1, numberOfDays);
		
		pCurrentOPP.Subscription_end_date__c = SubEnd;
		
		
			
		
	}
	
	

}