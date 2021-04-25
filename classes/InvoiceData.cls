public with sharing class InvoiceData {
	
	public Opportunity Opp {get;set;}
	
	List<OpportunityLineItem> allLineItems{get;set;}
	Id m_OppID = null;
	public String userinput{get; set;}
	public List<String> m_names    {get;set;}
	public List<Decimal> m_quan    {get;set;}
	public List<Decimal> m_price    {get;set;}
	public List<Decimal> m_ids    {get;set;}
	public String JSON_NAMES {get;set;}
	private boolean m_bAlert = false;
	private id m_record_id = null;
	private String m_sMissingNames = null;
        
     public InvoiceData (Apexpages.Standardcontroller ctrl){
     	Opp = (Opportunity)ctrl.getRecord();

        this.m_bAlert = false;           	 
     	Id TheID = this.m_OppID;
     	this.m_record_id = Opp.id;
 		this.allLineItems=new List<OpportunityLineItem>([select id,UnitPrice,Product2.Family,Product2.Name,Quantity,Product2.Hasavshevet_product_ID__c
                                                                              from OpportunityLineItem where OpportunityId = :Opp.id ORDER BY TotalPrice DESC]);
                                                                             

        
        m_names = new List<String>();
        m_ids = new List<Decimal>();
        m_price = new List<Decimal>();
        m_quan = new List<Decimal>();
        
        for (OpportunityLineItem item : this.allLineItems) {
        	if(Item.Product2.Family != 'USA')
        	{
    			m_names.add(item.Product2.Name);
    			m_quan.add(item.Quantity);
    			m_price.add(item.UnitPrice);
    			if(item.Product2.Hasavshevet_product_ID__c != null)
    				m_ids.add(item.Product2.Hasavshevet_product_ID__c);
    			else
    			{
    				m_ids.add(321);
    				if(m_sMissingNames != null)
    					m_sMissingNames = m_sMissingNames + item.Product2.Name + ';';
    				else
    					m_sMissingNames = item.Product2.Name + ';';
    					
    				this.m_bAlert = true;
					/*list<string> usersTo = new list<String>();
					usersTo.add('david@solidcam.com');
		
					
					
					String subject = 'WIZSOFT - produt segment is missing';
			        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			        mail.setHtmlBody('Test');
			        mail.setToAddresses(usersTo);
			        mail.setSubject(subject);
			        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});*/
    			}
    			
        	}
		}
		
		JSON_NAMES = JSON.serialize(m_names);
		

    }
    
    public Pagereference GetData(){
    	if(this.m_bAlert)
    	{	
	    			list<string> usersTo = new list<String>();
					usersTo.add('david@solidcam.com');
					String subject = 'WIZSOFT - produt segment is missing';
			        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			        mail.setHtmlBody('<a href="https://um2.salesforce.com/' + this.m_record_id + '">Link</a><p>'+this.m_sMissingNames);
			        mail.setToAddresses(usersTo);
			        mail.setSubject(subject);
			        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
    	}
			        
		return null;
 
    }
}