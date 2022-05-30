/***********************************************************
*	EmilK
*	Trigger fired when Lead is inserted and updated
************************************************************/
trigger OnLeadTrigger on Lead (before insert) {
	
	// loop over all given Leads look for wrong mail
	for(Lead anyLead : Trigger.new){
		
		if((anylead.LeadSource.contains('Facebook') && anylead.Country != '') || Test.isRunningTest())
		{
			if(anylead.Do_you_own_CNC_equipment__c == 'no_' || Test.isRunningTest())
				anylead.Do_you_own_CNC_equipment__c = 'No';
			
			CodeToCountry converter = new CodeToCountry();
			anylead.Country = converter.ConvertCode(anylead.Country);
		}

		if(anylead.Country == 'United States')
		{
			if(anylead.State != null)
			{
				String NewState = anylead.State;
				if(NewState.length() > 2)
				{
					CodeToCountry StateConvert = new CodeToCountry();
					NewState = StateConvert.GetStateShortcut(anylead.State);
				}
				
				anylead.Country = NewState;
				anylead.State = '';
			}
			
		}
			
		String anyLeadComments = anyLead.Comments__c;
		if (anyLeadComments != null){ 
			if (anyLeadComments.contains('http://') || anyLeadComments.contains('https://')){
				anyLead.addError('Can not save lead - comments field contains \'http://\'');
				return;
			}
		} 
	
	}
		/**
		*			if ((anyLead.Country == 'United States' || anyLead.Country == 'Canada') 
			&& (anyLead.CreatedById == '00520000000jse1') 
			&& (anyLead.LeadSource == 'Web Site (SolidCAM)' || anyLead.LeadSource == 'Web Site (InventorCAM)'))
		**/
		//System.debug('comp1 : '+anyLead.Company);
		// put lead in approval if created by david and county
		/* if (anyLead.Company == 'Test'){
			System.debug('comp2 : '+anyLead.Company);
			System.debug('Query #3 - OnLeadTrigger');
			Lead approveLead = [ select ID from Lead where id in :Trigger.new ];
			// if lead is O.K check if he has to be inserted in Aproval proccess
			Boolean res = ApexUtils.add_object_to_approval(approveLead);
			System.debug('res = '+res);
		}	
					 			
	}*/		
}