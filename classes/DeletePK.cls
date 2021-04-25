global with sharing class DeletePK
{
	
	public DeletePK()
	{
	
	}
	
	webservice static boolean DeleteKey(String PK,boolean Test)
	{
		String EndPoint;
		Integer Code = 0;
		Integer Code2 = 0;
	    HTTPResponse response = null;
	    
	    EndPoint = 'http://solid-php.westeurope.cloudapp.azure.com/ldk/ldk.php';
	    
	    JSONGenerator JSON_DATA = JSON.createGenerator(true);
        JSON_DATA.writeStartObject();
        JSON_DATA.writeStringField('DeletePK', PK);
	    
	    
    	HttpRequest req = new HttpRequest();
    	req.setEndpoint(EndPoint);
    	req.setTimeout(120000);
    	req.setHeader('Content-Type', 'application/json;charset=UTF-8');
    	req.setBody(JSON_DATA.getAsString());
    	req.setMethod('GET');
    			    			    	    
     
    	Http http = new Http();
    	String s1= '';
    	if(!Test)
    	{
    		HTTPResponse res = http.send(req);
 			Code = res.getStatusCode();
 			s1=String.valueof(Code);
    	}
    	else
    		s1 = '300';
 		
 		
 		if(s1 == '300')
 		{
 			JSONGenerator JSON_ALIVE = JSON.createGenerator(true);
        	JSON_ALIVE.writeStartObject();
        	JSON_ALIVE.writeStringField('PKALIVE', PK);
        
 			HttpRequest CheckDelete = new HttpRequest();
	    	CheckDelete.setEndpoint(EndPoint);
	    	CheckDelete.setTimeout(120000);
	    	CheckDelete.setHeader('Content-Type', 'application/json;charset=UTF-8');
	    	CheckDelete.setBody(JSON_ALIVE.getAsString());
	    	CheckDelete.setMethod('GET');
	    	
	    	Http http2 = new Http();
	    	String s2='';
	    	if(!Test)
	    	{
	    		HTTPResponse res2 = http2.send(CheckDelete);
	 			Code2 = res2.getStatusCode();
	 			s2=String.valueof(Code2);
	    	}
	    	else
	    		s2 = '300';
	 		
	 		if(s2 == '300')
	 		{
	 			String subject = 'Error deleting product key' + ' (' + PK   + ')';
      			Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
      			mail.setHtmlBody(PK);
		        mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
		        mail.setSubject(subject);
		        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
		        return false;
	 		}
 		}
 		
 		return s1 == '300';
 	
	}
	
	webservice static void DeletePKRecord(String PK)
	{
		
		List<Product_keys__c>  DNG =  [Select Name From Product_keys__c
                         Where Name =: PK
		];
		
		if(!DNG.isEmpty())
			delete DNG[0];
		
		
	}
}