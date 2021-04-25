public with sharing class Dongle_Generate {
    public Dongle__c dongle {get;set;}
    public string getData(){return getDATA('<br/>');}
    public transient Attachment attachment {get;set;}
    public transient Boolean ErrorMessage {get;set;}
    public Boolean updatedDongle{get;set;}
    public Boolean TestBool{get;set;}
    public String m_PK_name {get;set;}
    public Boolean m_pk_progress {get;set;}
    public boolean m_attachment_download {get;set;}
    public transient Attachment m_pk_attachment {get;set;}
    
    public List<Profiles__c> m_Profiles {get;set;}
    
    public Dongle_Generate(){}
    
    public Dongle_Generate (Apexpages.Standardcontroller ctrl){
        dongle = (Dongle__c)ctrl.getRecord();
        dongle = [Select d.sentinel_update_supported__c, d.iMachining_seats__c, d.iMachining_on_profiles__c, d.iMachining_3D_on_profiles__c, d.iMachining3D_seats__c, d.iMachining3D__c, d.a2xisResult__c, d.Zero_Expirey_Date__c, d.ZERO__c, d.Year__c, d.Year_Expirey__c, d.YearExpiryValid__c, d.Xpress__c, d.XMT_Converter__c, d.XCZ_Axes_1st_Error__c, d.X5x_Drill__c, d.X5_axis__c, d.X5XReducedBurb__c, d.X4_axes_Indexial__c, d.X4_AXIS__c, d.X4_5_axes_indexial__c, d.X3D_CAD__c, d.X2_5D__c, d.X2_5DBurn__c, d.X2D_CAD__c, d.WireCut_4_axis_Error__c, d.WireCutBurn__c, d.WinTool__c, d.WinDnctool_Net_Users__c, d.WIRECUT__c, d.Version__c, d.Version_Translate__c, d.VDA_FS__c, d.Updated__c, d.USA_2009__c, d.Turning_Value__c, d.Turn_Mill_Error__c, d.TurnMillType_Burn__c, d.Today_Date__c, d.TV__c, d.TDM__c, d.SystemModstamp, d.Swarf_machining__c, d.Surf3Dburn__c, d.Supply_Status__c, d.Subscription_status__c, d.Sub_reseller_Country__c, d.Sub_Reseller_Mirror__c, d.Sub_Renew__c, d.SubReseller__c, d.Stl_Support__c, d.Step_Converter__c, d.Spiral_Machining__c, d.Special_Config__c, d.Solidworks_Type__c, d.SolidWorks__c, d.SolidCAM_WireEDM_2_axes__c, d.SolidCAM_WireEDM_2_4_axes__c, d.SolidCAM_Turning__c, d.SolidCAM_Turn_Mill_Options__c, d.SolidCAM_TurnMILL__c, d.SolidCAM_Mill_3D__c, d.SolidCAM_Mill_3D_No_Engraving__c, d.SolidCAM_Mill_3D_NO_HSM__c, d.SolidCAM_Mill_2_5D__c, d.SolidCAM_Mill_2D__c, d.SolidCAM_3D_HSM__c, d.SolidCAM_2_7D_CONSTANT_Z__c, d.Smm_Users_Error2__c, d.Slash__c, d.Simultaneous_4_axes_C_axes__c, d.Simultaneous5axesReduced__c, d.Sim_Turning__c, d.Sim_5_Axis_Level_Readme__c, d.Sim_5_Axes_Error__c, d.Serial_No__c, d.Sentinel__c, d.Sentinel_ID__c, d.Selected_Product__c, d.Sat_Converter__c, d.SalesSubReseller__c, d.SaleReseller__c, d.SaleOrderNumber__c, d.SaleCustomer__c, d.SW_Net_Formula__c, d.SURF_3D__c, d.SURFACES__c, d.SOLIDS__c, d.SMM__c, d.SMM_Users__c, d.SMM_Users_Formula__c, d.SMM_Users_Error__c, d.Reseller__c, d.Reseller_Text_Mirror__c, d.Reseller_Mirror__c, d.Reseller_Error__c, d.Reseller_Country__c, d.Release__c, d.Reduced_HolesR__c, d.Recoginition_Features__c, d.Read_2_5d__c, d.Quantity__c, d.Profile__c, d.Profile_Pocket_2_5D_Rest_Material__c, d.Products__c, d.Product_key__c, d.Probe_on_profiles__c, d.Probe__c, d.Probe_No__c, d.Probe_Level_2_Seats__c, d.Probe_Level2__c, d.Prismatic_HSM__c, d.Potential_Users__c, d.PRESETTER__c, d.OwnerId, d.Overide_CAD_Users__c, d.Orders__c, d.Order__c, d.Order_No_SalesForce__c, d.Order_No_Magic__c, d.Only_DncTool__c, d.On_Maintenance__c, d.Number_of_seats__c, d.Number_of_activations__c, d.No_Net_Error__c, d.No_HSS__c, d.No_Expire_Date__c, d.No_Cad_Intergration_With_CadTool__c, d.No_Cad_Intergration_With_Bently__c, d.No_Cad_Integration__c, d.No_CAD_Integration_with_Base_Modeler__c, d.NoExpireDate2__c, d.New_Maintenance_Type__c, d.New_Maintenance_Start_Date__c, d.New_Maintenance_End_Date__c, d.New_Cad_Intergration__c, d.Network_Profiles_Dongle__c, d.Net_Users_Error__c, d.Net_UP__c, d.Net_Profiles_Error__c, d.Net_Error0__c, d.Net_Dongle__c, d.NcTool_Net_Users__c, d.Name, d.NO_G_code__c, d.NCTOOL__c, d.NCTOOL_Turning__c, d.Multi_Turret_Sync__c, d.Month__c, d.Month_Expirey_Date__c, d.Modeler__c, d.Milling__c, d.Mill_2D_V__c, d.Maintenace_Start_Date__c, d.Maintenace_End_Date__c, d.Maintance__c, d.Maintance_Validity__c, d.Maintance_Type__c, d.Machinist__c, d.Machine_Simulation__c, d.Mac_Group__c, d.MILL_TURN__c, d.Logo__c, d.LogoError__c, d.LogoBurn__c, d.Last_Dongle_Record__c, d.LastModifiedDate, d.LastModifiedById, d.LastM__c, d.LastActivityDate, d.LT_Version__c, d.LOGO3__c, d.K_Users__c, d.Is_Relevant__c, d.IsRelevant_Expiry__c, d.IsDeleted, d.Inventor__c, d.Inventor_Net_Users__c, d.Internal_Use__c, d.Id, d.ISO_GCODE__c, d.ISCAR__c, d.IGES__c, d.Hole_Recognition__c, d.HSS__c, d.HSS_V__c, d.HSS_Rough__c, d.HSR_readme__c, d.HSM__c, d.HSM_V__c, d.GenerateHeadline__c, d.Gctool_Net_Users__c, d.G_Code_Simulation__c, d.GPX__c, d.GCTOOL__c, d.GCTOOL_Group__c, d.Furture__c, d.Features__c, d.Evaluation__c, d.Evaluation_Module__c, d.Evaluation_Key__c, d.Embedded_Users__c, d.Embedded_CAD__c, d.Educational_System_NCTOOL__c, d.Education_System_SolidCAM__c, d.Editor_Mode__c, d.EKey_Note__c, d.EDU__c, d.Dongle_Validation__c, d.Dongle_Validate__c, d.Dongle_Type__c, d.Dongle_Limits__c, d.Dongle_Index__c, d.Dongle_Expiry_Date__c, d.Dbtool_Net_Users__c, d.Day_Expirey__c, d.DayTranslate__c, d.Date_Of_Order__c, d.Date_Error__c, d.Date_Error_Translate__c, d.DateOfOrderError__c, d.DXF__c, d.DNCTool_Net_Users__c, d.DNCTOOL_For_Windows__c, d.DNCTOOL_For_Dos__c, d.DBTOOL__c, d.DAY__c, d.Customer_s_Country__c, d.Customer_mirror__c, d.Customer__c, d.CurrencyIsoCode, d.CreatedDate, d.CreatedById, d.Convert5X__c, d.Contact__c, d.ConnectionSentId, d.ConnectionReceivedId, d.Comments__c, d.CheckExpireDate__c, d.Calculate_Sub__c, d.Cadtool_Net_Users__c, d.CadToolIgesOut__c, d.CadToolIgesIn__c, d.CAD_Users__c, d.CAD_Type__c, d.CADTOOL__c, d.CADTOOL_NCTOOL_G_code__c, d.CADTOOL_IGES__c, d.Beta_Site__c, d.Bently_PowerModeler__c, d.Bently_Net_Users__c, d.Bently_Entry__c, d.Bently_EduFull__c, d.Bentley__c, d.Bentley_3D_Mill__c, d.Belongs_to_Inactive_Customer__c, d.Basemodeler_Net_Users__c, d.Base_Modeler_3D_Mill__c, d.BaseModeler__c, d.BackSpindle__c, d.Autodesk_Net_Users__c, d.Auto_Number_Int__c, d.AutoDesk__c, d.Actual_Users__c, d.Active_Key__c,
                    d.Current_version__c, d.MultiBlade5x__c,d.Multi_depth_Drill__c, d.Contour_5x__c, d.Port_5x__c, d.Xpress_plus__c, d.Chamfer_recognition__c,
                    d.Reseller__r.Name,d.Order__r.Id,d.Seat_activated__c,d.Swiss_Type__c, d.Customer__r.Name , d.SubReseller__r.Name,Zoller_integration__c,Multi_Axis_Roughing__c,Screw_Machining__c,Eureka_Simulator__c,Eureka_Machine_Editor__c,Eureka_Playlist__c,Eureka_Probe__c,Eureka_Cutting_Conditions__c,Eureka_Viewer__c,
                    Cimco__c,Simulator__c,Vericut__c,Eureka__c,X5x_breaking__c	,X5x_Edge_Trimming__c,Tooltable_Only__c
                    From Dongle__c d
                    where id = :dongle.id];
        updatedDongle = false;
        m_pk_progress = false;
        TestBool = true;
        m_pk_attachment = null;
    } 
    
    public boolean validate(boolean bCheckDate,boolean bEnableSoft){
        ErrorMessage = false;
        m_pk_attachment = null;
        string separator = '<br/>';
        if(dongle.Serial_No__c.contains('+')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Serial Number Error. Please check the key serial number and retry.'));ErrorMessage = true;}
        if(!bEnableSoft && dongle.Sentinel__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Software licenses cannot be updated.'));ErrorMessage = true;}
        IF(dongle.Active_Key__c == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'License is not active.'));ErrorMessage = true;}
        if(dongle.No_Net_Error__c !=null){      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.No_Net_Error__c));ErrorMessage = true;}
        if(dongle.Turn_Mill_Error__c !=null){   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.Turn_Mill_Error__c));ErrorMessage = true;}
        if(dongle.Sim_5_Axes_Error__c !=null){  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.Sim_5_Axes_Error__c));ErrorMessage = true;}
        if(bCheckDate && dongle.Date_Error__c !=null){        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.Date_Error__c));ErrorMessage = true;}
        if(dongle.XCZ_Axes_1st_Error__c !=null){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.XCZ_Axes_1st_Error__c));ErrorMessage = true;}
        if(dongle.Net_Users_Error__c !=null){   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.Net_Users_Error__c));ErrorMessage = true;}
        if(dongle.Reseller_Error__c !=null){    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.Reseller_Error__c));ErrorMessage = true;}
       // if(dongle.Net_Profiles_Error__c !=null){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.Net_Profiles_Error__c));ErrorMessage = true;}
        if(dongle.Special_Config__c !=null){    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.Special_Config__c));ErrorMessage = true;}
        if(dongle.WireCut_4_axis_Error__c !=null){ ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.WireCut_4_axis_Error__c));ErrorMessage = true;}
        if(dongle.LogoError__c !=null){             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.LogoError__c));ErrorMessage = true;}
        if(dongle.YearExpiryValid__c !=null){   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,dongle.YearExpiryValid__c));ErrorMessage = true;}
        
        GetProfiles(dongle);  
        integer iProfileUsers = GetProfilesUsers();
        
    	if(dongle.Network_Profiles_Dongle__c && m_Profiles.isEmpty())	{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This license does not have linked profiles. Please disable "Net Profiles" checkbox.'));}
    	if(!dongle.Network_Profiles_Dongle__c && !m_Profiles.isEmpty())	{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This license has linked profiles. Please enable "Net Profiles" checkbox.'));}
    	if(dongle.Network_Profiles_Dongle__c && !dongle.Net_Dongle__c)	{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This license has profiles. Please enable "Net Dongle" checkbox.'));}
    	if(!m_Profiles.isEmpty())
    	{
    		if(iProfileUsers > dongle.Actual_Users__c) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Overall users in profiles is GREATER than license users.'));}
    		if(iProfileUsers < dongle.Actual_Users__c) {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Overall users in profiles is LESS than license users.'));}
    	}
    	
	  
        
        if(ApexPages.currentPage() !=null && ApexPages.hasMessages() )
            return false;
         else
            return true;
    }
    
    public boolean GetEureka3XProfile(Profiles__c license_record)
    {
    	return license_record.Eureka_Simulator__c == 'Eureka3X';
    }
    
    public boolean GetEurekaMA1CProfile(Profiles__c license_record)
    {
    	return license_record.Eureka_Simulator__c == 'MAOC';
    }
    
    public boolean GetEurekaMAMCProfile(Profiles__c license_record)
    {
    	return license_record.Eureka_Simulator__c == 'MAMC';
    }
    
    public boolean GetEureka3X(Dongle__c license_record)
    {
    	return license_record.Eureka_Simulator__c == 'Eureka3X';
    }
    
     public boolean GetEurekaMA1C(Dongle__c license_record)
    {
    	return license_record.Eureka_Simulator__c == 'MAOC';
    }
    
    public boolean GetEurekaMAMC(Dongle__c license_record)
    {
    	return license_record.Eureka_Simulator__c == 'MAMC';
    	
    }
    
  
    
    public Pagereference updateDongle(){
	    User u = [select Id from User where Id =: UserInfo.getUserId() limit 1][0];
	    	
    	integer iVersionIndex = 0;
    	
    	if(dongle.Sentinel__c && !dongle.Seat_activated__c)
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'License needs to first be activated.'));
    	
    	if(dongle.New_Maintenance_End_Date__c == null)
    	{
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'License is not on subscription - not entitled to updates.'));
    	}
    	else
    	{
    		if(dongle.New_Maintenance_End_Date__c.year() < 2010)
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Subscription is too old (< 2010).'));
    		else
    			iVersionIndex = GetUpdateIndex(dongle.New_Maintenance_End_Date__c,dongle.Customer_s_Country__c);
    	}
    	
    	if(validate(false,true)){
    		if(integer.valueof(dongle.Version__c) < iVersionIndex)
    			dongle.Version__c = string.valueof(iVersionIndex);
    			
    		 		
    	if(dongle.Sentinel__c)
    		m_pk_progress = true;
    		
    		if(!dongle.Sentinel__c)
    			dongle.Date_Of_Order__c = Date.today();
    			
    	 	update dongle;
    		updatedDongle = true;
    		dongle = [Select d.sentinel_update_supported__c, d.iMachining_seats__c, d.iMachining_on_profiles__c, d.iMachining_3D_on_profiles__c, d.iMachining3D_seats__c, d.iMachining3D__c, d.a2xisResult__c, d.Zero_Expirey_Date__c, d.ZERO__c, d.Year__c, d.Year_Expirey__c, d.YearExpiryValid__c, d.Xpress__c, d.XMT_Converter__c, d.XCZ_Axes_1st_Error__c, d.X5x_Drill__c, d.X5_axis__c, d.X5XReducedBurb__c, d.X4_axes_Indexial__c, d.X4_AXIS__c, d.X4_5_axes_indexial__c, d.X3D_CAD__c, d.X2_5D__c, d.X2_5DBurn__c, d.X2D_CAD__c, d.WireCut_4_axis_Error__c, d.WireCutBurn__c, d.WinTool__c, d.WinDnctool_Net_Users__c, d.WIRECUT__c, d.Version__c, d.Version_Translate__c, d.VDA_FS__c, d.Updated__c, d.USA_2009__c, d.Turning_Value__c, d.Turn_Mill_Error__c, d.TurnMillType_Burn__c, d.Today_Date__c, d.TV__c, d.TDM__c, d.SystemModstamp, d.Swarf_machining__c, d.Surf3Dburn__c, d.Supply_Status__c, d.Subscription_status__c, d.Sub_reseller_Country__c, d.Sub_Reseller_Mirror__c, d.Sub_Renew__c, d.SubReseller__c, d.Stl_Support__c, d.Step_Converter__c, d.Spiral_Machining__c, d.Special_Config__c, d.Solidworks_Type__c, d.SolidWorks__c, d.SolidCAM_WireEDM_2_axes__c, d.SolidCAM_WireEDM_2_4_axes__c, d.SolidCAM_Turning__c, d.SolidCAM_Turn_Mill_Options__c, d.SolidCAM_TurnMILL__c, d.SolidCAM_Mill_3D__c, d.SolidCAM_Mill_3D_No_Engraving__c, d.SolidCAM_Mill_3D_NO_HSM__c, d.SolidCAM_Mill_2_5D__c, d.SolidCAM_Mill_2D__c, d.SolidCAM_3D_HSM__c, d.SolidCAM_2_7D_CONSTANT_Z__c, d.Smm_Users_Error2__c, d.Slash__c, d.Simultaneous_4_axes_C_axes__c, d.Simultaneous5axesReduced__c, d.Sim_Turning__c, d.Sim_5_Axis_Level_Readme__c, d.Sim_5_Axes_Error__c, d.Serial_No__c, d.Sentinel__c, d.Sentinel_ID__c, d.Selected_Product__c, d.Sat_Converter__c, d.SalesSubReseller__c, d.SaleReseller__c, d.SaleOrderNumber__c, d.SaleCustomer__c, d.SW_Net_Formula__c, d.SURF_3D__c, d.SURFACES__c, d.SOLIDS__c, d.SMM__c, d.SMM_Users__c, d.SMM_Users_Formula__c, d.SMM_Users_Error__c, d.Reseller__c, d.Reseller_Text_Mirror__c, d.Reseller_Mirror__c, d.Reseller_Error__c, d.Reseller_Country__c, d.Release__c, d.Reduced_HolesR__c, d.Recoginition_Features__c, d.Read_2_5d__c, d.Quantity__c, d.Profile__c, d.Profile_Pocket_2_5D_Rest_Material__c, d.Products__c, d.Product_key__c, d.Probe_on_profiles__c, d.Probe__c, d.Probe_No__c, d.Probe_Level_2_Seats__c, d.Probe_Level2__c, d.Prismatic_HSM__c, d.Potential_Users__c, d.PRESETTER__c, d.OwnerId, d.Overide_CAD_Users__c, d.Orders__c, d.Order__c, d.Order_No_SalesForce__c, d.Order_No_Magic__c, d.Only_DncTool__c, d.On_Maintenance__c, d.Number_of_seats__c, d.Number_of_activations__c, d.No_Net_Error__c, d.No_HSS__c, d.No_Expire_Date__c, d.No_Cad_Intergration_With_CadTool__c, d.No_Cad_Intergration_With_Bently__c, d.No_Cad_Integration__c, d.No_CAD_Integration_with_Base_Modeler__c, d.NoExpireDate2__c, d.New_Maintenance_Type__c, d.New_Maintenance_Start_Date__c, d.New_Maintenance_End_Date__c, d.New_Cad_Intergration__c, d.Network_Profiles_Dongle__c, d.Net_Users_Error__c, d.Net_UP__c, d.Net_Profiles_Error__c, d.Net_Error0__c, d.Net_Dongle__c, d.NcTool_Net_Users__c, d.Name, d.NO_G_code__c, d.NCTOOL__c, d.NCTOOL_Turning__c, d.Multi_Turret_Sync__c, d.Month__c, d.Month_Expirey_Date__c, d.Modeler__c, d.Milling__c, d.Mill_2D_V__c, d.Maintenace_Start_Date__c, d.Maintenace_End_Date__c, d.Maintance__c, d.Maintance_Validity__c, d.Maintance_Type__c, d.Machinist__c, d.Machine_Simulation__c, d.Mac_Group__c, d.MILL_TURN__c, d.Logo__c, d.LogoError__c, d.LogoBurn__c, d.Last_Dongle_Record__c, d.LastModifiedDate, d.LastModifiedById, d.LastM__c, d.LastActivityDate, d.LT_Version__c, d.LOGO3__c, d.K_Users__c, d.Is_Relevant__c, d.IsRelevant_Expiry__c, d.IsDeleted, d.Inventor__c, d.Inventor_Net_Users__c, d.Internal_Use__c, d.Id, d.ISO_GCODE__c, d.ISCAR__c, d.IGES__c, d.Hole_Recognition__c, d.HSS__c, d.HSS_V__c, d.HSS_Rough__c, d.HSR_readme__c, d.HSM__c, d.HSM_V__c, d.GenerateHeadline__c, d.Gctool_Net_Users__c, d.G_Code_Simulation__c, d.GPX__c, d.GCTOOL__c, d.GCTOOL_Group__c, d.Furture__c, d.Features__c, d.Evaluation__c, d.Evaluation_Module__c, d.Evaluation_Key__c, d.Embedded_Users__c, d.Embedded_CAD__c, d.Educational_System_NCTOOL__c, d.Education_System_SolidCAM__c, d.Editor_Mode__c, d.EKey_Note__c, d.EDU__c, d.Dongle_Validation__c, d.Dongle_Validate__c, d.Dongle_Type__c, d.Dongle_Limits__c, d.Dongle_Index__c, d.Dongle_Expiry_Date__c, d.Dbtool_Net_Users__c, d.Day_Expirey__c, d.DayTranslate__c, d.Date_Of_Order__c, d.Date_Error__c, d.Date_Error_Translate__c, d.DateOfOrderError__c, d.DXF__c, d.DNCTool_Net_Users__c, d.DNCTOOL_For_Windows__c, d.DNCTOOL_For_Dos__c, d.DBTOOL__c, d.DAY__c, d.Customer_s_Country__c, d.Customer_mirror__c, d.Customer__c, d.CurrencyIsoCode, d.CreatedDate, d.CreatedById, d.Convert5X__c, d.Contact__c, d.ConnectionSentId, d.ConnectionReceivedId, d.Comments__c, d.CheckExpireDate__c, d.Calculate_Sub__c, d.Cadtool_Net_Users__c, d.CadToolIgesOut__c, d.CadToolIgesIn__c, d.CAD_Users__c, d.CAD_Type__c, d.CADTOOL__c, d.CADTOOL_NCTOOL_G_code__c, d.CADTOOL_IGES__c, d.Beta_Site__c, d.Bently_PowerModeler__c, d.Bently_Net_Users__c, d.Bently_Entry__c, d.Bently_EduFull__c, d.Bentley__c, d.Bentley_3D_Mill__c, d.Belongs_to_Inactive_Customer__c, d.Basemodeler_Net_Users__c, d.Base_Modeler_3D_Mill__c, d.BaseModeler__c, d.BackSpindle__c, d.Autodesk_Net_Users__c, d.Auto_Number_Int__c, d.AutoDesk__c, d.Actual_Users__c, d.Active_Key__c,
                    d.Current_version__c, d.Order__r.Id,d.MultiBlade5x__c, d.Contour_5x__c, d.Port_5x__c, d.Xpress_plus__c, d.Chamfer_recognition__c,
                    d.Reseller__r.Name , d.Multi_depth_Drill__c,d.Swiss_Type__c, d.Customer__r.Name , d.SubReseller__r.Name,Zoller_integration__c,Multi_Axis_Roughing__c,Screw_Machining__c,Eureka_Simulator__c,Eureka_Machine_Editor__c,Eureka_Playlist__c,Eureka_Probe__c,Eureka_Cutting_Conditions__c,Eureka_Viewer__c,
                    Cimco__c,Simulator__c,Vericut__c,Eureka__c,X5x_breaking__c	,X5x_Edge_Trimming__c,Tooltable_Only__c
                    From Dongle__c d
                    where id = :dongle.id];
    	}
    	
    	return null;
    }
    
    public integer GetUpdateIndex(Date SubsDate,String sCountry)
    {
    	Date now = date.today();
        if((SubsDate.year() >= now.year()))
      	{
       		return 220 + (10 * (now.year() - 2019));
      	}
   
    	return 220 - (10 * (2019 - SubsDate.year()));


    }
    
   
    public Dongle__c GetDongle(ID license)
	{
		dongle__c record;
		String day = '';
		String month = '';
		String year = '';
		String name = '';
		String AccountID = '';
		Date exp;
		
		List<Dongle__c> ARR = [Select 	Name,Date_Of_Order__c,Dongle_Expiry_Date__c
		From Dongle__c	Where id =: license Limit 1];
		
		if(ARR.size() > 0)
			return ARR[0];
			
		return null;
		
	}
	
	public void GeneratePK()
	{
		GeneratePK g = new GeneratePK();
		g.m_version_mode = true;
		String pk = g.GeneratePK(dongle.Id,false,false);
		
		if(g.m_status_code == 201 || g.m_status_code == 203)
			m_pk_name = pk;
			
		if(g.m_status_code == 206 && g.m_attachment_download)
		{
			m_attachment_download = true;
			m_pk_attachment = g.m_attachment;
		}
			
		m_pk_progress = false;
		
		
	}
	
	public Pagereference GenerateLicense()
	{ 
      	if(!dongle.Sentinel__c)
    		GenerateDongle();
    	else
    		GeneratePK();
          	
        return null;
    } 
    
    public Pagereference GenerateDongle(){ 
        if(validate(true,false)){
           licenseCreation();
        }
        return null;
    }
    
    public void licenseCreation(){
    	Http http = new Http();
        Httprequest req = new Httprequest();
        Httpresponse resp = new Httpresponse();

    
        /*
            attachment = new Attachment();
            attachment.Body = Blob.valueOf(getDATA('\r\n'));
            attachment.Name = dongle.Name+'.txt';
            attachment.ParentId = dongle.Id;
          */  
            
        //log(body);
        string sticker=Encodingutil.urlEncode(dongle.Name,'UTF-8');
        string dataF=Encodingutil.urlEncode(getDATA('\r\n'),'UTF-8');
        String body = 'sticker='+sticker+'&data='+dataF+'&submit=Submit';
        // 'http://166.78.64.240:8080/license.php' // Sandbox link 'http://solid-php.cloudapp.net/license.php'
        req.setEndpoint('http://solid-php.westeurope.cloudapp.azure.com/license.php');
        //req.setHeader('Content-Type', 'multipart/form-data; boundary='+boundary);
        //log(req.getHeader('Content-Type'));
        req.setMethod('POST');
        req.setBody(body);

        if(!Test.isRunningTest())
        resp = http.send(req); 
        
         //insert attachment;
        
        ID RECID = dongle.Order__r.Id;
        
        Boolean upload_to_opp = true;
        
        Boolean opp_cancel_upload = false;
        
        if(dongle.Order__r.Id == null)
        	upload_to_opp = false;
        
      //  String strId = Id.valueOf(RECID);
        
        //String dave = '';
        
      // List<UserRecordAccess> ACC = [SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :strId];
       // =//[Select Technical_users__c From User Where Id = :UserInfo.getUserId()][0].Technical_users__c;
	        
        
        String fileName = ''+resp.getHeader('Content-Disposition');
        if(fileName != null && fileName.contains('='))
            fileName = fileName.split('=')[1];
        if(resp.getBodyAsBlob() != null ){
            attachment = new Attachment();
            attachment.Body = resp.getBodyAsBlob();
            attachment.Name = fileName;
            attachment.ParentId = dongle.Id;
            insert attachment;
            if(dongle.Order__c != null && upload_to_opp)
            {
            	Attachment opp = new Attachment();
            	opp = new Attachment();
            	opp.Body = resp.getBodyAsBlob();
            	opp.Name = fileName;
            	opp.ParentID = dongle.Order__c;
            	try{
            		insert opp;
            	}catch(exception e){}
            }
        } 
    }
    
    public string formatDecimal(Decimal b){
        return (b==null ? '' : String.valueOf( Integer.valueOf(b) ));
    }
    public string formatBoolean(Boolean b){
        return (b ? '1' : '0');
    }
    public string formatNull(String str){
        return (str==null ? '' : str);
    }
    public string formatDate(Date d){
        DateTime dt = d;
        return (d==null ? '' : formatDate(dt));
    }
    public string formatDate(DateTime d){
        return (d==null ? '' : d.format('dd/MM/yyyy'));
    }
    public void log(Object obj){
        System.debug('\n\n\n'+obj+'\n\n\n');
    }
    
    public void GetProfiles(Dongle__c d)
    {
    	m_Profiles = [Select Profile_No__c,Chamfer_recognition__c,Contour_5x__c,SolidCAM_Mill_2D__c,SolidCAM_Mill_2_5D__c,X4_5_axes_indexial__c	,X4_axes_Indexial__c,X5x_Drill__c,
		AUTODESK__c,Back_Spindle__c,	Profile_Users__c,Convert5x__c	,G_Code_Simulation__c,Holes_Recognition__c,HSM__c,HSS_Rough__c,HSS_V__c,Spiral_Machining__c,
		iMachining3D__c,INVENTOR__c,Machine_Simulation__c,Mill_2D_V__c,Multi_Axis_Roughing__c,MultiBlade_5x__c,No_HSS__c,Recognition_Features__c,Port_5x__c,Prismatic_HSM__c,
		Probe__c,Probe_Level2__c,HSM_V__c,Reduced_HolesR__c,Screw_Machining__c,Sim_Turning__c,X5_axis__c,Simultaneous_5_axes_Reduced__c,Simultaneous_4_axes_C_axes__c,SolidCAM_Mill3D__c,
		Multi_depth_Drill__c,SolidCAM_Mill_3D_No_Engraving__c,SolidCAM_Turning__c,SolidCAM_WireEDM_2_axes__c,SolidCAM_WireEDM_2_4_axes__c,SOLIDWORKS__c,STL_Support__c,Swarf_machining__c,TDM__c,
		WinTool__c,XpressPlus__c,TurnMill_burn__c,SolidWorks_PA__c,Con5X_Burn__c,POSW_Burn__c,Embedded_Burn__c,HssRoughBurn__c,Pocet__c,ReducedBurn__c,SolidCAM_TurnMill__c,Zoller_integration__c,Multi_Turret_Sync__c,SolidCAM_2_7D_CONSTANT_Z__c,Profile__c,BaseModeler__c,Bently__c,Editor_Mode__c,Swiss_Type__c,Eureka_Simulator__c,Eureka_Machine_Editor__c,Eureka_Playlist__c,Eureka_Probe__c,Eureka_Cutting_Conditions__c,Eureka_Viewer__c,
        Cimco__c,Simulator__c,Vericut__c,Eureka__c,X5x_Edge_Breaking__c	,X5x_Edge_Trimming__c,Tooltable_Only__c
			From Profiles__c Where DongleNo__c =: d.Id ORDER BY Profile_No__c];
    }
    
    public integer GetProfilesUsers()
    {
    	integer iUsers = 0;
    	for (Profiles__c p : m_Profiles) 
    		iUsers  = iUsers += p.Profile_Users__c.intValue();
    		
    	
    	return iUsers;
    }
    
    public string GetProfilesData(Dongle__c dong,String sNewRow){
    	
  
    	String sProfiles = '';
     	integer iProfNumber = 1;
    	    	
    	
    	      	
    	for (Profiles__c p : m_Profiles) 
    	{
    		String sHss = '0';
    		if(p.X5_axis__c && !p.No_HSS__c)
    			sHss = '1';
    		
    		sProfiles = sProfiles += ';Prof data:' + sNewRow;
    		
 			sProfiles = sProfiles += ';==========' + sNewRow;
			sProfiles = sProfiles += 'Prof_def = ' + iProfNumber + sNewRow;
			sProfiles = sProfiles += 'Prof_users = ' + p.Profile_Users__c + sNewRow ;
			sProfiles = sProfiles += 'Prof_runs = 65535' + sNewRow ;
			sProfiles = sProfiles += 'Is_BASMODELER = ' + formatBoolean(p.BaseModeler__c) + sNewRow;
			sProfiles = sProfiles += 'Is_BENTLEY = ' + formatBoolean(p.Bently__c) + sNewRow;
			sProfiles = sProfiles += 'Is_AUTODESK = ' + formatBoolean(p.AUTODESK__c)  + sNewRow;
			sProfiles = sProfiles += 'Is_SOLIDWORKS = ' + formatBoolean(p.SOLIDWORKS__c) + sNewRow;
			sProfiles = sProfiles += 'Is_INVENTOR = ' + formatBoolean(p.INVENTOR__c) + sNewRow;
			sProfiles = sProfiles += 'Multi_Surf = ' + formatBoolean(p.SolidCAM_Mill3D__c) + sNewRow;
			sProfiles = sProfiles += 'Mill_2D = ' + formatBoolean(p.SolidCAM_Mill_2D__c) + sNewRow;
			sProfiles = sProfiles += 'Mill_2.5D = ' + formatBoolean(p.SolidCAM_Mill_2_5D__c) + sNewRow;
			sProfiles = sProfiles += 'Full_Turning = ' + formatBoolean(p.SolidCAM_Turning__c) + sNewRow;
			sProfiles = sProfiles += '4_Axis = ' + formatBoolean(p.Simultaneous_4_axes_C_axes__c) + sNewRow;
			sProfiles = sProfiles += 'TurnMill = ' + formatBoolean(p.SolidCAM_TurnMill__c) + sNewRow;
			sProfiles = sProfiles += 'Profile = ' + formatBoolean(p.Profile__c) + sNewRow;
			sProfiles = sProfiles += 'Rest_Material = ' + formatBoolean(p.Pocet__c) + sNewRow;
			sProfiles = sProfiles += 'Axis_4_MSided = ' + formatBoolean(p.X4_axes_Indexial__c) + sNewRow;
			sProfiles = sProfiles += 'Axis_5_MSided = ' + formatBoolean(p.X4_5_axes_indexial__c) + sNewRow;
			sProfiles = sProfiles += '3D_Mill_Level = ' + formatBoolean(p.SolidCAM_2_7D_CONSTANT_Z__c) + sNewRow;
			sProfiles = sProfiles += 'Solid_WireCut = ' + formatBoolean(p.SolidCAM_WireEDM_2_axes__c) + sNewRow;
			sProfiles = sProfiles += 'WireCut_4x = ' + formatBoolean(p.SolidCAM_WireEDM_2_4_axes__c) + sNewRow;
			sProfiles = sProfiles += 'Sim_5_Axis = ' + formatBoolean(p.X5_axis__c) + sNewRow;
			sProfiles = sProfiles += 'Sim5x_Reduce = ' + integer.valueof(p.ReducedBurn__c) + sNewRow;
			sProfiles = sProfiles += 'Machine_Sim = ' + formatBoolean(p.Machine_Simulation__c) + sNewRow;
			sProfiles = sProfiles += 'Turn_Mill_Typ = ' + integer.valueof(p.TurnMill_burn__c) + sNewRow;
			sProfiles = sProfiles += 'Back_Spindle = ' + formatBoolean(p.Back_Spindle__c) + sNewRow;
			sProfiles = sProfiles += 'HSM = ' + formatBoolean(p.HSM__c) + sNewRow;
			sProfiles = sProfiles += 'AFRM = ' + formatBoolean(p.Holes_Recognition__c) + sNewRow;
			sProfiles = sProfiles += 'Chamfer = ' + formatBoolean(!p.Chamfer_recognition__c) + sNewRow;
			sProfiles = sProfiles += 'Zoller = ' + formatBoolean(!p.Zoller_integration__c) + sNewRow;
            sProfiles = sProfiles += 'Trimming = ' + formatBoolean(!p.X5x_Edge_Trimming__c) + sNewRow;
            sProfiles = sProfiles += 'Breaking = ' + formatBoolean(!p.X5x_Edge_Breaking__c) + sNewRow;
            sProfiles = sProfiles += 'Eureka = ' + formatBoolean(!p.Eureka__c) + sNewRow;
            sProfiles = sProfiles += 'Vericut = ' + formatBoolean(!p.Vericut__c) + sNewRow;
            sProfiles = sProfiles += 'Cimco = ' + formatBoolean(!p.Cimco__c) + sNewRow;
            sProfiles = sProfiles += 'Simulator = ' + formatBoolean(!p.Simulator__c) + sNewRow;
            sProfiles = sProfiles += 'ToolTable = ' + formatBoolean(!p.Tooltable_Only__c) + sNewRow;
			sProfiles = sProfiles += 'Swiss = ' + formatBoolean(!p.Swiss_Type__c) + sNewRow;
			sProfiles = sProfiles += 'Mdepth = ' + formatBoolean(p.Multi_depth_Drill__c) + sNewRow;
			sProfiles = sProfiles += 'Rough5X = ' + formatBoolean(!p.Multi_Axis_Roughing__c) + sNewRow;
			sProfiles = sProfiles += 'Screw = ' + formatBoolean(!p.Screw_Machining__c) + sNewRow;
			sProfiles = sProfiles += 'Rm_Dril_Rcg = ' + formatBoolean(p.Reduced_HolesR__c) + sNewRow;
			sProfiles = sProfiles += 'STL_cut = ' + formatBoolean(p.STL_Support__c) + sNewRow;
			sProfiles = sProfiles += 'Spiral = ' + formatBoolean(p.Spiral_Machining__c) + sNewRow;
			sProfiles = sProfiles += '3DSpiral = ' + formatBoolean(p.iMachining3D__c) + sNewRow;
			sProfiles = sProfiles += 'Probe = ' + formatBoolean(p.Probe__c) + sNewRow;
			sProfiles = sProfiles += 'R_Probe = ' + formatBoolean(!p.Probe_Level2__c) + sNewRow;
			sProfiles = sProfiles += 'Swarf = ' + formatBoolean(p.Swarf_machining__c) + sNewRow;
			sProfiles = sProfiles += 'MultiBlade = ' + formatBoolean(!p.MultiBlade_5x__c) + sNewRow;
			sProfiles = sProfiles += 'Contour5x = ' + formatBoolean(!p.Contour_5x__c) + sNewRow;
			sProfiles = sProfiles += 'Port = ' + formatBoolean(!p.Port_5x__c) + sNewRow;
			sProfiles = sProfiles += 'Plus = ' + formatBoolean(!p.XpressPlus__c) + sNewRow;
			sProfiles = sProfiles += 'Editor = ' + formatBoolean(!p.Editor_Mode__c) + sNewRow;
			sProfiles = sProfiles += 'Prismatic = ' + formatBoolean(!p.Prismatic_HSM__c) + sNewRow;
			sProfiles = sProfiles += 'Turret = ' + formatBoolean(!p.Multi_Turret_Sync__c) + sNewRow;
			sProfiles = sProfiles += '3dMillR = ' + formatBoolean(!p.SolidCAM_Mill_3D_No_Engraving__c) + sNewRow;
			sProfiles = sProfiles += 'WinTool = ' + formatBoolean(!p.WinTool__c) + sNewRow;
			sProfiles = sProfiles += 'GCodeSim = ' + formatBoolean(!p.G_Code_Simulation__c) + sNewRow;
			sProfiles = sProfiles += 'HssRough = ' + p.HssRoughBurn__c + sNewRow;
			sProfiles = sProfiles += 'Embedded = ' + p.Embedded_Burn__c + sNewRow;
			sProfiles = sProfiles += 'POSW = ' + p.POSW_Burn__c + sNewRow;
			sProfiles = sProfiles += '5xDrill = ' + formatBoolean(p.X5x_Drill__c) + sNewRow;
			sProfiles = sProfiles += 'Convert5x = ' + p.Con5X_Burn__c + sNewRow;
			sProfiles = sProfiles += 'SimTurn = ' + formatBoolean(p.Sim_Turning__c) + sNewRow;
			sProfiles = sProfiles += 'HSV = ' + formatBoolean(p.HSM_V__c) + sNewRow;
			sProfiles = sProfiles += 'HssV = ' + formatBoolean(p.HSS_V__c) + sNewRow;
			sProfiles = sProfiles += '2dV = ' + formatBoolean(p.Mill_2D_V__c) + sNewRow;
			sProfiles = sProfiles += 'SWPA = ' + formatBoolean(p.SolidWorks_PA__c) + sNewRow;
			sProfiles = sProfiles += 'TDM = ' + formatBoolean(p.TDM__c) + sNewRow;
			sProfiles = sProfiles += 'HSS = ' + sHss + sNewRow;
			sProfiles = sProfiles += 'Drill_Rcgnize = ' + formatBoolean(p.Recognition_Features__c) + sNewRow;
			
			
			iProfNumber++;
		}
		
		//System.debug(sProfiles);
		
    	return sProfiles;
    }
    
 
    public string getDATA(String separator){
        String dataF = '';
        dataF += '' + dongle.GenerateHeadline__c + separator ;
        dataF += ';==============' + separator ;
        dataF += 'Current_date = ' + formatDecimal(dongle.DAY__c) + '/' + formatDecimal(dongle.Month__c) + '/' + formatDecimal(dongle.ZERO__c) + '' + formatDecimal(dongle.Year__c) + separator ;
        dataF += 'Expired_date = ' + formatDecimal(dongle.Day_Expirey__c) + '' + formatNull(dongle.Slash__c) + '' + formatDecimal(dongle.Month_Expirey_Date__c) + '' + formatNull(dongle.Slash__c) + '' + formatDecimal(dongle.Zero_Expirey_Date__c) + '' + formatDecimal(dongle.Year_Expirey__c) + '' + formatNull(dongle.CheckExpireDate__c) + separator ;
        dataF += 'Is_CADTOOL   = ' + formatBoolean(dongle.CADTOOL__c) + separator ;
        dataF += 'Is_NCTOOL    = ' + formatBoolean(dongle.NCTOOL__c) + separator ;
        dataF += 'Is_GCTOOL    = ' + formatBoolean(dongle.GCTOOL__c) + separator ;
        dataF += 'Is_DNCTOOL   = ' + formatBoolean(dongle.DNCTOOL_For_Dos__c) + separator ;
        dataF += 'Is_DBTOOL    = ' + formatBoolean(dongle.DBTOOL__c) + separator ;
        dataF += 'Is_MODELER   = ' + formatBoolean(dongle.Modeler__c) + separator ;
        dataF += 'Is_MACHINIST = ' + formatBoolean(dongle.Machinist__c) + separator ;
        dataF += 'Is_BENTLEY   = ' + formatBoolean(dongle.Bentley__c) + separator ;
        dataF += 'Is_WDNCTOOL  = ' + formatBoolean(dongle.DNCTOOL_For_Windows__c) + separator ;
        dataF += 'Is_AUTODESK  = ' + formatBoolean(dongle.AutoDesk__c) + separator ;
        dataF += 'Is_BASMODELER= ' + formatBoolean(dongle.BaseModeler__c) + separator ;
        dataF += 'Is_SOLIDWORKS= ' + formatBoolean(dongle.SolidWorks__c) + separator ;
        dataF += 'Is_INVENTOR  = ' + formatBoolean(dongle.Inventor__c) + separator ;
        dataF += 'Milling      = ' + formatBoolean(dongle.Milling__c) + separator ;
        dataF += 'Turning      = ' + formatBoolean(dongle.NCTOOL_Turning__c) + separator ;
        dataF += 'Surface      = ' + formatDecimal(dongle.Surf3Dburn__c) + separator ;
        dataF += 'CAD_3D       = ' + formatBoolean(dongle.X3D_CAD__c) + separator ;
        dataF += 'CAD_full     = ' + formatBoolean(dongle.X2D_CAD__c) + separator ;
        dataF += 'IGES_in      = ' + formatDecimal(dongle.CadToolIgesIn__c) + separator ;
        dataF += 'IGES_out     = ' + formatDecimal(dongle.CadToolIgesOut__c) + separator ;
        dataF += '4X           = ' + formatBoolean(dongle.X4_AXIS__c) + separator ;
        dataF += 'WIRE_CUT     = ' + formatDecimal(dongle.WireCutBurn__c) + separator ;
        dataF += 'MILL_TURN    = ' + formatBoolean(dongle.MILL_TURN__c) + separator ;
        dataF += '2.5D         = ' + formatDecimal(dongle.X2_5DBurn__c) + separator ;
        dataF += 'Beta_site    = ' + formatBoolean(dongle.Beta_Site__c) + separator ;
        dataF += 'Education    = 0 ' + separator ;
        dataF += 'Gen_gcode    = ' + formatBoolean(dongle.CADTOOL_NCTOOL_G_code__c) + separator ;
        dataF += 'TRUE         = 1 ' + separator ;
        dataF += 'DNC_macro    = ' + formatBoolean(dongle.PRESETTER__c) + separator ;
        dataF += 'Limited_NC   = ' + formatBoolean(dongle.LT_Version__c) + separator ;
        dataF += 'Advanced_post= 0 ' + separator ;
        dataF += 'Only_nctool  = 0 ' + separator ;
        dataF += 'CAD_iso      = ' + formatBoolean(dongle.ISO_GCODE__c) + separator ;
        dataF += 'Iges_conv    = ' + formatBoolean(dongle.IGES__c) + separator ;
        dataF += 'Dxf_conv     = ' + formatBoolean(dongle.DXF__c) + separator ;
        dataF += 'Vda-fs_conv  = ' + formatBoolean(dongle.VDA_FS__c) + separator ;
        dataF += 'Surfs        = ' + formatBoolean(dongle.SURFACES__c) + separator ;
        dataF += 'Solids       = ' + formatBoolean(dongle.SOLIDS__c) + separator ;
        dataF += 'Multi_Surf   = ' + formatBoolean(dongle.SolidCAM_Mill_3D__c) + separator ;
        dataF += 'Mill_2D      = ' + formatBoolean(dongle.SolidCAM_Mill_2D__c) + separator ;
        dataF += 'Mill_2.5D    = ' + formatBoolean(dongle.SolidCAM_Mill_2_5D__c) + separator ;
        dataF += 'Mill_3D      = 0 ' + separator ;
        dataF += 'ISCAR        = ' + formatBoolean(dongle.ISCAR__c) + separator ;
        dataF += 'Full_Turning = ' + formatBoolean(dongle.SolidCAM_Turning__c) + separator ;
        dataF += 'Int_Use      = ' + formatBoolean(dongle.Internal_Use__c) + separator ;
        dataF += 'Solid_Edu    = ' + formatBoolean(dongle.EDU__c) + separator ;
        dataF += 'Cam_Demo     = 0 ' + separator ;
        dataF += '4_Axis       = ' + formatBoolean(dongle.Simultaneous_4_axes_C_axes__c) + separator ;
        dataF += 'TurnMill     = ' + formatBoolean(dongle.SolidCAM_TurnMILL__c) + separator ;
        dataF += 'Profile      = ' + formatBoolean(dongle.Profile__c) + separator ;
        dataF += 'Rest_Material= ' + formatBoolean(dongle.Profile_Pocket_2_5D_Rest_Material__c) + separator ;
        dataF += 'Solid_GenGcod= ' + formatBoolean(dongle.NO_G_code__c) + separator ;
        dataF += 'Axis_4_MSided= ' + formatBoolean(dongle.X4_axes_Indexial__c) + separator ;
        dataF += 'Axis_5_MSided= ' + formatBoolean(dongle.X4_5_axes_indexial__c) + separator ;
        dataF += '3D_Mill_Level= ' + formatBoolean(dongle.SolidCAM_2_7D_CONSTANT_Z__c) + separator ;
        dataF += 'Solid_WireCut= ' + formatBoolean(dongle.SolidCAM_WireEDM_2_axes__c) + separator ;
        dataF += 'WireCut_4x   = ' + formatBoolean(dongle.SolidCAM_WireEDM_2_4_axes__c) + separator ;
        dataF += 'Drill_Rcgnize= ' + formatBoolean(dongle.Recoginition_Features__c) + separator ;
        dataF += 'Sim_5_Axis   = ' + formatBoolean(dongle.X5_axis__c) + separator ;
        dataF += 'Sim5x_Reduce = ' + formatDecimal(dongle.X5XReducedBurb__c) + separator ;
        dataF += 'Machine_Sim  = ' + formatBoolean(dongle.Machine_Simulation__c) + separator ;
        dataF += 'Turn_Mill_Typ= ' + formatDecimal(dongle.TurnMillType_Burn__c) + separator ;
        dataF += 'Back_Spindle = ' + formatBoolean(dongle.BackSpindle__c) + separator ;
        dataF += 'HSM          = ' + formatBoolean(dongle.HSM__c) + separator ;
        dataF += 'AFRM          = ' + formatBoolean(dongle.Hole_Recognition__c) + separator ;
        dataF += 'Chamfer          = ' + formatBoolean(dongle.Chamfer_recognition__c) + separator ;
        dataF += 'Zoller          = ' + formatBoolean(dongle.Zoller_integration__c) + separator ;
        dataF += 'Breaking          = ' + formatBoolean(dongle.X5x_breaking__c) + separator ;
        dataF += 'Trimming          = ' + formatBoolean(dongle.X5x_Edge_Trimming__c) + separator ;
        dataF += 'Eureka          = ' + formatBoolean(dongle.Eureka__c) + separator ;
        dataF += 'Vericut          = ' + formatBoolean(dongle.Vericut__c) + separator ;
        dataF += 'Cimco          = ' + formatBoolean(dongle.Cimco__c) + separator ;
        dataF += 'Simulator          = ' + formatBoolean(dongle.Simulator__c) + separator ;
        dataF += 'ToolTable          = ' + formatBoolean(dongle.Tooltable_Only__c) + separator ;
        dataF += 'Swiss          = ' + formatBoolean(dongle.Swiss_Type__c) + separator ;
        dataF += 'Mdepth          = ' + formatBoolean(dongle.Multi_depth_Drill__c) + separator ;
        dataF += 'Rough5X          = ' + formatBoolean(dongle.Multi_Axis_Roughing__c	) + separator ;
        dataF += 'Screw          = ' + formatBoolean(dongle.Screw_Machining__c) + separator ;
        dataF += 'Rm_Dril_Rcg          = ' + formatBoolean(dongle.Reduced_HolesR__c) + separator ;
        dataF += 'STL_cut    = ' + formatBoolean(dongle.Stl_Support__c) + separator ;
        dataF += 'Spiral    = ' + formatBoolean(dongle.Spiral_Machining__c) + separator ;
        dataF += '3DSpiral    = ' + formatBoolean(dongle.iMachining3D__c) + separator ;
        dataF += 'Probe    = ' + formatBoolean(dongle.Probe__c) + separator ;
        dataF += 'R_Probe    = ' + formatBoolean(dongle.Probe_Level2__c) + separator ;
        dataF += 'Swarf    = ' + formatBoolean(dongle.Swarf_machining__c) + separator ;
        
        
        
        dataF += 'MultiBlade    = ' + formatBoolean(dongle.MultiBlade5x__c) + separator ;
        dataF += 'Contour5x    = ' + formatBoolean(dongle.Contour_5x__c) + separator ;
        dataF += 'Port    = ' + formatBoolean(dongle.Port_5x__c) + separator ;
        dataF += 'Plus    = ' + formatBoolean(dongle.Xpress_plus__c) + separator ;
        
        
        
        dataF += 'Editor    = ' + formatBoolean(dongle.Editor_Mode__c) + separator ;
        dataF += 'Prismatic    = ' + formatBoolean(dongle.Prismatic_HSM__c) + separator ;
        dataF += 'Turret   = ' + formatBoolean(dongle.Multi_Turret_Sync__c) + separator ;
        dataF += '3dMillR   = ' + formatBoolean(dongle.SolidCAM_Mill_3D_No_Engraving__c) + separator ;
        dataF += 'WinTool    =' + formatBoolean(dongle.WinTool__c) + separator ;
        dataF += 'GCodeSim    =' + formatBoolean(dongle.G_Code_Simulation__c) + separator ;
        dataF += 'HssRough = ' + formatBoolean(dongle.HSS_Rough__c) + separator ;
        dataF += 'Embedded = ' + (dongle.Embedded_CAD__c == 'Full' ? 1 : 0) + separator ;
        dataF += 'POSW = ' + (dongle.Embedded_CAD__c == 'P/O' ? 1 : 0) + separator ;
        dataF += '5xDrill = ' + formatBoolean(dongle.X5x_Drill__c) + separator ;
        dataF += 'Convert5x = ' + formatBoolean(dongle.Convert5X__c) + separator ;
        dataF += 'SimTurn = ' + formatBoolean(dongle.Sim_Turning__c) + separator ;
        dataF += 'HSV = ' + formatBoolean(dongle.HSM_V__c) + separator ;
        dataF += 'HssV = ' + formatBoolean(dongle.HSS_V__c) + separator ;
        dataF += '2dV = ' + formatBoolean(dongle.Mill_2D_V__c) + separator ;
        dataF += 'SWPA = ' + ( dongle.Embedded_CAD__c == 'P/A' ? 1 : 0) + separator ;
        dataF += 'TDM = ' + formatBoolean(dongle.TDM__c) + separator ;
        dataF += 'HSS = ' + ( ( dongle.X5_axis__c && ! dongle.No_HSS__c ) ? 1 : 0) + separator ;
        dataF += 'PAS = ' + formatBoolean(dongle.SMM__c) + separator ;
        dataF += 'GPX = ' + formatBoolean(dongle.GPX__c) + separator ;
        dataF += 'Bntly_Demo   = 0 '+ separator ;
        dataF += 'Bntly_edu_ful= ' + formatBoolean(dongle.Bently_EduFull__c) + separator ;
        dataF += 'Bntly_o_pmd  = ' + formatBoolean(dongle.Bently_PowerModeler__c) + separator ;
        dataF += 'Bntly_E_o_pmd= ' + formatBoolean(dongle.Bently_Entry__c) + separator ;
        dataF += 'Bntly_Xmt    = ' + formatBoolean(dongle.XMT_Converter__c) + separator ;
        dataF += 'Bntly_Sat    = ' + formatBoolean(dongle.Sat_Converter__c) + separator ;
        dataF += 'Bntly_Step   = ' + formatBoolean(dongle.Step_Converter__c) + separator ;
        dataF += 'Version      = ' + dongle.TV__c + separator ;
        dataF += 'HASP_version = ' + separator ;
        dataF += 'Logo_type    = ' + formatDecimal(dongle.LogoBurn__c) + separator ;
        dataF += 'GC_group     = 0 ' + separator ;
        dataF += 'Mac_group    = 0 ' + separator ;
        dataF += 'Cad_users = ' + ( dongle.CADTOOL__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Cad_runs = 65535 ' + separator ;
        dataF += 'Nc_users = ' + ( dongle.NCTOOL__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Nc_runs = 65535 ' + separator ;
        dataF += 'Gc_users = ' + ( dongle.GCTOOL__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Gc_runs = 65535 ' + separator ;
        dataF += 'Dnc_users = ' +  ( dongle.DNCTOOL_For_Dos__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Dnc_runs = 65535 ' + separator ;
        dataF += 'Db_users = ' +  ( dongle.DBTOOL__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Db_runs = 65535 ' + separator ;
        dataF += 'Modeler_users= ' + ( dongle.Modeler__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Modeler_runs = 65535 ' + separator ;
        dataF += 'Machin_users = ' + ( dongle.Machinist__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Machin_runs = 65535 ' + separator ;
        dataF += 'BntlyMj_users= ' + ( dongle.Bentley__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'BntlyMj_runs = 65535 ' + separator ;
        dataF += 'Wdnc_users = ' + ( dongle.DNCTOOL_For_Windows__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Wdnc_runs = 65535 ' + separator ;
        dataF += 'Autodsk_users= ' + dongle.Autodesk_Net_Users__c + separator ;
        dataF += 'Autodsk_runs = 65535 ' + separator ;
        dataF += 'Basmdlr_users= ' + ( dongle.BaseModeler__c ? dongle.K_Users__c : '65535') + separator ;
        dataF += 'Basmdlr_runs = 65535 ' + separator ;
        dataF += 'Sdworks_users= ' + dongle.SW_Net_Formula__c + separator ;
        dataF += 'Sdworks_runs = 65535 ' + separator ;
        dataF += 'Inventr_users= ' + dongle.Inventor_Net_Users__c + separator ;
        dataF += 'Inventr_runs = 65535 ' + separator ;
        dataF += 'Pas_users = ' + dongle.Embedded_Users__c + separator ;
        dataF += 'Pas_runs = 65535 ' + separator ;
         
        if(dongle.Network_Profiles_Dongle__c || Test.isRunningTest())
             dataF += GetProfilesData(dongle,separator);
 
        
        
        System.debug(dataF);
        	
        dataF += ';Serial_no = ' + dongle.Serial_No__c + separator ;
        dataF += ';Sticker_no = ' + dongle.Name + separator ;
        dataF += '' + separator ;
        dataF += '' + separator ;
        dataF += '*******************README.OUT******************* ' + separator ;
        dataF += 'Key Data ' + separator ;
        dataF += 'SolidCAM ' + separator ;
        dataF += '' + separator ;
        dataF += 'Key Number: ' + dongle.Name + '' + formatNull(dongle.Net_UP__c) + '' + formatNull(dongle.Evaluation_Key__c) + separator ;
        dataF += '' + formatNull(dongle.EKey_Note__c) + separator ;
        dataF += 'Date Of Order: ' + formatDate(dongle.Date_Of_Order__c) + separator ;
        dataF += 'Reseller: ' + dongle.Reseller__r.Name + separator ;
        
        dataF += 'Sub Reseller: ' + formatNull(dongle.SubReseller__r.Name) + separator ;
        
        dataF += 'End user: ' + dongle.Customer__r.Name + separator ; 
        dataF += '' + separator ;
        dataF += 'SOLIDCAM Release' + dongle.Version_Translate__c + separator ;
        dataF += '' + separator ;
        dataF += 'SolidCAM Milling ' + separator ;
        dataF += '' + separator ;
        dataF += '2.5D MILLING: ' + formatBoolean(dongle.SolidCAM_Mill_2D__c) + separator ;
        dataF += 'REST POCKET MATERIAL : ' + formatBoolean(dongle.Profile_Pocket_2_5D_Rest_Material__c) + separator ;
        dataF += 'Spc 2.5D MILLING: ' + formatBoolean(dongle.SolidCAM_Mill_2_5D__c) + separator ;
        dataF += '3D MILLING : ' + formatBoolean(dongle.SolidCAM_Mill_3D__c) + separator ;
        dataF += 'HSM finish : ' + formatBoolean(dongle.HSM__c) + separator ;
        dataF += 'HSM rough : ' + formatDecimal(dongle.HSR_readme__c) + separator ;
        dataF += 'HSS : ' +  ( ( dongle.X5_axis__c && ! dongle.No_HSS__c ) ? 1 : 0) + separator ;
        dataF += 'Simultaneous 4 Axis(C axis) : ' + formatBoolean(dongle.Simultaneous_4_axes_C_axes__c) + separator ;
        dataF += 'Sim 5 Axis : ' + formatBoolean(dongle.X5_axis__c) + ' ' + formatNull( dongle.Sim_5_Axis_Level_Readme__c ) + separator ;
        dataF += 'Indexial 4 Axis : ' + formatBoolean(dongle.X4_axes_Indexial__c) + separator ;
        dataF += 'Indexial 5 Axis : ' + formatBoolean(dongle.X4_5_axes_indexial__c) + separator ;
        dataF += 'Machine Simulation : ' + formatBoolean(dongle.Machine_Simulation__c) + separator ;
        dataF += 'Hole Recognition : ' + formatBoolean(dongle.Hole_Recognition__c) + separator ;
        dataF += 'Drill Recognition : ' + ( ( dongle.Hole_Recognition__c && ! dongle.Reduced_HolesR__c ) ? 1 : 0) + separator ;
        dataF += 'Pocket Recognition: ' + formatBoolean(dongle.Recoginition_Features__c) + separator ;
        dataF += 'Chamfer Recognition: ' + formatBoolean(dongle.Chamfer_recognition__c) + separator ;
        dataF += 'Stl Support: ' + formatBoolean(dongle.Stl_Support__c) + separator ;
        dataF += 'Sim.5 Axis Drill: ' + formatBoolean(dongle.X5x_Drill__c) + separator ;
        dataF += 'Convert 5x: ' + formatBoolean(dongle.Convert5X__c) + separator ;
        dataF += 'iMachining2D: ' + formatBoolean(dongle.Spiral_Machining__c) + separator ;
        dataF += 'iMachining3D: ' + formatBoolean(dongle.iMachining3D__c) + separator ;
        dataF += 'Probe - measurement: ' + formatBoolean(dongle.Probe__c) + separator ;
        dataF += 'Probe - home definition: ' + ( ( dongle.Probe_Level2__c || dongle.Probe__c ) ? 1 : 0) + separator ;
        dataF += 'Swarf Machining : ' + formatBoolean(dongle.Swarf_machining__c) + separator ;
        dataF += 'MultiBlade 5x: ' + formatBoolean(dongle.MultiBlade5x__c) + separator ;
        dataF += 'Contour 5x : ' + formatBoolean(dongle.Contour_5x__c) + separator ;
        dataF += 'Port 5x : ' + formatBoolean(dongle.Port_5x__c) + separator ;
        dataF += 'Multi-depth Drill: ' + formatBoolean(dongle.Multi_depth_Drill__c) + separator ;
        dataF += 'Screw Machining: '  + formatBoolean(dongle.Screw_Machining__c) + separator ;
        dataF += 'Eureka: '  + formatBoolean(dongle.Eureka__c) + separator ;
         dataF += 'ToolTable only: '  + formatBoolean(dongle.Tooltable_Only__c) + separator ;
        dataF += 'Simulator: '  + formatBoolean(dongle.Simulator__c) + separator ;
        dataF += '5X Breaking: '  + formatBoolean(dongle.X5x_breaking__c) + separator ;
        dataF += '5X Trimming: '  + formatBoolean(dongle.X5x_Edge_Trimming__c) + separator ;
        dataF += 'Cimco: '  + formatBoolean(dongle.Cimco__c) + separator ;
        dataF += 'Vericut: '  + formatBoolean(dongle.Vericut__c) + separator ;
        dataF += 'Zoller: '  + formatBoolean(dongle.Zoller_integration__c) + separator ;
     
       
        
        
        
        dataF += '' + separator ;
        dataF += '' + separator ;
        dataF += '' + separator ;
        dataF += 'SolidCAM Express ' + separator ;
        dataF += '' + separator ;
        dataF += 'Mill 2D : ' + formatBoolean(dongle.Mill_2D_V__c) + separator ;
        dataF += 'HSS : ' + formatBoolean(dongle.HSS_V__c) + separator ;
        
        dataF += 'Xpress plus : ' + formatBoolean(dongle.Xpress_plus__c) + separator ;
        
        dataF += '' + separator ;
        dataF += 'SolidCAM Turning ' + separator ;
        dataF += '' + separator ;
        dataF += 'FULL TURNING : ' + formatBoolean(dongle.SolidCAM_Turning__c) + separator ;
        dataF += 'MILLING AND TURNING : ' + formatNull(dongle.SolidCAM_Turn_Mill_Options__c) + separator ;
        dataF += 'BACK SPINDLE : ' + formatBoolean(dongle.BackSpindle__c) + separator ;
        dataF += 'Sim. Turning: ' + formatBoolean(dongle.Sim_Turning__c) + separator ;
        dataF += 'Multi Turret Sync: ' + formatBoolean(dongle.Multi_Turret_Sync__c) + separator ;
        dataF += 'Swiss-Type: ' + formatBoolean(dongle.Swiss_Type__c) + separator ;
        dataF += '' + separator ;
        dataF += 'SolidCAM WireCut ' + separator ;
        dataF += '' + separator ;
        dataF += 'WIRECUT : ' + formatBoolean(dongle.SolidCAM_WireEDM_2_axes__c) + separator ;
        dataF += 'WIRECUT_4X : ' + formatBoolean(dongle.SolidCAM_WireEDM_2_4_axes__c) + separator ;
        dataF += '' + separator ;
        dataF += 'CADTOOL ' + separator ;
        dataF += '' + separator ;
        dataF += 'CAD 2D: ' + formatBoolean(dongle.X2D_CAD__c) + separator ;
        dataF += 'CAD 3D: ' + formatBoolean(dongle.X3D_CAD__c) + separator ;
        dataF += 'ISO GCODE: ' + formatBoolean(dongle.ISO_GCODE__c) + separator ;
        dataF += 'LT VERSION: ' + formatBoolean(dongle.LT_Version__c) + separator ;
        dataF += '' + separator ;
        dataF += 'NCTOOL: ' + separator ;
        dataF += 'MILLING: ' + formatBoolean(dongle.Milling__c) + separator ;
        dataF += '2D: ' + formatNull(dongle.X2_5D__c) + separator ;
        dataF += '2.5D: ' + dongle.Read_2_5d__c + separator ;
        dataF += '4_AXIS: ' + formatBoolean(dongle.X4_AXIS__c) + separator ;
        dataF += 'TURNING: ' + formatBoolean(dongle.NCTOOL_Turning__c) + separator ;
        dataF += 'MILL + TURN: ' + formatBoolean(dongle.MILL_TURN__c) + separator ;
        dataF += 'WIRECUT: ' + formatNull(dongle.WIRECUT__c) + separator ;
        dataF += '' + separator ;
        dataF += 'DNCTOOL: ' + formatBoolean(dongle.DNCTOOL_For_Dos__c) + separator ;
        dataF += 'PRESETTER: ' + formatBoolean(dongle.PRESETTER__c) + separator ;
        dataF += '' + separator ;
        dataF += 'DBTOOL: ' + formatBoolean(dongle.DBTOOL__c) + separator ;
        dataF += '' + separator ;
        dataF += 'BENTLEY: ' + formatBoolean(dongle.Bentley__c) + separator ;
        dataF += 'EDUCATION FULL: ' + formatBoolean(dongle.Bently_EduFull__c) + separator ;
        dataF += 'OEM POWERMODELER: ' + formatBoolean(dongle.Bently_PowerModeler__c) + separator ;
        dataF += 'ENTRY POWERMODELER: ' + formatBoolean(dongle.Bently_Entry__c) + separator ;
        dataF += 'ENTRY XMT: ' + formatBoolean(dongle.XMT_Converter__c) + separator ;
        dataF += 'ENTRY SAT: ' + formatBoolean(dongle.Sat_Converter__c) + separator ;
        dataF += 'ENTRY STEP: ' +formatBoolean( dongle.Step_Converter__c) + separator ;
        dataF += '' + separator ;
        dataF += 'BASE MODELER: ' + formatBoolean(dongle.BaseModeler__c) + separator ;
        dataF += 'AUTODESK: ' + formatBoolean(dongle.AutoDesk__c) + separator ;
        dataF += 'SOLIDWORKS: ' + formatBoolean(dongle.SolidWorks__c) + separator ;
        dataF += 'INVENTOR: ' + formatBoolean(dongle.Inventor__c) + separator ;
        dataF += '' + separator ;
        dataF += 'Full Embedded: ' + ( dongle.Embedded_CAD__c == 'Full' ? 1 : 0) + separator ;
        dataF += 'Embedded PA: ' + ( dongle.Embedded_CAD__c == 'P/A' ? 1 : 0) + separator ;
        dataF += 'Embedded PO: ' + ( dongle.Embedded_CAD__c == 'P/O' ? 1 : 0) + separator ;
        dataF += '' + separator ;
        dataF += 'Special Options ' + separator ;
        dataF += 'Editor Mode : ' + formatBoolean(dongle.Editor_Mode__c) + separator ;
        dataF += 'No G-Code: ' + formatBoolean(dongle.NO_G_code__c) + separator ;
        dataF += 'GPX : ' + formatBoolean(dongle.GPX__c) + separator ;
        dataF += 'TDM : ' + formatBoolean(dongle.TDM__c) + separator ;
        dataF += 'WinTool: ' + formatBoolean(dongle.WinTool__c) + separator ;
        dataF += 'G-Code Simulation: ' + formatBoolean(dongle.G_Code_Simulation__c) + separator ;
        dataF += 'Education: ' + formatBoolean(dongle.EDU__c) + separator ;
        dataF += 'Iscar tools only: ' + formatBoolean(dongle.ISCAR__c) + separator ;
        dataF += 'Constant Z Only : ' + formatBoolean(dongle.SolidCAM_2_7D_CONSTANT_Z__c) + separator ;
        dataF += 'Reduced 3D(No Milling) : ' + formatBoolean(dongle.SolidCAM_Mill_3D_No_Engraving__c) + separator ;
        dataF += 'Prismatic HSM: ' + formatBoolean(dongle.Prismatic_HSM__c) + separator ;
        dataF += '' + separator ;
        dataF += 'DNCTOOL FOR WINDOWS: ' + formatBoolean(dongle.DNCTOOL_For_Windows__c) + separator ;
        dataF += '' + separator ;
        dataF += 'EXPIRY DATE: ' + formatDate(dongle.Dongle_Expiry_Date__c) + separator ;
        return dataF;
    }
}