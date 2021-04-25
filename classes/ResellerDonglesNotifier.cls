global class ResellerDonglesNotifier implements Schedulable{
	
	/* EmilK
	 * execute - required to schedule class
	 *
	 */
	 
	 static testMethod void myTest() {

       ResellerDonglesNotifier r = new ResellerDonglesNotifier();
       SchedulableContext s;
       r.execute(s);
       
     }
	global void execute(SchedulableContext sc) {
		
   		DongleUpdateNotifier notifier = new DongleUpdateNotifier(DongleUpdateNotifier.Mode.Reseller);
   		database.executebatch(notifier, 100);
   	}

}