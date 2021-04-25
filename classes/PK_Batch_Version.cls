public with sharing class PK_Batch_Version {
	
	public string idList {get;set;}
	public ID batchprocessid {get;set;}
	public AsyncApexJob aaj {get;set;}
	
	public PK_Batch_Version (){
	}
	
	public PK_Batch_Version (Apexpages.Standardcontroller ctrl){
	}
	
	public void execBatch(){
		System.debug('execBatch');
		Set<String> ids = new Set<String>(); 
		List<String> IDList1 = idList.split('\\n');
		for(String id : IDList1){
			id=id.deleteWhitespace();
			ids.add(id);
		}
		if(ids.size() > 0) 
			batchprocessid = Database.executeBatch(new PK_Batch_Version_Controller(ids),1); 
	} 
	
	public void checkBatchStatus(){
		if(batchprocessid != null )
		aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                    FROM AsyncApexJob WHERE ID =: batchprocessid ];
	}
    
}