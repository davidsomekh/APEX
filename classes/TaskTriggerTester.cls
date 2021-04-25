/********************************
*	EmilK
*	Test trigger to insert event
********************************/
public class TaskTriggerTester {

static testmethod void runTest(){
			
		Lead l = new Lead(FirstName='test',LastName='ssss', Company='test', country='Israel');
		insert l;	
		
		 Task newTask = new Task();
		 newTask.Status = 'Not Started';
		 newTask.ActivityDate = Date.today();
		 newTask.Person__c = 'lolo';
		 newTask.Priority = 'Normal';
		 newTask.WhoId = l.Id;
		
		 Event newEvent = new Event();
		 newEvent.ActivityDate = Date.today();
		 newEvent.Person__c = 'david somekh';
		 newEvent.WhoId =  newTask.WhoId;
		 newEvent.StartDateTime = Datetime.now();
		 newEvent.EndDateTime = Datetime.now();
		
		 insert newTask;
		 insert newEvent;								   
	}
}