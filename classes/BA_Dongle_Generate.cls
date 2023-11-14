global class BA_Dongle_Generate implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts{
	
	global set<String> listIds;
	global boolean m_bInternalUse;
	global boolean m_bVersion;
	global boolean m_bSentinel;
	
	 
	global BA_Dongle_Generate(set<String> ids,boolean internal,boolean ver,boolean soft){
		listIds = ids;
		m_bInternalUse = internal;
		m_bVersion = ver;
		m_bSentinel = soft;
		//bDavid = false;
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(
      				[Select d.sentinel_update_supported__c, d.iMachining_seats__c, d.iMachining_on_profiles__c, d.iMachining_3D_on_profiles__c, d.iMachining3D_seats__c, d.iMachining3D__c, d.a2xisResult__c, d.Zero_Expirey_Date__c, d.ZERO__c, d.Year__c, d.Year_Expirey__c, d.YearExpiryValid__c, d.Xpress__c, d.XMT_Converter__c, d.XCZ_Axes_1st_Error__c, d.X5x_Drill__c, d.X5_axis__c, d.X5XReducedBurb__c, d.X4_axes_Indexial__c, d.X4_AXIS__c, d.X4_5_axes_indexial__c, d.X3D_CAD__c, d.X2_5D__c, d.X2_5DBurn__c, d.X2D_CAD__c, d.WireCut_4_axis_Error__c, d.WireCutBurn__c, d.WinTool__c, d.WinDnctool_Net_Users__c, d.WIRECUT__c, d.Version__c, d.Version_Translate__c, d.VDA_FS__c, d.Updated__c, d.USA_2009__c, d.Turning_Value__c, d.Turn_Mill_Error__c, d.TurnMillType_Burn__c, d.Today_Date__c, d.TV__c, d.TDM__c, d.SystemModstamp, d.Swarf_machining__c, d.Surf3Dburn__c, d.Supply_Status__c, d.Subscription_status__c, d.Sub_reseller_Country__c, d.Sub_Reseller_Mirror__c, d.Sub_Renew__c, d.SubReseller__c, d.Stl_Support__c, d.Step_Converter__c, d.Spiral_Machining__c, d.Special_Config__c, d.Solidworks_Type__c, d.SolidWorks__c, d.SolidCAM_WireEDM_2_axes__c, d.SolidCAM_WireEDM_2_4_axes__c, d.SolidCAM_Turning__c, d.SolidCAM_Turn_Mill_Options__c, d.SolidCAM_TurnMILL__c, d.SolidCAM_Mill_3D__c, d.SolidCAM_Mill_3D_No_Engraving__c, d.SolidCAM_Mill_3D_NO_HSM__c, d.SolidCAM_Mill_2_5D__c, d.SolidCAM_Mill_2D__c, d.SolidCAM_3D_HSM__c, d.SolidCAM_2_7D_CONSTANT_Z__c, d.Smm_Users_Error2__c, d.Slash__c, d.Simultaneous_4_axes_C_axes__c, d.Simultaneous5axesReduced__c, d.Sim_Turning__c, d.Sim_5_Axis_Level_Readme__c, d.Sim_5_Axes_Error__c, d.Serial_No__c, d.Sentinel__c, d.Sentinel_ID__c, d.Selected_Product__c, d.Sat_Converter__c, d.SalesSubReseller__c, d.SaleReseller__c, d.SaleOrderNumber__c, d.SaleCustomer__c, d.SW_Net_Formula__c, d.SURF_3D__c, d.SURFACES__c, d.SOLIDS__c, d.SMM__c, d.SMM_Users__c, d.SMM_Users_Formula__c, d.SMM_Users_Error__c, d.Reseller__c, d.Reseller_Text_Mirror__c, d.Reseller_Mirror__c, d.Reseller_Error__c, d.Reseller_Country__c, d.Release__c, d.Reduced_HolesR__c, d.Recoginition_Features__c, d.Read_2_5d__c, d.Quantity__c, d.Profile__c, d.Profile_Pocket_2_5D_Rest_Material__c, d.Products__c, d.Product_key__c, d.Probe_on_profiles__c, d.Probe__c, d.Probe_No__c, d.Probe_Level_2_Seats__c, d.Probe_Level2__c, d.Prismatic_HSM__c, d.Potential_Users__c, d.PRESETTER__c, d.OwnerId, d.Overide_CAD_Users__c, d.Orders__c, d.Order__c, d.Order_No_SalesForce__c, d.Order_No_Magic__c, d.Only_DncTool__c, d.On_Maintenance__c, d.Number_of_seats__c, d.Number_of_activations__c, d.No_Net_Error__c, d.No_HSS__c, d.No_Expire_Date__c, d.No_Cad_Intergration_With_CadTool__c, d.No_Cad_Intergration_With_Bently__c, d.No_Cad_Integration__c, d.No_CAD_Integration_with_Base_Modeler__c, d.NoExpireDate2__c, d.New_Maintenance_Type__c, d.New_Maintenance_Start_Date__c, d.New_Maintenance_End_Date__c, d.New_Cad_Intergration__c, d.Network_Profiles_Dongle__c, d.Net_Users_Error__c, d.Net_UP__c, d.Net_Profiles_Error__c, d.Net_Error0__c, d.Net_Dongle__c, d.NcTool_Net_Users__c, d.Name, d.NO_G_code__c, d.NCTOOL__c, d.NCTOOL_Turning__c, d.Multi_Turret_Sync__c, d.Month__c, d.Month_Expirey_Date__c, d.Modeler__c, d.Milling__c, d.Mill_2D_V__c, d.Maintenace_Start_Date__c, d.Maintenace_End_Date__c, d.Maintance__c, d.Maintance_Validity__c, d.Maintance_Type__c, d.Machinist__c, d.Machine_Simulation__c, d.Mac_Group__c, d.MILL_TURN__c, d.Logo__c, d.LogoError__c, d.LogoBurn__c, d.Last_Dongle_Record__c, d.LastModifiedDate, d.LastModifiedById, d.LastM__c, d.LastActivityDate, d.LT_Version__c, d.LOGO3__c, d.K_Users__c, d.Is_Relevant__c, d.IsRelevant_Expiry__c,d.IsDeleted, d.Inventor__c, d.Inventor_Net_Users__c, d.Internal_Use__c, d.Id, d.ISO_GCODE__c, d.ISCAR__c, d.IGES__c, d.Hole_Recognition__c, d.HSS__c, d.HSS_V__c, d.HSS_Rough__c, d.HSR_readme__c, d.HSM__c, d.HSM_V__c, d.GenerateHeadline__c, d.Gctool_Net_Users__c, d.G_Code_Simulation__c, d.GPX__c, d.GCTOOL__c, d.GCTOOL_Group__c, d.Furture__c, d.Features__c, d.Evaluation__c, d.Evaluation_Module__c, d.Evaluation_Key__c, d.Embedded_Users__c, d.Embedded_CAD__c, d.Educational_System_NCTOOL__c, d.Education_System_SolidCAM__c, d.Editor_Mode__c, d.EKey_Note__c, d.EDU__c, d.Dongle_Validation__c, d.Dongle_Validate__c, d.Dongle_Type__c, d.Dongle_Limits__c, d.Dongle_Index__c, d.Dongle_Expiry_Date__c, d.Dbtool_Net_Users__c, d.Day_Expirey__c, d.DayTranslate__c, d.Date_Of_Order__c, d.Date_Error__c, d.Date_Error_Translate__c, d.DateOfOrderError__c, d.DXF__c, d.DNCTool_Net_Users__c, d.DNCTOOL_For_Windows__c, d.DNCTOOL_For_Dos__c, d.DBTOOL__c, d.DAY__c, d.Customer_s_Country__c, d.Customer_mirror__c, d.Customer__c, d.CurrencyIsoCode, d.CreatedDate, d.CreatedById, d.Convert5X__c, d.Contact__c, d.ConnectionSentId, d.ConnectionReceivedId, d.Comments__c, d.CheckExpireDate__c, d.Calculate_Sub__c, d.Cadtool_Net_Users__c, d.CadToolIgesOut__c, d.CadToolIgesIn__c, d.CAD_Users__c, d.CAD_Type__c, d.CADTOOL__c, d.CADTOOL_NCTOOL_G_code__c, d.CADTOOL_IGES__c, d.Beta_Site__c, d.Bently_PowerModeler__c, d.Bently_Net_Users__c, d.Bently_Entry__c, d.Bently_EduFull__c, d.Bentley__c, d.Bentley_3D_Mill__c, d.Belongs_to_Inactive_Customer__c, d.Basemodeler_Net_Users__c, d.Base_Modeler_3D_Mill__c, d.BaseModeler__c, d.BackSpindle__c, d.Autodesk_Net_Users__c, d.Auto_Number_Int__c, d.AutoDesk__c, d.Actual_Users__c, d.Active_Key__c, 
					d.MultiBlade5x__c, Dongle__c.Multi_depth_Drill__c, d.Chamfer_recognition__c, d.Contour_5x__c, d.Port_5x__c, d.Xpress_plus__c, 
					d.Reseller__r.Name , d.Swiss_Type__c,d.Order__r.Id,d.Customer__r.Name , d.SubReseller__r.Name,Zoller_integration__c,Multi_Axis_Roughing__c,Screw_Machining__c,Eureka_Simulator__c,Eureka_Machine_Editor__c,Eureka_Playlist__c,Eureka_Probe__c,Eureka_Cutting_Conditions__c,Eureka_Viewer__c,
					Cimco__c,Auto_3_2_Roughing__c,Cimco_Add_On__c,HSM_Basic__c,Simulator__c,Vericut__c,Eureka__c,X5x_breaking__c	,X5x_Edge_Trimming__c,Tooltable_Only__c,Editor_Mode_Light__c
					From Dongle__c d
					where Name in :listIds
					]);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
		List<Dongle__c> listToUpdate = new List<Dongle__c>();
		for(sObject s : scope){
			Dongle_Generate d = new Dongle_Generate();
			d.dongle = (Dongle__c)s;

			if(m_bInternalUse)
			{
				Dongle__c record = (Dongle__c)s;
				record.Date_Of_Order__c = date.today();
				record.Dongle_Expiry_Date__c = date.newInstance(2024, 12, 31);
				record.Version__c = record.Sentinel__c ? '260' : '251';
				listToUpdate.Add(record);
			}
			else if(m_bVersion)
			{
				Dongle__c record = (Dongle__c)s;
				record.Date_Of_Order__c = date.today();
				record.Version__c = record.Sentinel__c ? '260' : '251';
				listToUpdate.Add(record);
			}
			else
			{
				if(!d.dongle.Sentinel__c)
					d.GenerateDongle();
				else
				{
					GeneratePK g = new GeneratePK();
					g.GeneratePK(d.dongle.Id,false,false);
				
				}
			}

			if(m_bInternalUse || m_bVersion)
			if(!Test.isRunningTest())
				update listToUpdate;
		}
		
		
		
   }

   global void finish(Database.BatchableContext BC){

   }
}