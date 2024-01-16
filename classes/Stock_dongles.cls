public with sharing class Stock_dongles {
	
	public boolean m_finished {get;set;}
	public boolean m_stock_OK {get;set;}
	public Opportunity m_Order {get;set;}
	public List<String> m_serials {get;set;}
	public List<String> m_names  {get;set;}
	public String m_sHTML  {get;set;}
	public String m_sReseller  {get;set;}
	public String m_sType  {get;set;}
		
	public Stock_dongles (Apexpages.Standardcontroller ctrl){
		m_Order = (Opportunity)ctrl.getRecord();
		m_names = new List<String>();
		m_serials = new List<String>();
	}
	
	public Stock_dongles (){
		
		m_names = new List<String>();
		m_serials = new List<String>();
		
	}
	
	public boolean IsNetwork(Opportunity Opp)
	{
		if(Opp.Dongles_type__c == 'Standalone')
			return false;
		
		return true;
			
	}
	
	public Integer GetPotentialUsers(Opportunity Opp)
	{
		String quan = Opp.Dongles_type__c.substring(7);
		quan = quan.trim();
		return Integer.valueof(quan);
	}
	
	public String GetDongleType(Opportunity Opp)
	{
		if(Opp.Dongles_type__c == 'Standalone')
			return 'MINI-USB';
		
		return 'MINI-NETUSB';
			
	}
	
	public void InitPage()
	{
		Import(null,false,null);
	}
	
	public boolean CheckErrors(String name,String serial,boolean Test)
	{
		
		if(!CheckDuplicates(name,serial))
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Numbers contain duplicates'));
			return false;
		}
				
		m_serials.Add(serial);
		m_names.Add(name);
		
		String sError = '';
		if(!name.isNumeric() || name.length() != 5 || Test)
			sError = 'One of the dongle numbers has an invalid format.';
		if(serial.contains('+') || serial.length() < 5 || serial.length() > 9 || Test)
		  	sError = 'One of the serial numbers has an invalid format. (' + serial + ')';
 
				
		if(!String.isBlank(sError) || Test)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,sError));
			if(!Test)
				return false;
		}
		
		return true;
	}
	
	public boolean CheckDuplicates(String name,String serial)
	{
		if(m_serials == null || m_names == null)
			return true;
			
		for(String ser : m_serials)
    	{
    		if(ser == serial)
    			return false;
    	}
    	
    	for(String na : m_names)
    	{
    		if(na == name)
    			return false;
    	}
    	
    	return true;
	}
	
	public void SendHTML()
	{
		list<string> users = new list<String>();
		
		users.add('linda.somekh@solidcam.com');
		users.add('david.somekh@solidcam.com');
		users.add('roy.peter@solidcam.com');
		
		String subject = 'New stock import (' + m_sReseller +') '+m_sType;
		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
		mail.setHtmlBody(m_sHTML);
	    mail.setToAddresses(users);
	    mail.setSubject(subject);
	    Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
	    
	}
	
	public void InitHTML()
	{
		m_sHTML = '<font family=calibri><table bgcolor=white border=1>' + '\n';
		m_sHTML = m_sHTML + '<tr>';
		m_sHTML = m_sHTML + '<b><td bgcolor="##ADD8E6">Number</td><td bgcolor="##ADD8E6">Serial No.</td>';
		m_sHTML = m_sHTML + '<td bgcolor="##ADD8E6">Reseller</td><td bgcolor="##ADD8E6">Sub Reseller</td><td bgcolor="##ADD8E6">Owner</td>';
		m_sHTML = m_sHTML + '<td bgcolor="##ADD8E6">Dongle Type</td><td bgcolor="##ADD8E6">Net Dongle</td><td bgcolor="##ADD8E6">Potential Users (Network)</td></b>';
	//	m_sHTML = m_sHTML + '<tr>';
		////html = html + '<tr>'
		//m_sHTML = m_sHTML + '<td>123</td><td>123456</td><td>31/12/2016</td><td>DE1</td><td>Stock order</td>';
		//m_sHTML = m_sHTML + '<td>David Somekh</td><td>SolidCAM Israel</td><td>SolidCAM ltd.</td><td>Naomi David</td><td>USB</td>';
	//	m_sHTML = m_sHTML + '<td>1</td><td>20</td>';
		
		
	    //return html;
		
	}
	
	public String GetDongleLine(Dongle__c record,Opportunity opp)
	{
		String sNet = record.Net_Dongle__c ? 'Yes' : 'No';
		String sUsers = String.valueof(record.Potential_Users__c);
		if(sUsers == null)
			sUsers='';
			
		String sSubReseller = record.Sub_Reseller_Mirror__c == null ? '' : record.Sub_Reseller_Mirror__c;
			
					
		String sLine = '';
		sLine = '<tr><td>' + record.Name + '</td><td>' + record.Serial_No__c + '</td>';
		sLine = sLine + '<td>'+ record.Reseller_Mirror__c  +'</td><td>'+  sSubReseller  +'</td><td>' + record.Owner_mirror__c;
		sLine = sLine + '<td>'+ record.Dongle_Type__c  +'</td><td>'+  sNet  +'</td><td>' + sUsers;  
		sLine = sLine + '</tr>';
		
		return sLine;
		
	}
	
    
    public void Import(Opportunity TestOpp,boolean TestMode,Dongle__c TestDongle)
    {
    		InitHtml();
    		Opportunity Opp = null;
    		if(TestMode)
    			m_Order = TestOpp;
    			
    		List<Dongle__c> listToUpdate = new List<Dongle__c>();
    		if(TestOpp == null)
    			Opp = [Select Stock_numbres__c,Name,Dongles_type__c,Reseller_dongle_owner__c,Reseller_parent_ID__c,Reseller__c,Description From Opportunity Where Id =: m_Order.Id][0];
    		else
    			Opp = TestOpp;
    			
    		m_sType = Opp.Dongles_type__c;
    			
    		String sError = '';
    			
    	 	if(String.isBlank(Opp.Stock_numbres__c) || TestMode)
			 	sError = 'Please insert stock numbers.';
			if(String.isBlank(Opp.Dongles_type__c)  || TestMode)
				sError = 'Please insert dongles type.';
			
			if(!String.isBlank(sError) || TestMode)		
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,sError));
				m_finished = true;
				if(!TestMode)
					return;
			} 	
			
			
    		//String sHTML = InitHTML();
    		//InitHTML();
    		List<String> lines = Opp.Stock_numbres__c.split('\n');
    		//String line= '';
    		for(String line : lines)
    		{
    			String sNumber = '';
    			String sSerial = '';
    			
    			if(line.length() > 5)
    			{
    				sSerial = line.substring(5);
    				sSerial = sSerial.DeleteWhitespace();
    				sNumber = line.substring(0,5);
    			}
    			
    			if(!CheckErrors(sNumber,sSerial,TestMode))
    			{
    				m_finished = true;
    				return;
    			}
    			
    			Id ResellerID = null;
    			Id SubResellerID = null;
    			
    			if(String.isBlank(Opp.Reseller_dongle_owner__c))
    			{
    				ResellerID = Opp.Reseller_parent_ID__c;
    				SubResellerID = Opp.Reseller__c;
    			}
    			else
    				ResellerID = Opp.Reseller__c;
    				
    				
    			
    			Dongle__c dongle_record = new Dongle__c(Name=sNumber,Serial_No__c=sSerial,Net_Dongle__c=IsNetwork(Opp),Reseller__c = ResellerID,Customer__c='00120000003m7vs',Version__c='190',Supply_Status__c='Stock',Order__c=Opp.Id,Date_Of_Order__c=date.today(),Dongle_Type__c = GetDongleType(Opp));
    			
    			if(dongle_record.Net_Dongle__c)
    				dongle_record.Potential_Users__c = GetPotentialUsers(Opp);
    				
    			if(SubResellerID != null)
    				dongle_record.SubReseller__c = SubResellerID;
    			
    			listToUpdate.Add(dongle_record);
   
    			 
    		}
    		
    		List<Dongle__c> OwnerUpdates = new List<Dongle__c>();
    		
    		if(!TestMode)
    		{
    			Database.SaveResult[] srList = Database.insert(listToUpdate);
    			for (Database.SaveResult sr : srList)
		 		{
		 			if(!sr.isSuccess())
		 			{
		 				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error saving records.Please contact admin'));
		 				return;
		 			}
		 		}
    		}
    			
    			
    		List<Dongle__c> ARR =  [Select Name,Reseller_Mirror__c,Sub_Reseller_Mirror__c,Owner_mirror__c,Potential_Users__c,Net_Dongle__c,Dongle_Type__c,Reseller__c,Serial_No__c,Current_version__c,Order__c,SubReseller__c,Supply_Status__c,DongleOwner__c,OwnerId From Dongle__c
                         Where Order__c =: Opp.Id];
                         
            
                         
             
            for(Dongle__c rec : ARR)
    		{
    			m_sReseller = rec.Sub_Reseller_Mirror__c != null ?  rec.Sub_Reseller_Mirror__c :  rec.Reseller_Mirror__c;
    			UpdateDongleOwner OwnerClass = new UpdateDongleOwner();
    			rec.Version__c = String.valueof(rec.Current_version__c);
    			Dongle__c rec_back = rec;
    			rec = OwnerClass.UpdateOwner(rec);
    			if(rec == null)
    			{
    				rec = rec_back;
    				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Records imported without owner.'));
    			}
    			else
    			 	OwnerUpdates.Add(rec);
    				
    			
    		}           
            
          
		 	Database.SaveResult[] srList = Database.update(OwnerUpdates);
		 	for (Database.SaveResult sr : srList)
		 	{
		 		if(!sr.isSuccess())
		 			return;
		 	}
		 	
		 	List<Dongle__c> ARR2 =  [Select Name,Reseller_Mirror__c,Sub_Reseller_Mirror__c,Owner_mirror__c,Potential_Users__c,Net_Dongle__c,Dongle_Type__c,Reseller__c,Serial_No__c,Current_version__c,Order__c,SubReseller__c,Supply_Status__c,DongleOwner__c,OwnerId From Dongle__c
                         Where Order__c =: Opp.Id];
		 	
		 	for(Dongle__c rec : ARR2)
    			m_sHtml = m_sHtml + GetDongleLine(rec,Opp);
            
            SendHTML();
            m_stock_OK = true;
            m_finished = true;

    		
    			
    		//String d = lines.get(0);
    		//d = d.deleteWhitespace();
    		//String serial = d.substring(5);
    	
    
    }
}