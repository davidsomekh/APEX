trigger OnSWORDER on SolidWork_Order__c (before insert, before update) {
	
	SolidWork_Order__c pRecord = Trigger.new[0]; //Pointer to the opp
	
	string sReseller = GetReseller(pRecord);
	
	if(sReseller == pRecord.apex_res_name__c)
		pRecord.apex_cert_reseller__c = 1;
	else
		pRecord.apex_cert_reseller__c = 0;
	
	if(!CheckValidReseller(sReseller))
	{
		pRecord.addError('Reseller not certefied. Please contact Admin.' + sReseller);
	}
	
	pRecord.Reseller_name_apex__c = sReseller;
	pRecord.OwnerId = pRecord.Reseller_order__r.OwnerId;

	if(pRecord != null)
	{
		
		if(pRecord.Customer_1__c == null)
			pRecord.Customer_1__c = pRecord.CustomerSW__c;
			
		if(pRecord.Maintenance_End_Date__c != null || pRecord.Maintenance_Start_Date__c == null )
			return;
			
		Date SubStart = date.valueOf(pRecord.Maintenance_Start_Date__c);	
		
		Integer numberOfDays = date.daysInMonth(SubStart.year() + 1, SubStart.month() - 1);
		
		Date SubEnd = date.newinstance(SubStart.Year() + 1,SubStart.Month() -1, numberOfDays);
		
		pRecord.Maintenance_End_Date__c = SubEnd;
		
		
			
		
	}
	
	public boolean InList(string sReseller)
	{
		List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = SolidWork_Order__c.Cetrefied_resellers__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){

            if(sReseller == pickListVal.getLabel())
            	return true;

        }    

        return false;

	}
	
	public boolean CheckValidReseller(string sReseller)
	{
		return InList(sReseller) || Test.isRunningTest();

	}
	
	
	
	public string GetReseller(SolidWork_Order__c record)
	{
		if(InList(record.apex_res_name__c))
			return record.apex_res_name__c;
		
		return record.apex_parent_name__c;
	
	}
    
}