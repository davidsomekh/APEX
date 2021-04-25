public without sharing class CTRL_ExecuteSummaryReport {
	//Variable
	public Id reportId{get;set;}
	public Id instanceId { get; set; }
    public Boolean reportIsRunning { get; set; }
    private transient Reports.ReportResults reportResults;
	
	//Constructor
	public CTRL_ExecuteSummaryReport(){
		reportIsRunning=true;
		if(ApexPages.currentPage().getParameters().containsKey('report_name')){
			try{
				string dName = ApexPages.currentPage().getParameters().get('report_name');
				system.debug('***report_name: '+dName);
				Report r = [Select Id From Report Where DeveloperName= :dName];
				reportId = r.id;
			}
			catch(Exception e){}
		}
		
	}
	
	//Methods
	public PageReference runReport() {
		system.debug('reportId: '+reportID);
        Reports.ReportInstance reportInstance = Reports.ReportManager.runAsyncReport(reportId, true);
        instanceId = reportInstance.getId();
        processInstance(reportInstance);
 
        return null;
    }
 
    public PageReference checkForReportResults() {
        Reports.ReportInstance reportInstance = Reports.ReportManager.getReportInstance(instanceId);
        processInstance(reportInstance);
 
        return null;
    }
 
    private void processInstance(Reports.ReportInstance reportInstance) {
        reportIsRunning = reportInstance.getStatus() == 'Running' || reportInstance.getStatus() == 'New';
        if (!reportIsRunning) {
            reportResults = reportInstance.getReportResults();
        }
    }
 
    public Reports.ReportResults getReportResults() {
        return reportResults;
    }
}