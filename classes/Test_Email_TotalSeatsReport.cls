@isTest(seealldata=true)
private class Test_Email_TotalSeatsReport {

    static testMethod void myUnitTest() {
        Email_TotalSeatsReport em = new Email_TotalSeatsReport();
        em.execute(null);
        
        ExpireDateNotifier EDN = new ExpireDateNotifier();
        EDN.execute(null);
        
        //set<ID> IDS;
        
       // PK_Batch_Daily PK = new PK_Batch_Daily(IDS);
       // PK.execute(null);
    }
}