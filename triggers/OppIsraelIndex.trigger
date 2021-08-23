trigger OppIsraelIndex on Opportunity (before insert) 
{
    List<Messaging.SingleEmailMessage> mails =
  new List<Messaging.SingleEmailMessage>();

	Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
   
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      sendTo.add('david@solidcam.com');
      mail.setToAddresses(sendTo);
   
      // Step 3: Set who the email is sent from
      mail.setReplyTo('david@solidcam.com');
      mail.setSenderDisplayName('David Somekh');
   
    
      // Step 4. Set email contents - you can use variables!
      mail.setSubject('URGENT BUSINESS PROPOSAL');
      String body = 'New opp';
     
      mail.setHtmlBody(body);
   
      // Step 5. Add your email to the master list
      mails.add(mail);
        
	Opportunity pCurrentOPP = Trigger.new[0]; //Pointer to the opp

    List<ID> customersIDs = new List<ID>(); 

	if(pCurrentOPP != null && pCurrentOPP.Reseller_country__c == 'Israel')
	{
    //pCurrentOPP.Name = 'Isr9';
    }
		
		
			
}
	
	

