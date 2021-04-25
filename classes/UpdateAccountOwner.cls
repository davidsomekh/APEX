public with sharing class UpdateAccountOwner {
	
	public void UpdateOwner(Account ACC){
		
		if(ACC == null || System.isBatch() || ACC.Type == 'Reseller')
			return;
			
		String AN = ACC.Parent_Account_Auto_Number__c;
		if(String.isEmpty(AN))
			return;
			
		if(String.valueOf(ACC.ParentId)  == '001D000001Pv4N1') //SolidCAM ltd exception
			return;
			
			
	
			
		if(ACC.Parent_account_record_owner__c == null)
		{
			if(ACC.OwnerId == UserInfo.getUserId())
			{
				String subject = 'Account owner not updated' + ' (' + ACC.Parent_Account_Mirror__c	 + ' Owner: ' + ACC.Owner_full_name__c	 +  ')';
				String link = 'https://eu1.salesforce.com/' + ACC.Id;
				String URL = '<a href="' + link +  '\">' + link;
				Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
				mail.setHtmlBody(URL);
			    mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
			    mail.setSubject(subject);
			    Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});	
			}
		}
		else
			ACC.OwnerId = ACC.Parent_account_record_owner__c;
		

		
	
	
	
		
	}
    
}