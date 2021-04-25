/**************************************************
*	EmilK
*	Event trigger
***************************************************/
trigger EventTrigger on Event (after delete,before insert, before update, 
							   after insert, after undelete, after update) {

	Event triggerEvent;
	if (Trigger.isDelete){
		triggerEvent = Trigger.old[0];
		
	}
	else{
		triggerEvent = Trigger.new[0];
		if (Trigger.isBefore){
			triggerEvent.State__c = TaskUtils.update_state(triggerEvent.WhoId);		
		}
	}
	TaskUtils.count_activities_in_lead(triggerEvent.WhoId);
	TaskUtils.count_activities_in_opportunity(triggerEvent.WhatId);
}