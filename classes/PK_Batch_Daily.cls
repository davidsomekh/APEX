global class PK_Batch_Daily implements Database.Batchable<sObject>, Schedulable, Database.Stateful,Database.AllowsCallouts{
	
	global set<ID> listIds;
	
	global void execute(SchedulableContext sc){
		
		PK_Batch PK = new PK_Batch();
		PK.execBatch();
		
		/*try { 
		system.abortJob(sc.getTriggerId()); 
		} catch (exception e) {system.debug('#### schedule job exception while aborting:' + e);} 
		
		
		// reschedule the job 
		system.debug('#### schedule job executing'); 
	 	scheduleNow(); */ 

	}
	
	
	global PK_Batch_Daily(){
		
	}
	 
	global PK_Batch_Daily(set<ID> ids){
		listIds = ids;
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(
      				[Select Name,Serial_No__c,Product_key__c,Id,Sync_name__c,Sync_error__c
					From Dongle__c d
					where id in :listIds
					]);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   	System.debug('starting 1');
		for(sObject s : scope){
			GeneratePKSync g = new GeneratePKSync();
			Dongle__c d = (Dongle__c)s;
			System.debug(d.Id);
			g.SYNC(d.Id);
			System.debug('starting');
		}
   }

   global void finish(Database.BatchableContext BC){

   }
}