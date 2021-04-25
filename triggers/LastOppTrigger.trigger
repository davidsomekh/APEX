trigger LastOppTrigger on Opportunity (after delete, after insert, after undelete, 
after update) {

	List<ID> customersIDs = new List<ID>();
	
	List<Opportunity> argSales;
	//	Update last date when customer buyed solidcam
	if (Trigger.isDelete){
		argSales = Trigger.old;
	}
	else{
		argSales = Trigger.new;
	}
	// Clean sales list:
	// if has no price or no customer - ignore
	for (Opportunity sale : argSales){
		if (sale.Final_Price__c != null && sale.Final_Price__c > 0 && sale.AccountId != null){
			customersIDs.add(sale.AccountId);
		}
	}
	// Get ALL sales of cudstomers ordered ny date of order
	List<Opportunity> allSalesOfCustomer = [select CloseDate, AccountId,Final_Price__c 
										 from Opportunity
										 where AccountId in : customersIDs AND Final_Price__c!= null AND Final_Price__c > 0
										 order by CloseDate Desc];

	List<Opportunity> salesOnce = new List<Opportunity>();
	// Clean from duplicates the sales list
	for (Opportunity sale : allSalesOfCustomer){
		Boolean bAdd = true;
		for(Integer i = 0; i < salesOnce.size() ; i++){
			if (sale.AccountId == salesOnce.get(i).AccountId){
				bAdd = false;
			}
		}
		if (bAdd){
			salesOnce.add(sale);
		}
	}
	
	// Now having all sales at most once find the customers
	List<Account> customers = [Select Id, Last_Sale__c from Account where Id in :customersIDs]; 
	for (Account acc : customers){
		acc.Last_Sale__c = null; 
		for (Opportunity sale : salesOnce){
			if(acc.Id == sale.AccountId){
				acc.Last_Sale__c = sale.CloseDate;
			}
		}
	}
	update customers;
}