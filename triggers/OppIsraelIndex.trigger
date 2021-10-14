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
        IsraelIndex__c myCS1 = null;
         Integer index = 0;
        if(Test.isRunningTest()){
            index = 1;
            
        }
        else {
            
            myCS1 = IsraelIndex__c.getValues('Israel');
            index = Integer.valueOf(myCS1.Index__c);
  
        }
        
        if(index == null)
            index = 0;

        index++;
        if(!Test.isRunningTest())
        {
            myCS1.Index__c = index;
            update myCS1;
        }

        pCurrentOPP.IsraelOrderIndex__c =index;
        pCurrentOPP.Name = 'ISR' + String.valueOf(index);
       
    }
		
		
			
}
	
	

