public with sharing class UpdateDongleOwner {
	
	public void UpdateList()
	{
		
	}
	
	public Dongle__c UpdateOwner(Dongle__c dongle){
		
		if(dongle == null)
			return null;
			
		dongle.CCountry__c = dongle.Customer_s_Country__c;
		dongle.ResellerText__c	 = dongle.Reseller_Auto_Number__c;
		dongle.Rname__c = dongle.Reseller_Auto_Number__c;
			
		if(dongle.Supply_Status__c == 'UnActive') //Assign not active to Linda
			dongle.OwnerId = '00520000000m8Gv';
		else
		{
			String owner = dongle.DongleOwner__c;
			if(owner != null)
			{
				dongle.OwnerId = owner;
				return dongle;
			}
			else
			{
				String ID = dongle.ID;
				if(ID != null)
				{
					String reseller = '';
					if(!String.isBlank(dongle.Sub_Reseller_Mirror__c))
						reseller = dongle.Sub_Reseller_Mirror__c;
					else
						reseller = dongle.Reseller_Mirror__c;
						
					if(dongle.OwnerId == UserInfo.getUserId())
					{
						String subject = 'Dongle owner not updated' + ' (Reseller:' + reseller + ' Owner: ' + dongle.Owner_mirror__c	   + ')';
						String link = 'https://eu1.salesforce.com/' + ID;
						String URL = '<a href="' + link +  '\">' + link;
						Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
						mail.setHtmlBody(link);
					    mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
					    mail.setSubject(subject);
					    Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
					}
				}
			}
		}
		
		return null;
		
		
		
	}

}