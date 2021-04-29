/***********************************************************
*	EmilK
*	Trigger fired when Lead is inserted and updated
************************************************************/
trigger OnLeadTrigger on Lead (before insert) {
	
	// loop over all given Leads look for wrong mail
	for(Lead anyLead : Trigger.new){
		
		if(anylead.LeadSource == 'Facebook (Trial)' && anylead.Country != '')
		{
			if(anylead.Do_you_own_CNC_equipment__c == 'no_')
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
			if (anyLeadComments.contains('http://')){
				anyLead.addError('Can not save lead - comments field contains \'http://\'');
				return;
			}
		} 
		// else - check lead
		else{
			String anyeLeadEmail = anyLead.Email;
			if (anyeLeadEmail != null){
				if (anyeLeadEmail.contains('@') == false){
					anyLead.addError('Can not save lead - Email adress does not contains @');
				}
				System.debug('Query #2 - OnLeadTrigger');
				List<Lead> leads_in_sys = [Select Id , 	CreatedDate
											 From Lead 
											 where Email = :anyeLeadEmail];
				// look up of duplicate email
				for(Lead anyLeadInSys : leads_in_sys){
					// if created less than 180 days from today don't allow duplicates
					if (anyLeadInSys.CreatedDate >= Datetime.now().addDays(-30)){
						anyLead.addError('Can not save lead - There is already another lead with the same email in the system');
					}
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
		}	*/					 			
	}
}