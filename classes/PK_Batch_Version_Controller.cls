global class PK_Batch_Version_Controller implements Database.Batchable<sObject>, Schedulable, Database.Stateful,Database.AllowsCallouts {
	
	global set<String> listIds;
	
	global void execute(SchedulableContext sc){
		
		System.debug('DAVIDSOMEKH1');
		PK_Batch PK = new PK_Batch();
		PK.execBatch();
	

	}
	
	global PK_Batch_Version_Controller(){
		
		System.debug('DAVIDSOMEKH2');
		
	}
	 
	global PK_Batch_Version_Controller(set<String> ids){
		listIds = ids;
		
		System.debug('DAVIDSOMEKH3');
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		System.debug('DAVIDSOMEKH4');
      return Database.getQueryLocator(
      				[Select Name,Serial_No__c,Product_key__c,Id
					From Dongle__c d
					where Name in :listIds
					]);
   }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope){
   	System.debug('DAVIDSOMEKH5');
		for(sObject s : scope){
			GeneratePK g = new GeneratePK();
			Dongle__c d = (Dongle__c)s;
			System.debug(d.Id);
			g.GeneratePK(d.Id,false,false);
			System.debug('starting');
		}
   }
   
   global void finish(Database.BatchableContext BC){
   	
   	System.debug('DAVIDSOMEKH6');

   }
    
}