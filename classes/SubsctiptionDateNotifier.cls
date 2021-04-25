/************************************************************
*	EmilK
*
*
*
**************************************************************/
global class SubsctiptionDateNotifier implements Schedulable{
	
	/**
	 implementation of execute - required by SChedulable interface
	*/
	global void execute(SchedulableContext sc){
		
		ExpireDateOnDongles expire_dongles = new ExpireDateOnDongles(60, ExpireDateOnDongles.CheckMode.Subscription);
   		database.executebatch(expire_dongles, 5);
	}
	
	static testMethod void testOnMaintenenceUpdate(){
		ExpireDateOnDongles dongle_expireDate = new ExpireDateOnDongles(60, ExpireDateOnDongles.CheckMode.Subscription);
  		// finaly - test batch part of the class
   		Test.startTest();
						
   		ID batch_job_id = Database.executeBatch(dongle_expireDate, 5);
   		Test.stopTest();
	} 
}