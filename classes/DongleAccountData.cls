/*********************************
*	EmilK
*	store dongle Account data
***********************************/
public class DongleAccountData {
	
	public Dongle__c dongleId;
	public String resellerName;
	public String subresellerName;
	public String customerName; 
	
	public String to_string(){
		return ' '+dongleId.Name+' '+resellerName+' '+subresellerName+' '+customerName;
	}
}