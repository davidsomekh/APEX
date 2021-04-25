@isTest
private class GeneratePKTest {

    static testMethod void myUnitTest() {
    	
       dongle__c tester;
       GeneratePK p = new GeneratePK();
       dongle__c	[] LIST_DONGLES = new List<dongle__c	>();
       Profiles__c	[] LIST_PROFILES = new List<Profiles__c	>();
       
	   dongle__c RECORD = new dongle__c(Name='testmethod123',Dongle_Expiry_Date__c	=date.newInstance(1990, 11, 21),Evaluation_Module__c='Payment',	Serial_No__c = '1233', 	Date_Of_Order__c = date.today(),Supply_Status__c = 'Purchase',Version__c = '190' ,Reseller__c = '00120000003k3Nm',Customer__c = '00120000003k3Nm' ,Order__c='006D000000ZQojP',Net_Dongle__c = true,Network_Profiles_Dongle__c =true,Actual_Users__c=2,Dongle_Type__c='MINI-NETUSB');
	   
	   LIST_DONGLES.add(RECORD);
	   insert LIST_DONGLES;
	   
	  
	   List<Dongle__c> arrDongles = [Select Id,AutoDesk__c,SolidWorks__c,Version__c,Supply_Status__c,
		Net_Dongle__c,Date_Of_Order__c,Name,Serial_No__c,Product_key__c,Actual_Users__c,Dongle_Expiry_Date__c,
		Customer__r.Name,Customer__r.Id,Inventor__c,Embedded_CAD__c,NX__c,Editor_Mode__c,SolidCAM_Mill_2D__c,
		SolidCAM_Mill_3D__c,SolidCAM_Mill_2_5D__c,Recoginition_Features__c,Chamfer_recognition__c,
		Reduced_HolesR__c,Hole_Recognition__c,Stl_Support__c,HSS_Rough__c,Prismatic_HSM__c,EDU__c,
		Spiral_Machining__c,iMachining3D__c,SolidCAM_Turning__c,BackSpindle__c,Sim_Turning__c,
		Multi_Turret_Sync__c,NO_G_code__c,Simultaneous_4_axes_C_axes__c,X4_axes_Indexial__c,X4_5_axes_indexial__c,	
		X5_axis__c,Simultaneous5axesReduced__c,	Machine_Simulation__c,Swarf_machining__c,Contour_5x__c,
		X5x_Drill__c,SolidCAM_Mill_3D_No_Engraving__c,Xpress_plus__c,MultiBlade5x__c,Port_5x__c,
		Mill_2D_V__c,HSS_V__c,HSM__c,No_HSS__c,Active_Key__c,Convert5X__c,SolidCAM_WireEDM_2_axes__c,
		SolidCAM_WireEDM_2_4_axes__c,GPX__c,Evaluation__c,Probe__c,G_Code_Simulation__c,TDM__c,
		WinTool__c,	Profile__c,Probe_Level2__c,SolidCAM_2_7D_CONSTANT_Z__c,Network_Profiles_Dongle__c,
		Bentley__c,CADTOOL__c,NCTOOL__c,DNCTOOL_For_Windows__c,Sentinel__c,BaseModeler__c,Clone_detection_disabled__c,Zoller_integration__c,Multi_Axis_Roughing__c,Screw_Machining__c	
		From Dongle__c	Where Name = 'testmethod123' Limit 1];
		
		
				    
       if(arrDongles.size() > 0)
	   {
   		    tester =  arrDongles[0];
   		    
   		    
   		     Profiles__c profile = new Profiles__c(DongleNo__c = tester.Id, Profile_No__c=2,Profile_Users__c =2,SolidCAM_Mill_2D__c =true,SolidCAM_Mill_2_5D__c=true,Chamfer_recognition__c=true,
   		     Contour_5x__c = true,X4_5_axes_indexial__c = true,X4_axes_Indexial__c=true,X5x_Drill__c=true,AUTODESK__c=true,Back_Spindle__c=true,Convert5x__c=true,G_Code_Simulation__c=true,
   		     Holes_Recognition__c=true,HSM__c=true,X5_axis__c=true,Spiral_Machining__c=true,iMachining3D__c=true,INVENTOR__c=true,Machine_Simulation__c=true,Multi_Axis_Roughing__c=true,
   		     MultiBlade_5x__c=true,Recognition_Features__c=true,Port_5x__c=true,Probe__c=true,Screw_Machining__c=true,Sim_Turning__c=true,Simultaneous_4_axes_C_axes__c=true,
   		     SolidCAM_Mill3D__c=true,SolidCAM_Turning__c=true,SolidCAM_WireEDM_2_axes__c=true,SolidCAM_WireEDM_2_4_axes__c=true,SOLIDWORKS__c=true,STL_Support__c=true,
   		     Swarf_machining__c=true,TDM__c=true,WinTool__c=true,XpressPlus__c=true,Zoller_integration__c=true,Multi_Turret_Sync__c=true,Eureka__c=true);
	   		LIST_PROFILES.add(profile);
	   		insert LIST_PROFILES;
	   		
	   		tester.Network_Profiles_Dongle__c = true;
	   
   		    JSONGenerator gen = JSON.createGenerator(true);
   		    gen.writeStartObject();
   		    p.AddFeatures(tester,gen,true);
   		    p.GetList(tester.Id);
   		    p.GeneratePK(tester.Id,true,false);
   		    p.GeneratePK(tester.Id,true,true);
	   	
	   }
    }
    
    static testMethod void Test_Batch() {
    	
    	CodeToCountry code = new CodeToCountry();
    	code.ConvertCode('IL');
    	code.ConvertCode('dada');
    	/*Lead LeadCode = new Lead();
    	LeadCode.LeadSource = 'Facebook (Trial)';
    	LeadCode.lastname = 'Test';
    	LeadCode.Company = 'Test';
    	LeadCode.Country = 'IL';
    	LeadCode.Status = 'Open';
    	
    	insert LeadCode;*/
    	
    	Account acc = new Account();
    	acc.Name = 'test';
    	acc.ShippingCountry = 'Germany';
    	insert acc;
    	Opportunity opp = new Opportunity();
    	opp.name='test';
    	opp.StageName='test';
    	opp.CloseDate=Date.today();
    	opp.Licens_type__c	= 'USB Dongle';
    	opp.Order_Type__c = 'Subscription';
    	insert opp;
    	Sales__c sales = new Sales__c();
    	sales.Name = 'test';
    	sales.Customer__c = acc.id;
    	insert sales;
    	Dongle__c dongle = new Dongle__c();
    	dongle.Name = 'test2';
    	dongle.Serial_No__c ='1234';
    	dongle.Order__c = opp.id;
    	dongle.Orders__c = sales.id;
    	dongle.Reseller__c = acc.id;
    	dongle.Customer__c = acc.id;
    	insert dongle;
    	PK_Batch ctrl = new PK_Batch(); 
        PageReference pageRef = Page.Sync_PK;
        Test.setCurrentPage(pageRef);
        
      
     //   ctrl.idList = dongle.id ;
		ctrl.execBatch();
		ctrl.GetIDS();		ctrl.setStatus('dd');
		ctrl.getStatus();
		
		Test.StartTest();
        PK_Batch_Daily instancevar = new PK_Batch_Daily();
        ID batchprocessid = Database.executeBatch(instancevar);
      
            
        PK_Batch_Version_Controller instancevar3 = new PK_Batch_Version_Controller();
        ID batchprocessid3 = Database.executeBatch(instancevar3);
        Test.StopTest();
		
    }
}