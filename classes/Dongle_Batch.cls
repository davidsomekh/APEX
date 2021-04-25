public with sharing class Dongle_Batch {

	public string idList {get;set;}
	public boolean bInternalUse {get;set;}
	public boolean bVersion {get;set;}
	public boolean bSentinel {get;set;}
	public ID batchprocessid {get;set;}
	public AsyncApexJob aaj {get;set;}
	
	public Dongle_Batch (){
	}
	
	public Dongle_Batch (Apexpages.Standardcontroller ctrl){
	}
	
	public void execBatch(){
		Set<String> ids = new Set<String>(); 
		List<String> IDList1 = idList.split('\\n');
		for(String id : IDList1){
			id=id.deleteWhitespace();
			ids.add(id);
		}
		if(ids.size() > 0) 
			batchprocessid = Database.executeBatch(new BA_Dongle_Generate(ids,bInternalUse,bVersion,bSentinel),1); 
	} 
	
	public void checkBatchStatus(){
		if(batchprocessid != null )
		aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                    FROM AsyncApexJob WHERE ID =: batchprocessid ];
	}
}