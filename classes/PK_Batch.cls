public with sharing class PK_Batch {
	
	public String Status;
	public ID batchprocessid {get;set;}
	public AsyncApexJob aaj {get;set;}
	public Set<id> m_ids;
	
	public PK_Batch (){
	}
	
	public PK_Batch (Apexpages.Standardcontroller ctrl){
	}
	
	public Set<id>  GetIDS()
	{
		return m_ids;
	}
	
	public void execBatch(){
		
		Dongle__c record;
		Set<id> ids = new Set<id>(); 
		
		List<Dongle__c> ARR = [Select 	Name,Sync_error__c,Serial_No__c,Product_key__c,id,Sync_name__c
		From Dongle__c	Where Sentinel__c = true AND Seat_activated__c = false];
		
		Integer c = 0;
		string s1=string.valueof(ARR.size());
		
		if(ARR.size() > 0)
		{
		
			System.debug(s1);
			while(c < ARR.size())
			{
				record = ARR[c];
				ids.add(record.id);
				c++;
			}
			
			m_ids = ids;
			batchprocessid = Database.executeBatch(new PK_Batch_Daily(ids),1); 
		}
		
		
		System.debug('starting 2');
		
	}
	
	public void checkBatchStatus(){
		if(batchprocessid != null )
		aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                    FROM AsyncApexJob WHERE ID =: batchprocessid ];
	}
	
	public void setStatus(String david)
    {
        this.Status = david;
    } 
    
    public String getStatus()
    {
        return Status;
    } 
	
	
}