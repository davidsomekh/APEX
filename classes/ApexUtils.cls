/**********************************
*	EmilK
*	General Apex Utils
************************************/
public class ApexUtils {
	

	/**
	*	EmilK
	*	get map email key
	**/
	public static String get_map_email_key(Automation_Mails__c email){
		
		// get all mails in email object
		List<String> listTo = ApexUtils.text_get_mails_to_send(email.To__c);
		List<String> listCC = ApexUtils.text_get_mails_to_send(email.CC__c);
		List<String> listBCC = ApexUtils.text_get_mails_to_send(email.BCC__c);
		
		List<List<String>> mails = new List<List<String>>();
		mails.add(listTo);
		if (listCC.size() != 0)
			mails.add(listCC);
		if (listBCC.size() != 0)
			mails.add(listBCC);
		
		// add email addresses if needed
		String returnCode = '';	
		Integer size = mails.size();
		for(Integer i = 0 ; i < size ; ++i){
			mails.get(i).sort();
			for(String mail : mails.get(i)){
				returnCode += mail;
			}
			returnCode += ':';
		}
		return returnCode;
	}
	
	/**
	*	EmilK
	*	check if give string is a vaild emad adress
	**/
	public static Boolean is_valid_email_address(String emailAdrress)
	{
		// Expression for emails
		// EVERY email has to start with a letter contain @
		// email server has to begin this a letter and than "."
		// and 2-4 lettters
		String expression = '^[\\w\\.-]+@([\\w\\-]+\\.)+[a-zA-Z]{2,4}$';
		//Make the comparison case-insensitive.   
		pattern mailPattern = pattern.compile(expression);   
		Matcher matcher = mailPattern.matcher(emailAdrress);
		   
		return matcher.matches(); 
	}
	
	/**
	*	EmilK
	*	text get also wrong emails
	*	split textarea emails and returns all of them
	*	without validity check
	**/
	public static List<String> text_get_also_wrong_emails(String mailList){
		if (mailList == null) return new List<String>();
		
		String[] mails = mailList.split('\n', 0);
		Integer numMails = mails.size();
		List<String> returnMails = new List<String>();
		
		for (Integer i = 0 ; i< numMails ; ++i){
			returnMails.add(mails[i].trim());
		}
		
		return returnMails;
	}
	
	/**
	*	EmilIK
	*	emails to send
	**/
	public static List<String> get_emails_to_send(String[] splitedEmails){
		
		List<String> emailsToSend = new List<String>();
		for (String anyEmail : splitedEmails){
			if (is_valid_email_address(anyEmail)){
				emailsToSend.add(anyEmail);
			}
		}
		return emailsToSend;
	}
	
	/**
	*	EmilK
	*	added to this class to avoid \n at the end
	**/
	static public List<String> text_get_mails_to_send(String mailList){
		if (mailList == null) return new List<String>();
		
		String[] mails = mailList.split('\n', 0);
		Integer numMails = mails.size();
		
		for (Integer i = 0 ; i< numMails ; ++i){
			mails[i] = mails[i].trim();
		}
		// return all valid emails
		return ApexUtils.get_emails_to_send(mails);
	}
	
	/**
	*	EmilK
	*	bubble Sort
	**/
	public static void bubbleSort(ApexComparator comp , List<SObject> original_list) {

	    // index of last comparison
	    Integer lastIndex = original_list.size(); 
	  	// has swaped = true only to enter the loop first time
	  	Boolean hasSwaped = true;
	    while (hasSwaped) {
	    	hasSwaped = false;
	    	lastIndex = lastIndex - 1;
	        for (Integer i=0 ; i < lastIndex ; ++i) {
	        	Integer res = comp.Compare(original_list[i], original_list[i+1]);
	            if (res > 0) 
	            {
	               // swap elements
	               SObject temp = original_list[i];  
	               original_list[i] = original_list[i+1];  
	               original_list[i+1] = temp;
	               hasSwaped = true;
	            }
	        }
	    }
	}
}