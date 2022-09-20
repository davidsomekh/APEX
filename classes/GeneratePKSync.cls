global with sharing class GeneratePKSync {
	
	public Dongle__c GetDongle(ID license)
	{
		dongle__c record;
		String day = '';
		String month = '';
		String year = '';
		String name = '';
		String AccountID = '';
		Date exp;
		
		List<Dongle__c> ARR = [Select 	Name,Serial_No__c,Product_key__c,Owner_ID__c,Customer_mirror__c,Product_key__r.Name 
		From Dongle__c	Where Id =: license Limit 1];
		
		if(ARR.size() > 0)
			return ARR[0];

		return null;
		
	}
	public String WebRequest(String data,String EndPoint,List<Integer> Code)
	{	
		HttpRequest req = new HttpRequest();
	    req.setEndpoint(EndPoint);
	    req.setTimeout(120000);
	    req.setHeader('Content-Type', 'application/json');
	    req.setBody(data);
	    req.setMethod('GET');

		if(!Test.isRunningTest())
		{
	    	Http http = new Http();
	    	HTTPResponse res = http.send(req);
	 		String PKNAME = res.getBody();
	 		Integer iCode = res.getStatusCode();
		 	Code.add(iCode);
	 		return PKNAME;
		}
	 	
	 	return '';
	}
	
	public string GetCZHTML(Dongle__c recrod,string newname)
	{
		string sHtml;
		sHtml = '<font family=calibri><b><i>Dear SolidCAM CZ team,</b></i>';

		sHtml = sHtml += '<p><font family=calibri>SolidCAM product key has been activated.';
		
		sHtml = sHtml += '<p><font family=calibri>Please see below activation details:';
		
		
		sHtml = sHtml += '<p><font family=calibri>Customer: <b>' + recrod.Customer_mirror__c;
		sHtml = sHtml += '</b><br><font family=calibri>Product key: <b>' + recrod.Product_key__r.Name;
		sHtml = sHtml += '</b><br><font family=calibri>Activation ID: <b>' + newname;
		
		
		sHtml = sHtml += '</b><p><i><font family=calibri>Thanks,';
		sHtml = sHtml += '<br><i><font family=calibri>SolidCAM Team';
		
		return sHtml;
	}
	
	
	public void DeleteOldRecords(String sDongleNumber)
	{
		
		sDongleNumber =    sDongleNumber.trim();
			        
		List<Dongle__c> OldRecords = [Select 	Name,Id,Dongle_Expiry_Date__c,Sentinel__c
		From Dongle__c	Where Name =: sDongleNumber Limit 1];
		
		if(OldRecords.size() > 0)
		{
		       
			Date expiration = OldRecords[0].Dongle_Expiry_Date__c;
			if((expiration < Date.TODAY() && OldRecords[0].Sentinel__c) || Test.isRunningTest())
			{ 
				Dongle__c record = OldRecords[0];
				record.Sentinel__c = false;
				record.Dongle_Type__c  = 'USB';
				record.Product_key__c  = null;
				
				update record;
				try
				{
					delete record;
				}
				catch(Exception e)
    			{
			     /*   String subject = 'Sync error - delete old record exception (' +record.Name + ')';
			        String link = 'https://eu1.salesforce.com/' + record.Id;
			        String body = 'Warning! Record data was changed to allow delete. Record:';
			        body = body + '<p><a href="' + link +  '\">' + link;
			        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			        mail.setHtmlBody(body);
			        mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
			        mail.setSubject(subject);
			        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});*/
    			}
			}
		}
	}
	public String Web(String name,Dongle__c record,Boolean  test)
	{
		Integer Code = 0;
		String PKNAME = '';
		JSONGenerator gen = JSON.createGenerator(true);
	    gen.writeStartObject();
	    gen.writeStringField('PK', Name);
	    gen.writeEndObject();            
	    String JSON_DATA = gen.getAsString();
	    
	    List<Integer> SetCode = new List<Integer>();
	    String EndPoint = 'http://solid-php.westeurope.cloudapp.azure.com/ldk/ldk.php';
	    
	    
	    if(!test)
	    	PKNAME = WebRequest(JSON_DATA,EndPoint,SetCode);
	    
	    if(SetCode.size() > 0)
	    	Code = SetCode[0];
		   	    
	      
	 	if(Code == 202 || Code == 203 || test)
	 	{
	 		PKNAME = PKNAME.trim();
			if(!test)
	 			return PKNAME;
	 	}	
	 	
	 	if((PKNAME != '' && Code == 201) || test)
	 	{
	        DeleteOldRecords(PKNAME);
	        
	        Boolean bSyncError = false;
	        
	        String old_name = record.Name;
	        String old_serial = record.Serial_No__c;
	        
	        record.Name = PKNAME;
	        record.Serial_No__c = PKNAME;
	        record.Sync_error__c = false;
	        record.Sync_name__c = '';
	        
	        PKNAME = PKNAME.trim();
		   				   
			try
			{
				update record;
			}
			
			catch (DMLException e)
			{
			 	bSyncError = true;
			 	record.Sync_error__c = true;
			 	record.Sync_name__c = PKNAME;
			    record.Name = old_name;
			    record.Serial_No__c = old_serial;
			    try
			    {
			    	update record;
			    }
			    
			    catch (Exception e2) 
    			{
			        
			        String subject = 'Sync error - exception (' +record.Name + ')';
			        String link = 'https://eu1.salesforce.com/' + record.Id;
			        String URL = '<a href="' + link +  '\">' + link;
			        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			        mail.setHtmlBody(URL);
			        mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
			        mail.setSubject(subject);
			        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
    			}
			}
			
			if((!bSyncError && record.Owner_ID__c == '00520000001VKa4') || test)
			{
				list<string> usersCC = new list<String>();
				usersCC.add('david.somekh@solidcam.com');
				
				list<string> usersTo = new list<String>();
				usersTo.add('hotline@solidvision.cz');
				usersTo.add('qi-solidvision@solidvision.cz');
				
				string sNewName = record.Name;
				sNewName = sNewName.trim();
				
				String subject = 'SolidCAM product key activated ('+record.Customer_mirror__c +')';
		        String link = 'https://eu1.salesforce.com/' + record.Id;
		        String URL = '<a href="' + link +  '\">' + link;
		        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
		        mail.setHtmlBody(GetCZHTML(record,sNewName));
		        mail.setToAddresses(usersTo);
		  //      mail.setccAddresses(usersCC);
		        mail.setSubject(subject);
		        Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
			}
		    return PKNAME;
	 	}
	 	
	 	return 'Cannot sync activation ID';
	}
	
	public String SYNC(ID license)
	{
		  
		Dongle__c rec = GetDongle(license);
		return Web(rec.Name,rec,FALSE);
	}
	
		
	
	webservice static String SyncID(ID license)
	{	GeneratePKSync p = new GeneratePKSync();return p.SYNC(license);	}

}