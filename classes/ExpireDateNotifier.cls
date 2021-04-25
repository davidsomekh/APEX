/*******************************************************
*	EmilK
*	ExpireDateNotifier - notifie resellers about dongles that 
*	will expire in 14 days
******************************************************/
global class ExpireDateNotifier implements Schedulable{
	
	global void execute(SchedulableContext sc){
		
		ExpireDateOnDongles expire_dongles = new ExpireDateOnDongles(14, ExpireDateOnDongles.CheckMode.ExpireDay);
   		
   		database.executebatch(expire_dongles, 5);
	}
}