/***************************
*	EmilK
*	Functions handling contacts
***************************/
public class ContactUtils 
{
	
	public static void check_contacts_email(Contact Current)
	{
		if (Current.email != null)
		{
			// count contacts with the same email adress
			System.debug('Query #30 - ContactUtils');
			Integer countContacts = [Select count() 
									 From Contact 
									 Where Email = :Current.email];
			if (countContacts > 0)
				Current.addError('Can not save contact - There is already another contact with the same email in the system');
			
		}
	}
}