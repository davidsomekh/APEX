/********************************************
*	EmilK
*	compare two customers of dongles - compares their names
*	COST : one query , maximum 2 query rows
**********************************************/
public class CustomerComparator extends ApexComparator{
		
	//	public enum CompareMode{ExpireDate, SubscriptionDate}
		
		private ExpireDateOnDongles.CheckMode m_mode;
		
		private map<Id, DongleAccountData> m_data_list;
		
		/**
		* EmilK
		^ Ctor	
		**/
		public CustomerComparator(map<Id, DongleAccountData> data_list){
			m_data_list = data_list;
		}
		
		/**
		* EmilK
		^ Ctor	
		**/
		public CustomerComparator(map<Id, DongleAccountData> data_list, ExpireDateOnDongles.CheckMode mode){
			m_data_list = data_list;
			m_mode = mode;
		}
		
		
		public override Integer Compare(SObject first_obj, SObject second_obj){
		
		if (!(first_obj instanceof Dongle__c) || 
			!(second_obj instanceof Dongle__c) ){
			return 0;
		}
		
		DongleAccountData firstData = m_data_list.get(first_obj.Id);
		DongleAccountData secondData = m_data_list.get(second_obj.Id);
		
		// System.debug(firstData.to_string());
		// System.debug(secondData.to_string());
		if (firstData == null || secondData == null){
			return 0;
		}
		// don't compare between different resellers
		if (firstData.resellerName > secondData.resellerName)
			return 1;
		else if (firstData.resellerName < secondData.resellerName)
			return -1;
		// compare between 2 different subresellers
		if (firstData.subresellerName > secondData.subresellerName)
			return 1;
		else if (firstData.subresellerName < secondData.subresellerName)
			return -1;
		
		// if reseller - subreseller are equal sort according customer
		if (firstData.customerName > secondData.customerName)
			return 1;
		else if (firstData.customerName < secondData.customerName)
			return -1;
			
		// if mode is initilized sort first by date
		if (m_mode != null){
			Dongle__c firstDongle = (Dongle__c)first_obj;
			Dongle__c secondDongle = (Dongle__c)second_obj;
			
			if (m_mode == ExpireDateOnDongles.CheckMode.ExpireDay){
				if (firstDongle.Dongle_Expiry_Date__c > secondDongle.Dongle_Expiry_Date__c ){
					return 1;
				}
				else if (firstDongle.Dongle_Expiry_Date__c < secondDongle.Dongle_Expiry_Date__c){
					return -1;
				}
			}
			// else subscription mode
			else{
				if (firstDongle.New_Maintenance_End_Date__c > secondDongle.New_Maintenance_End_Date__c ){
					return 1;
				}
				else if (firstDongle.New_Maintenance_End_Date__c < secondDongle.New_Maintenance_End_Date__c){
					return -1;
				}
			}
		}
		return 0;
	}
}