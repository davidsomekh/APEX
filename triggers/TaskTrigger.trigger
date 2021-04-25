trigger TaskTrigger on Task (after delete, before insert, before update, 
							 after insert, after undelete, after update) 
	{
	
	Task thisTask;
	if (Trigger.isDelete)
		thisTask = Trigger.old[0];
	else{
		thisTask = Trigger.new[0];
			if (Trigger.isBefore){
			// update state
			thisTask.State__c = TaskUtils.update_state(thisTask.WhoId);
		}
	}

	TaskUtils.count_activities_in_lead(thisTask.WhoId);
	TaskUtils.count_activities_in_opportunity(thisTask.WhatId);
}