trigger MailTrigger on Automation_Mails__c (before insert, before update) {
	
	Automation_Mails__c thisMail = Trigger.new[0];
	// check that there is no another mail with same account and subject
	System.debug('Query #7 - MailTrigger');
	List<Automation_Mails__c> duplicateMailList = [Select Id 
							   From Automation_Mails__c 
							   Where Account__c = :thisMail.Account__c
							   		and Mail_Subject__c = :thisMail.Mail_Subject__c limit 1];
	
	// Dont allow email with same account and subject
	if (duplicateMailList.size() == 1 && duplicateMailList[0].Id != thisMail.Id){
		thisMail.addError('ERROR: Can not save object - '+
		'there is allready defined another object \nwith the same Account and sunject');
		return;
	}
	
	// check if email address is in contacts
	List<String> allMails = new list<String>();
	
	allMails.addAll(ApexUtils.text_get_also_wrong_emails(thisMail.To_Managers__c));
	allMails.addAll(ApexUtils.text_get_also_wrong_emails(thisMail.To__c));
	allMails.addAll(ApexUtils.text_get_also_wrong_emails(thisMail.CC__c));
	allMails.addAll(ApexUtils.text_get_also_wrong_emails(thisMail.BCC__c));
	
	Integer contactWithMail = 0;
	// Check if the mails in this mail
	// are in contacts
	
	for(String mail : allMails){
		
		if (ApexUtils.is_valid_email_address(mail) == false){
			thisMail.addError('ERROR: Can not save object - wrong email : \''+mail+'\'.');
			return;
		}
		// check if mails is in contact
		System.debug('Query #8 - MailTrigger');
		contactWithMail = [Select count() 
						   From Contact 
						   Where Email = :mail];
		if (contactWithMail < 1){
			thisMail.addError('ERROR: Can not save object - no Contact with email \''+mail+'\' in system.');
			return;
		}
	}
	
	thisMail.Automation_Mail_Code__c = ApexUtils.get_map_email_key(thisMail);
	// Case hase to manager
	if (thisMail.To_Managers__c != null){
		List<String> managersMails = ApexUtils.text_get_mails_to_send(thisMail.To_Managers__c);
		String managerCode = '';
		for(String managerMail : managersMails){
			managerCode += managerMail + ':';
		}
		// update manager code
		thisMail.Automation_Mail_Code_Managers__c = managerCode;	
	}
}