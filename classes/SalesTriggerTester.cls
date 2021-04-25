public class SalesTriggerTester {

	static testmethod void runTest(){
		
		List<Account> acc = [select Id from Account limit 2];
		
		if (acc.size() < 2){
			return;
		}
		Sales__c sale = new Sales__c();
		sale.Name = '6666';
		sale.Date_Of_Order__c = Date.today();
		sale.PriceInEuro__c = 100;
		sale.Reseller__c = acc.get(0).Id;
		sale.Customer__c = acc.get(1).Id;
		sale.Price_In__c = 'Euro';
		
		insert sale;
	}
}