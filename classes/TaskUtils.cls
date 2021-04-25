/*************************
*	EmilK	
*	class has utils for task & event trigger
*
***************************/
public class TaskUtils {

	/**
	*	update state of activity be
	*	Lead or Account
	**/
	public static String update_state(ID toUpdateId){
		
		// Get account with given id
		List<Account> accounts = [Select Id , ShippingState 
							From Account 
							Where Id = :toUpdateId];
							
		// if activity is attached to lead or account
		// fill it account shiping state
		if (accounts.size() == 1){
			return accounts[0].ShippingState;
		}
		// get lead with given id
		List<Lead> leads = [Select Id, State 
							From Lead 
							Where Id = :toUpdateId];
		// if activity is attached to Lead return leads state
		if (leads.size() == 1){
			return leads[0].State;
		}
		return '';
	}
	
	/**
	*	count number of activities in Lead
	**/
	public static void count_activities_in_lead(ID leadId){
		
		// get lead
		List<Lead> leadToCahnge = [Select Id, OwnerId, 
								Number_of_Activities__c, Country
							   From Lead 
							   where Id = :LeadId and IsConverted = false];
						  							   
		// Added temporary the checking if country is not USA and not Canada						   
		// and Owner is not solidcam USA
		if (leadToCahnge.size() == 1 &&
		!(leadToCahnge[0].OwnerId == '005200000014HJ0AAM' || leadToCahnge[0].Country == 'United States' || leadToCahnge[0].Country == 'Canada')){
			
		// get contact lead Id fro, tasks
		Integer numOfTesks = [Select count() 
						  From Task 
						  Where WhoId =: LeadId];
						  
		// count event with same 
		Integer numOfEvents = [Select count() 
						  From Event 
						  Where WhoId =: LeadId];
			
			leadToCahnge.get(0).Number_of_Activities__c = numOfTesks + numOfEvents;
			update leadToCahnge.get(0);
		}
	}
	
		/**
	*	count number of activities in Opportunity
	**/
	public static void count_activities_in_opportunity(ID oportunityId){
		
		// get Opportunity
		List<Opportunity> opportonityToChange = [Select Id, 
								Number_of_Activities__c
							   From Opportunity 
							   where Id = :oportunityId];							   
		if (opportonityToChange.size() == 1 ){
			// get contact lead Id fro, tasks
			Integer numOfTesks = [Select count() 
							  From Task 
							  Where WhatId =: oportunityId];
							  
			// count event with same 
			Integer numOfEvents = [Select count() 
							  From Event 
							  Where WhatId =: oportunityId];
			
			opportonityToChange.get(0).Number_of_Activities__c = numOfTesks + numOfEvents;
			update opportonityToChange.get(0);
		}
	}
}