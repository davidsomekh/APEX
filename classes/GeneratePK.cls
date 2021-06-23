global without sharing class GeneratePK {
	
	public transient Attachment m_attachment {get;set;}
	public Dongle__c m_License {get;set;}
	public String m_name {get;set;}
	public boolean m_finished {get;set;}
	public String m_error {get;set;}
	public Integer m_status_code {get;set;}
	public boolean m_version_mode {get;set;}
	public boolean m_disable_license {get;set;}
	public boolean m_attachment_download {get;set;}
	
	public List<Profiles__c> m_Profiles {get;set;}
	
	public GeneratePK ()
	{
        m_version_mode = false;
        m_attachment_download = false;
        m_attachment = null;
        m_disable_license = false;
   
    } 
	
	public GeneratePK (Apexpages.Standardcontroller ctrl){
        m_License = (Dongle__c)ctrl.getRecord();
        m_Profiles = null;
        m_version_mode = false;
        m_attachment_download = false;
        m_attachment = null;
        m_disable_license = false;
   
    } 
    
    public void GetProfiles(Dongle__c d)
    {
    	m_Profiles = [Select Profile_No__c,Chamfer_recognition__c,Contour_5x__c,SolidCAM_Mill_2D__c,SolidCAM_Mill_2_5D__c,X4_5_axes_indexial__c	,X4_axes_Indexial__c,X5x_Drill__c,
		AUTODESK__c,Back_Spindle__c,	Profile_Users__c,Convert5x__c	,G_Code_Simulation__c,Holes_Recognition__c,HSM__c,HSS_Rough__c,HSS_V__c,Spiral_Machining__c,
		iMachining3D__c,INVENTOR__c,Machine_Simulation__c,Mill_2D_V__c,Multi_Axis_Roughing__c,MultiBlade_5x__c,No_HSS__c,Recognition_Features__c,Port_5x__c,Prismatic_HSM__c,
		Probe__c,Probe_Level2__c,Reduced_HolesR__c,Screw_Machining__c,Sim_Turning__c,X5_axis__c,Simultaneous_5_axes_Reduced__c,Simultaneous_4_axes_C_axes__c,SolidCAM_Mill3D__c,
		SolidCAM_Mill_3D_No_Engraving__c,SolidCAM_Turning__c,SolidCAM_WireEDM_2_axes__c,SolidCAM_WireEDM_2_4_axes__c,SOLIDWORKS__c,STL_Support__c,Swarf_machining__c,TDM__c,
		WinTool__c,XpressPlus__c,Zoller_integration__c,Multi_Turret_Sync__c,SolidCAM_2_7D_CONSTANT_Z__c,Profile__c,BaseModeler__c,Bently__c,Editor_Mode__c,Multi_depth_Drill__c,Swiss_Type__c,Eureka_Simulator__c,Eureka_Machine_Editor__c,Eureka_Playlist__c,Eureka_Probe__c,Eureka_Cutting_Conditions__c,Eureka_Viewer__c,
		Cimco__c,Vericut__c,Eureka__c,X5x_Edge_Breaking__c,X5x_Edge_Trimming__c,Tooltable_Only__c,HSM_Basic__c,Cimco_Add_On__c,Simulator__c
		
		From Profiles__c Where DongleNo__c =: d.Id];
    }
    
    public boolean CheckProfilesError(Dongle__c d)
	{
		Integer  USERS = 0;
		boolean Editor = false;
		boolean BaseModeler = false;
		boolean Bently = false;
		for (Profiles__c p : m_Profiles) {
			if(p.Editor_Mode__c)
				Editor = true;
			if(p.BaseModeler__c)
				BaseModeler = true;
			if(p.Bently__c)
				Bently = true;
				
		 	USERS = USERS += p.Profile_Users__c.intValue();
		}
		
		if(d.Network_Profiles_Dongle__c && m_Profiles.isEmpty())
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This license does not have linked profiles. Please disable "Net Profiles" checkbox.'));
			return false;
		}
			
		if(!d.Network_Profiles_Dongle__c && !m_Profiles.isEmpty())
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This license has linked profiles. Please enable "Net Profiles" checkbox.'));
			return false;
		}
		
		if(d.Network_Profiles_Dongle__c && !d.Net_Dongle__c)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This license has profiles. Please enable "Net Dongle" checkbox.'));
			return false;
		}
		
		if(d.Network_Profiles_Dongle__c && (USERS > d.Actual_Users__c))
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Overall users in profiles is GREATER than license users.'));
			return false;
		}
		
		if(d.Network_Profiles_Dongle__c && (USERS < d.Actual_Users__c))
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Overall users in profiles is LESS than license users.'));
			return false;
		}
		
		if(d.Network_Profiles_Dongle__c && d.Evaluation__c)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Evaluation licenses will all options cannot have profiles.'));
			return false;
		}
		
		/*if(d.Network_Profiles_Dongle__c && Editor)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Editor is not supported with profiles on soft license.'));
			return false;
		}*/
		
		if(d.Network_Profiles_Dongle__c && Bently)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Bently is not supported with profiles on soft license.'));
			return false;
		}
		
		if(d.Network_Profiles_Dongle__c && BaseModeler)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Base modeler is not supported with profiles on soft license.'));
			return false;
		}
			
			
		return true;
			
		
	}
    
    
    public JSONGenerator GetProfileNumbers(Dongle__c d, JSONGenerator J,boolean Test)
	{
	
		if(!Test && (m_Profiles.isEmpty() || !d.Network_Profiles_Dongle__c))
			return J;
			
	
		J.writeBooleanField('AutoCAD',false);
		J.writeBooleanField('SolidWorks',false);
		J.writeBooleanField('Inventor',false);
		J.writeBooleanField('Mill2D',false);
		J.writeBooleanField('Mill2D_ADV',false);
		J.writeBooleanField('Mill3D',false);
		J.writeBooleanField('PR',false);
		J.writeBooleanField('CR',false);
		J.writeBooleanField('HR',false);
		J.writeBooleanField('DR',false);
		J.writeBooleanField('STL',false);
		J.writeBooleanField('HSR',false);
		J.writeBooleanField('Prismatic',false);
		J.writeBooleanField('HSM',false);
		J.writeBooleanField('iMachining',false);
		J.writeBooleanField('iMachining3D',false);
		J.writeBooleanField('Turning',false);
		J.writeBooleanField('Backspindle',false);
		J.writeBooleanField('Simturn',false);
		J.writeBooleanField('MultiTurret',false);
		J.writeBooleanField('WRAP',false);
		J.writeBooleanField('Index4X',false);
		J.writeBooleanField('Index5X',false);
		J.writeBooleanField('SIM5X',false);
		J.writeBooleanField('SIM4X',false);
		J.writeBooleanField('HSS',false);
		J.writeBooleanField('MSIM',false);
		J.writeBooleanField('Swarf',false);
		J.writeBooleanField('Contour5X',false);
		J.writeBooleanField('Drill5X',false);
		J.writeBooleanField('Convert5X',false);
		J.writeBooleanField('Reduced3D',false);
		J.writeBooleanField('XPLUS',false);
		J.writeBooleanField('MultiBlade',false);
		J.writeBooleanField('Port',false);
		J.writeBooleanField('Xpress2D',false);
		J.writeBooleanField('XpressHSS',false);
		J.writeBooleanField('Wire2X',false);
		J.writeBooleanField('Wire4X',false);
		J.writeBooleanField('Probe',false);
		J.writeBooleanField('ExternalNC',false);
		J.writeBooleanField('TDM',false);
		J.writeBooleanField('WINTOOL',false);
		J.writeBooleanField('ProbeHome',false);
		J.writeBooleanField('CONSTANTZ',false);
		J.writeBooleanField('Zoller',false);
		J.writeBooleanField('Rough5X',false);
		J.writeBooleanField('Screw',false);
		J.writeBooleanField('ProfileOnly',false);
		J.writeBooleanField('Swiss',false);
		J.writeBooleanField('Mdepth',false);
		J.writeBooleanField('EurekaCut',false);
		J.writeBooleanField('EurekaEdit',false);
		J.writeBooleanField('EurekaPlay',false);
		J.writeBooleanField('EurekaProbe',false);
		J.writeBooleanField('EurekaView',false);
		J.writeBooleanField('Eureka3X',false);
		J.writeBooleanField('EurekaMAMC',false);
		J.writeBooleanField('EurekaMA1C',false);
		
		J.writeBooleanField('Simulator',false);
		J.writeBooleanField('5xBreaking',false);
		J.writeBooleanField('5xTrimming',false);
		J.writeBooleanField('Eureka',false);
		J.writeBooleanField('Vericut',false);
		J.writeBooleanField('Cimco',false);
		J.writeBooleanField('CimcoAddOn',false);
		J.writeBooleanField('HSMbasic',false);
		J.writeBooleanField('Tooltable',false);
	
	
			
			
	
			
		Integer  USERS2D = 0;
		Integer  USERS2DADV = 0;
		Integer  UsersChamfer = 0;
		Integer  UsersCountour = 0;
		Integer  UsersIndexial5 = 0;
		Integer  UsersIndexial4 = 0;
		Integer  UsersDrill5x = 0;
		Integer  UsersAutodesk = 0;
		Integer  UsersBS = 0;
		Integer  UsersConvert = 0;
		Integer  UsersGCodeSim = 0;
		Integer  UsersHR = 0;
		Integer  UsersHSM = 0;
		Integer  UsersHSR = 0;
		Integer  UsersHSS = 0;
		Integer  UsersHSSXpress = 0;
		Integer  UsersIM = 0;
		Integer  UsersIM3D = 0;
		Integer  UsersInventor = 0;
		Integer  UsersMachineSimulation = 0;
		Integer  UsersMill2DXpress = 0;
		Integer  UsersMultiAxisRoughing = 0;
		Integer  UsersMultiblade = 0;
		Integer  UsersPR = 0;
		Integer  UsersPort = 0;
		Integer  UsersPrismatic = 0;
		Integer  UsersProbe = 0;
		Integer  UsersProbeHome = 0;
		Integer  UsersScrew = 0;
		Integer  UsersSimTurn = 0;
		Integer  Users5X = 0;
		Integer  UsersCWRAP = 0;
		Integer  UsersMill3D = 0;
		Integer  UsersMill3DReduced = 0;
		Integer  UsersTurning = 0;
		Integer  UsersWireEDM = 0;
		Integer  UsersWireEDM4X = 0;
		Integer  UsersSolidWorks = 0;
		Integer  UsersSTL = 0;
		Integer  UsersSwarf = 0;
		Integer  UsersTDM = 0;
		Integer  UsersWintool = 0;
		Integer  UsersXpressPlus = 0;
		Integer  UsersZoller = 0;
		Integer  Users4X = 0;
		Integer  UsersDR = 0;
		Integer  UsersMultiTurret = 0;
		Integer  UsersConstantZ = 0;
		Integer  UsersProfileOnly = 0;
		Integer  UsersSwiss = 0;
		Integer  UsersMdepth = 0;
		Integer  UsersEurekaCut = 0;
		Integer  UsersEurekaEdit = 0;
		Integer  UsersEurekaPlay = 0;
		Integer  UsersEurekaProbe = 0;
		Integer  UsersEurekaView = 0;
		Integer  UsersEureka3X = 0;
		Integer  UsersEurekaMAMC = 0;
		Integer  UsersEurekaMA1C = 0;

		Integer  UsersBreaking = 0;
		Integer  UsersTrimming = 0;
		Integer  UsersEureka = 0;
		Integer  UsersVericut = 0;
		Integer  UsersCimco = 0;

		Integer UsersCimcoAddOn = 0;
		Integer UsersHSMbasic = 0;
		Integer UsersEditor = 0;
		Integer UsersSimulator = 0;

	

		
		
		
		for (Profiles__c p : m_Profiles) {
		   	if(p.SolidCAM_Mill_2D__c)
		   	{
	    		USERS2D = USERS2D += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Mill2D',true);
		   	}
	    	if(p.SolidCAM_Mill_2_5D__c)
	    	{
	    		USERS2DADV = USERS2DADV += p.Profile_Users__c.intValue();
	  			J.writeBooleanField('Mill2D_ADV',true);
	
	    	}
	    	if(p.Chamfer_recognition__c)
	    	{
	    		UsersChamfer = UsersChamfer += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('CR',true);
	    	}
	    	if(p.Contour_5x__c)
	    	{
	    		UsersCountour = UsersCountour += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Contour5X',true);
	    	}
	    	if(p.X4_5_axes_indexial__c)
	    	{
	    		UsersIndexial5 = UsersIndexial5 += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Index5X',true);
	    	}
	    	if(p.X4_axes_Indexial__c)
			{
	    		UsersIndexial4 = UsersIndexial4 += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Index4X',true);
			}
	    	if(p.X5x_Drill__c)
	    	{
	    		UsersDrill5x = UsersDrill5x += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Drill5X',true);
	    	}
	    	if(p.AUTODESK__c)
	    	{
	    		UsersAutodesk = UsersAutodesk += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('AutoCAD',true);
	    	}
	    	if(p.Back_Spindle__c)
	    	{
	    		UsersBS = UsersBS += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Backspindle',true);
	    	}
	    	if(p.Convert5x__c)
	    	{
	    		UsersConvert = UsersConvert += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Convert5X',true);
	    	}
	    	if(p.G_Code_Simulation__c)
	    	{
	    		UsersGcodeSim = UsersGcodeSim += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('ExternalNC',true);
	    	}
	    	if(p.Holes_Recognition__c)
	    	{
	    		UsersHR = UsersHR += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('HR',true);
	    	}
	    	if(p.HSM__c)
	    	{
	          	UsersHSM = UsersHSM += p.Profile_Users__c.intValue();
	          	J.writeBooleanField('HSM',true);
	    	}
	    	if(p.HSS_Rough__c)
	    	{
	    		UsersHSR = UsersHSR += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('HSR',true);
	    	}
	    	
	    	if(p.X5_axis__c && !p.No_HSS__c)
	    	{
	    		UsersHSS = UsersHSS += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('HSS',true);
	    	}
	       
	    	if(p.HSS_V__c)
	    	{
	    		UsersHSSXpress = UsersHSSXpress += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('XpressHSS',true);
	    	}
	    	if(p.Spiral_Machining__c)
	    	{
	    		UsersIM = UsersIM += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('iMachining',true);
	    	}
	    	if(p.iMachining3D__c)
	    	{
	    		UsersIM3D = UsersIM3D += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('iMachining3D',true);
	    	}
	    	if(p.INVENTOR__c)
			{
	    		UsersInventor = UsersInventor += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Inventor',true);
			}
	    	if(p.Machine_Simulation__c)
			{
	    		UsersMachineSimulation = UsersMachineSimulation += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('MSIM',true);
			}
	    	if(p.Mill_2D_V__c)
	    	{
	    		UsersMill2DXpress = UsersMill2DXpress += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Xpress2D',true);
	    	}
	    	if(p.Multi_Axis_Roughing__c)
	    	{
	    		UsersMultiAxisRoughing = UsersMultiAxisRoughing += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Rough5X',true);
	    	}
	    	if(p.MultiBlade_5x__c)
	    	{
	    		UsersMultiblade = UsersMultiblade += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('MultiBlade',true);
	    	}
	    	if(p.Recognition_Features__c)
	    	{
	    		UsersPR = UsersPR += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('PR',true);
	    	}
	    	if(p.Port_5x__c)
			{
	    		UsersPort = UsersPort += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Port',true);
			}
	    	if(p.Prismatic_HSM__c)
			{
	    		UsersPrismatic = UsersPrismatic += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Prismatic',true);
			}
		   	if(p.Probe__c)
		   	{
	    		UsersProbe = UsersProbe += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Probe',true);
		   	}
	    	if(p.Probe_Level2__c)
			{
	    		UsersProbeHome = UsersProbeHome += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('ProbeHome',true);
			}
	    	if(p.Screw_Machining__c)
	    	{
	    		UsersScrew = UsersScrew += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Screw',true);
	    	}
	    	if(p.Sim_Turning__c)
	    	{
	    		UsersSimTurn = UsersSimTurn += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Simturn',true);
	    	}
	    	if(p.X5_axis__c && String.isEmpty(p.Simultaneous_5_axes_Reduced__c))
	    	{
	    		Users5X = Users5X += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('SIM5X',true);
	    	}
	    	if(p.Simultaneous_4_axes_C_axes__c)
	    	{
	    		UsersCWRAP = UsersCWRAP += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('WRAP',true);
	    	}
	    
	    	if(p.SolidCAM_Mill3D__c)
			{
	    		UsersMill3D = UsersMill3D += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Mill3D',true);
			}
	    	if(p.SolidCAM_Mill_3D_No_Engraving__c)
	    	{
	    		UsersMill3DReduced = UsersMill3DReduced += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Reduced3D',true);
	    	}
	    	if(p.SolidCAM_Turning__c)
	    	{
	    		UsersTurning = UsersTurning += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Turning',true);
	    	}
	    	if(p.SolidCAM_WireEDM_2_axes__c)
			{
	    		UsersWireEDM = UsersWireEDM += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Wire2X',true);
			}
	    	if(p.SolidCAM_WireEDM_2_4_axes__c)
	    	{
	    		UsersWireEDM4X = UsersWireEDM4X += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Wire4X',true);
	    	}
	    	if(p.SOLIDWORKS__c)
			{
	    		UsersSolidWorks = UsersSolidWorks += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('SolidWorks',true);
			}
    	   	if(p.STL_Support__c)
    	   	{
	    		UsersSTL = UsersSTL += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('STL',true);
    	   	}
	    	if(p.Swarf_machining__c)
	    	{
	    		UsersSwarf = UsersSwarf += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Swarf',true);
	    	}
	    	if(p.TDM__c)
			{
	    		UsersTDM = UsersTDM += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('TDM',true);
			}
	    	if(p.WinTool__c)
			{
	    		UsersWintool = UsersWintool += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('WINTOOL',true);
			}
	    	if(p.XpressPlus__c)
	    	{
	    		UsersXpressPlus = UsersXpressPlus += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('XPLUS',true);
	    	}
	    	if(p.Zoller_integration__c)
	    	{
	    		UsersZoller = UsersZoller += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Zoller',true);
	    	}
	    	if(p.Multi_Turret_Sync__c)
	    	{
	    		UsersMultiTurret = UsersMultiTurret += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('MultiTurret',true);
	    	}
	    	if(p.SolidCAM_2_7D_CONSTANT_Z__c)
			{
	    		UsersConstantZ = UsersConstantZ += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('CONSTANTZ',true);
			}
	    	if(p.X5_axis__c && p.Simultaneous_5_axes_Reduced__c =='3/4-axis')
	    	{
	    		Users4X = Users4X += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('SIM4X',true);
	    	}
	    	if(p.Holes_Recognition__c && !p.Reduced_HolesR__c)
	    	{
	    		UsersDR = UsersDR += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('DR',true);
	    	}
	    	
	    	if(p.Profile__c)
	    	{
	    		UsersProfileOnly = UsersProfileOnly += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('ProfileOnly',true);
	    	}
	    	
	    	if(p.Swiss_Type__c)
	    	{
	    		UsersSwiss = UsersSwiss += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Swiss',true);
	    	}
	    	if(p.Multi_depth_Drill__c)
	    	{
	    		UsersMdepth = UsersMdepth += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Mdepth',true);
			}
		
			if(p.Eureka_Machine_Editor__c)
	    	{
				UsersEurekaEdit = UsersEurekaEdit += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('EurekaEdit',true);
			}
			
			if(p.Eureka_Playlist__c)
	    	{
	    		UsersEurekaPlay = UsersEurekaPlay += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('EurekaPlay',true);
			}
			
			if(p.Eureka_Probe__c)
	    	{
	    		UsersEurekaProbe = UsersEurekaProbe += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('EurekaProbe',true);
			}
			
			if(p.Eureka_Cutting_Conditions__c)
	    	{
	    		UsersEurekaCut = UsersEurekaCut += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('EurekaCut',true);
			}
			
			if(p.Eureka_Viewer__c)
	    	{
	    		UsersEurekaView = UsersEurekaView += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('EurekaView',true);
			}
						
			if(GetEureka3XProfile(p))
	    	{
	    		UsersEureka3X = UsersEureka3X += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Eureka3X',true);
			}
			
			if(GetEurekaMA1CProfile(p))
	    	{
	    		UsersEurekaMA1C = UsersEurekaMA1C += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('EurekaMA1C',true);
			}
			
			if(GetEurekaMAMCProfile(p))
	    	{
	    		UsersEurekaMAMC = UsersEurekaMAMC += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('EurekaMAMC',true);
			}
			
			if(p.X5x_Edge_Breaking__c)
	    	{
	    		UsersBreaking = UsersBreaking += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Breaking',true);
			}
			
			if(p.X5x_Edge_Trimming__c)
	    	{
	    		UsersTrimming = UsersTrimming += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Trimming',true);
			}
			
			if(p.Eureka__c)
	    	{
	    		UsersEureka = UsersEureka += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Eureka',true);
			}

			if(p.Vericut__c)
	    	{
	    		UsersVericut = UsersVericut += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Vericut',true);
			}
			
			if(p.Cimco__c)
	    	{
	    		UsersCimco = UsersCimco += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Cimco',true);
			}

			if(p.Cimco_Add_On__c)
	    	{
	    		UsersCimcoAddOn = UsersCimcoAddOn += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('CimcoAddOn',true);
			}

			if(p.HSM_Basic__c)
	    	{
	    		UsersHSMbasic = UsersHSMbasic += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('HSMbasic',true);
			}

			if(p.Editor_Mode__c)
	    	{
	    		UsersEditor = UsersEditor += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Editor',true);
			}

			if(p.Simulator__c)
	    	{
	    		UsersSimulator = UsersSimulator += p.Profile_Users__c.intValue();
	    		J.writeBooleanField('Simulator',true);
			}
		
	    	
	    	

		}
	
		J.WriteNumberField('Profile2',UsersSolidWorks);
		J.WriteNumberField('Profile3',UsersAutodesk);
		J.WriteNumberField('Profile4',UsersInventor);
		J.WriteNumberField('Profile5',USERS2D);
		J.WriteNumberField('Profile6',USERS2DADV);
		J.WriteNumberField('Profile7',UsersPR);
		J.WriteNumberField('Profile8',UsersHR);
		J.WriteNumberField('Profile9',UsersMill3D);
		J.WriteNumberField('Profile10',UsersHSM);
		J.WriteNumberField('Profile11',UsersHSR);
		J.WriteNumberField('Profile12',UsersIM);
		J.WriteNumberField('Profile13',UsersIM3D);
		J.WriteNumberField('Profile14',UsersTurning);
		J.WriteNumberField('Profile15',UsersHSS);
		J.WriteNumberField('Profile16',Users4X);
		J.WriteNumberField('Profile17',Users5X);
		J.WriteNumberField('Profile18',UsersMachineSimulation);
		J.WriteNumberField('Profile19',UsersDrill5x);
		J.WriteNumberField('Profile20',UsersConvert);
		J.WriteNumberField('Profile21',UsersWireEDM);
		J.WriteNumberField('Profile22',UsersWireEDM4X);
		J.WriteNumberField('Profile23',UsersSTL);
		J.WriteNumberField('Profile26',UsersMill2DXpress);
		J.WriteNumberField('Profile27',UsersHSSXpress);
		J.WriteNumberField('Profile28',UsersDR);
		J.WriteNumberField('Profile29',UsersProbe);
		J.WriteNumberField('Profile30',UsersGCodeSim);
		J.WriteNumberField('Profile31',UsersTDM);
		J.WriteNumberField('Profile32',UsersWintool);
		J.WriteNumberField('Profile37',UsersProfileOnly);
		J.WriteNumberField('Profile38',UsersEditor);
		J.WriteNumberField('Profile39',UsersMultiTurret);
		J.WriteNumberField('Profile41',UsersSimTurn);
		J.WriteNumberField('Profile42',UsersProbeHome);
		J.WriteNumberField('Profile43',UsersMill3DReduced);
		J.WriteNumberField('Profile44',UsersPrismatic);
		J.WriteNumberField('Profile45',UsersSwarf);
		J.WriteNumberField('Profile46',UsersIndexial4);
		J.WriteNumberField('Profile47',UsersIndexial5);
		J.WriteNumberField('Profile48',UsersCWRAP);
		J.WriteNumberField('Profile49',UsersBS);
		J.WriteNumberField('Profile50',UsersConstantZ);
		J.WriteNumberField('Profile60',UsersMultiblade);
		J.WriteNumberField('Profile61',UsersPort);
		J.WriteNumberField('Profile62',UsersCountour);
		J.WriteNumberField('Profile63',UsersXpressPlus);
		J.WriteNumberField('Profile64',UsersChamfer);
		J.WriteNumberField('Profile65',UsersZoller);
		J.WriteNumberField('Profile66',UsersScrew);
		J.WriteNumberField('Profile67',UsersMultiAxisRoughing);
		J.WriteNumberField('Profile68',UsersSwiss);
		J.WriteNumberField('Profile69',UsersMdepth);

		J.WriteNumberField('Profile71',UsersEureka3X);
		J.WriteNumberField('Profile72',UsersEurekaMA1C);
		J.WriteNumberField('Profile73',UsersEurekaMAMC);
		J.WriteNumberField('Profile74',UsersEurekaProbe);
		J.WriteNumberField('Profile75',UsersEurekaEdit);
		J.WriteNumberField('Profile76',UsersEurekaView);
		J.WriteNumberField('Profile77',UsersEurekaPlay);
		J.WriteNumberField('Profile78',UsersEurekaCut);
		J.WriteNumberField('Profile80',UsersSimulator);
		J.WriteNumberField('Profile81',UsersBreaking);
		J.WriteNumberField('Profile82',UsersTrimming);
		J.WriteNumberField('Profile83',UsersEureka);
		J.WriteNumberField('Profile84',UsersVericut);
		J.WriteNumberField('Profile85',UsersCimco);
		J.WriteNumberField('Profile86',UsersHSMbasic);
		J.WriteNumberField('Profile87',UsersCimcoAddOn);
	
		return J;
	
	} 
	
	
	public JSONGenerator AddFeatures(Dongle__c d, JSONGenerator J,boolean Test)
	{
			GetProfiles(d);
			if(!Test && !CheckProfilesError(d))
			{
				J.close();
				return J;
			}
			
			if(d.Network_Profiles_Dongle__c || Test)
				J = GetProfileNumbers(d,J,Test);
				
			if(!d.Network_Profiles_Dongle__c || Test)
			{
				J.writeBooleanField('AutoCAD',d.AutoDesk__c);
				J.writeBooleanField('SolidWorks',d.SolidWorks__c);
				J.writeBooleanField('Inventor',d.Inventor__c);
				J.writeBooleanField('Mill2D',d.SolidCAM_Mill_2D__c);
				J.writeBooleanField('Mill2D_ADV',d.SolidCAM_Mill_2_5D__c);
				J.writeBooleanField('Mill3D',d.SolidCAM_Mill_3D__c);
				J.writeBooleanField('PR',d.Recoginition_Features__c);
				J.writeBooleanField('CR',d.Chamfer_recognition__c);
				J.writeBooleanField('HR',d.Hole_Recognition__c);
				J.writeBooleanField('DR',d.Hole_Recognition__c && !d.Reduced_HolesR__c);
				J.writeBooleanField('STL',d.Stl_Support__c);
				J.writeBooleanField('HSR',d.HSS_Rough__c);
				J.writeBooleanField('Prismatic',d.Prismatic_HSM__c);
				J.writeBooleanField('HSM',d.HSM__c);
				J.writeBooleanField('iMachining',d.Spiral_Machining__c);
				J.writeBooleanField('iMachining3D',d.iMachining3D__c);
				J.writeBooleanField('Turning',d.SolidCAM_Turning__c);
				J.writeBooleanField('Backspindle',d.BackSpindle__c);
				J.writeBooleanField('Simturn',d.Sim_Turning__c);
				J.writeBooleanField('MultiTurret',d.Multi_Turret_Sync__c);
				J.writeBooleanField('WRAP',d.Simultaneous_4_axes_C_axes__c);
				J.writeBooleanField('Index4X',d.X4_axes_Indexial__c);
				J.writeBooleanField('Index5X',d.X4_5_axes_indexial__c);
				J.writeBooleanField('SIM5X',d.X5_axis__c && String.isEmpty(d.Simultaneous5axesReduced__c));
				J.writeBooleanField('SIM4X',d.X5_axis__c && d.Simultaneous5axesReduced__c =='3/4 axis');
				J.writeBooleanField('HSS',d.X5_axis__c && !d.No_HSS__c);
				J.writeBooleanField('MSIM',d.Machine_Simulation__c);
				J.writeBooleanField('Swarf',d.Swarf_machining__c);
				J.writeBooleanField('Contour5X',d.Contour_5x__c);
				J.writeBooleanField('Drill5X',d.X5x_Drill__c);
				J.writeBooleanField('Convert5X',d.Convert5X__c);
				J.writeBooleanField('Reduced3D',d.SolidCAM_Mill_3D_No_Engraving__c);
				J.writeBooleanField('XPLUS',d.Xpress_plus__c);
				J.writeBooleanField('MultiBlade',d.MultiBlade5x__c);
				J.writeBooleanField('Port',d.Port_5x__c);
				J.writeBooleanField('Xpress2D',d.Mill_2D_V__c);
				J.writeBooleanField('XpressHSS',d.HSS_V__c);
				J.writeBooleanField('Wire2X',d.SolidCAM_WireEDM_2_axes__c);
				J.writeBooleanField('Wire4X',d.SolidCAM_WireEDM_2_4_axes__c);
				J.writeBooleanField('Probe',d.Probe__c);
				J.writeBooleanField('ExternalNC',d.G_Code_Simulation__c);
				J.writeBooleanField('TDM',d.TDM__c);
				J.writeBooleanField('WINTOOL',d.WinTool__c);
				J.writeBooleanField('ProbeHome',d.Probe_Level2__c);
				J.writeBooleanField('CONSTANTZ',d.SolidCAM_2_7D_CONSTANT_Z__c);
				J.writeBooleanField('Zoller',d.Zoller_integration__c);
				J.writeBooleanField('Rough5X',d.Multi_Axis_Roughing__c);
				J.writeBooleanField('Screw',d.Screw_Machining__c	);
				J.writeBooleanField('ProfileOnly',d.Profile__c);
				J.writeBooleanField('Swiss',d.Swiss_Type__c);
				J.writeBooleanField('Mdepth',d.Multi_depth_Drill__c);
				J.writeBooleanField('EurekaCut',d.Eureka_Cutting_Conditions__c);
				J.writeBooleanField('EurekaEdit',d.Eureka_Machine_Editor__c);
				J.writeBooleanField('EurekaPlay',d.Eureka_Playlist__c);
				J.writeBooleanField('EurekaProbe',d.Eureka_Probe__c);
				J.writeBooleanField('EurekaView',d.Eureka_Viewer__c);
				J.writeBooleanField('Eureka3X',GetEureka3X(d));
				J.writeBooleanField('EurekaMAMC',GetEurekaMAMC(d));
				J.writeBooleanField('EurekaMA1C',GetEurekaMA1C(d));
				J.writeBooleanField('Editor',d.Editor_Mode__c);
				J.writeBooleanField('Simulator',d.Simulator__c);
				J.writeBooleanField('Tooltable',d.Tooltable_Only__c);
				J.writeBooleanField('Breaking',d.X5x_breaking__c);
				J.writeBooleanField('Trimming',d.X5x_Edge_Trimming__c);
				J.writeBooleanField('Eureka',d.Eureka__c);
				J.writeBooleanField('Vericut',d.Vericut__c);
				J.writeBooleanField('Cimco',d.Cimco__c);
				J.writeBooleanField('HSMbasic',d.HSM_Basic__c);
				J.writeBooleanField('CimcoAddOn',d.Cimco_Add_On__c);
	
			}
				
			J.writeStringField('KeyID',d.Name);
			J.writeBooleanField('NetProfiles',d.Network_Profiles_Dongle__c);
			J.writeBooleanField('NX',d.NX__c);
			
			J.writeBooleanField('EDU',d.EDU__c);
			J.writeBooleanField('GCODEOFF',d.NO_G_code__c);
			J.writeBooleanField('EmbeddedFull',d.Embedded_CAD__c == 'Full');
			J.writeBooleanField('EmbeddedPA',d.Embedded_CAD__c == 'P/A');
			J.writeBooleanField('EmbeddedPO',d.Embedded_CAD__c == 'P/O');
			J.writeBooleanField('GPX',d.GPX__c);
			J.writeBooleanField('Evaluation',d.Evaluation__c);
			J.writeBooleanField('Bently',d.Bentley__c);
			J.writeBooleanField('CADTOOL',d.CADTOOL__c);
			J.writeBooleanField('NCTOOL',d.NCTOOL__c);
			J.writeBooleanField('DNCTOOL',d.DNCTOOL_For_Windows__c);
			J.writeBooleanField('Active',d.Active_Key__c == 1);
			J.writeBooleanField('Sentinel',d.Sentinel__c);
			J.writeBooleanField('BaseModeler',d.BaseModeler__c);
			J.writeBooleanField('CloneOFF',d.Clone_detection_disabled__c	);
			J.writeBooleanField('Ver2011',integer.valueof(d.Version__c) >= 140);
			J.writeBooleanField('Ver2012',integer.valueof(d.Version__c) >= 150);
			J.writeBooleanField('Ver2013',integer.valueof(d.Version__c) >= 160);
			J.writeBooleanField('Ver2014',integer.valueof(d.Version__c) >= 170);
			J.writeBooleanField('Ver2015',integer.valueof(d.Version__c) >= 180);
			J.writeBooleanField('Ver2016',integer.valueof(d.Version__c) >= 190);
			J.writeBooleanField('Ver2017',integer.valueof(d.Version__c) >= 200);
			J.writeBooleanField('Ver2018',integer.valueof(d.Version__c) >= 210);
			J.writeBooleanField('Ver2019',integer.valueof(d.Version__c) >= 220);
			J.writeBooleanField('Ver2020',integer.valueof(d.Version__c) >= 230);
			J.writeBooleanField('Ver2021',integer.valueof(d.Version__c) >= 240);
			J.writeBooleanField('Ver2022',integer.valueof(d.Version__c) >= 250);
			J.writeBooleanField('Ver2023',integer.valueof(d.Version__c) >= 260);
			J.writeBooleanField('Ver2024',integer.valueof(d.Version__c) >= 270);
			J.writeBooleanField('Ver2025',integer.valueof(d.Version__c) >= 280);
			J.writeBooleanField('Ver2026',integer.valueof(d.Version__c) >= 290);
			J.writeBooleanField('Ver2027',integer.valueof(d.Version__c) >= 300);
			J.writeBooleanField('Ver2028',integer.valueof(d.Version__c) >= 310);
			J.writeBooleanField('Ver2029',integer.valueof(d.Version__c) >= 320);
			J.writeBooleanField('Ver2030',integer.valueof(d.Version__c) >= 330);
							
			return J;
			
		
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
	
	
	public void GenerateUI()
	{ 
        m_disable_license = false;
        GeneratePK(m_License.Id,false,false);
    }
    
    public void CancelLicense()
    {
    	m_disable_license = true;
    	GeneratePK(m_License.Id,false,false);
    }
    
 	public List<Dongle__c> GetList(ID license)
	{
		List<Dongle__c> ARR = [Select AutoDesk__c,SolidWorks__c,Version__c,Supply_Status__c,
		Net_Dongle__c,Date_Of_Order__c,Name,Serial_No__c,Product_key__c,Actual_Users__c,Dongle_Expiry_Date__c,
		Customer__r.Name,Customer__r.Id,Inventor__c,Embedded_CAD__c,NX__c,Editor_Mode__c,SolidCAM_Mill_2D__c,
		SolidCAM_Mill_3D__c,SolidCAM_Mill_2_5D__c,Recoginition_Features__c,Chamfer_recognition__c,
		Reduced_HolesR__c,Hole_Recognition__c,Stl_Support__c,HSS_Rough__c,Prismatic_HSM__c,EDU__c,
		Spiral_Machining__c,iMachining3D__c,SolidCAM_Turning__c,BackSpindle__c,Sim_Turning__c,
		Multi_Turret_Sync__c,NO_G_code__c,Order__r.Id,Simultaneous_4_axes_C_axes__c,X4_axes_Indexial__c,X4_5_axes_indexial__c,	
		X5_axis__c,Simultaneous5axesReduced__c,	Machine_Simulation__c,Swarf_machining__c,Contour_5x__c,
		X5x_Drill__c,SolidCAM_Mill_3D_No_Engraving__c,Xpress_plus__c,MultiBlade5x__c,Port_5x__c,
		Mill_2D_V__c,HSS_V__c,HSM__c,No_HSS__c,Active_Key__c,Convert5X__c,SolidCAM_WireEDM_2_axes__c,
		SolidCAM_WireEDM_2_4_axes__c,GPX__c,Evaluation__c,Probe__c,G_Code_Simulation__c,TDM__c,
		WinTool__c,	Profile__c,Probe_Level2__c,Activation_cancelled__c,SolidCAM_2_7D_CONSTANT_Z__c,Network_Profiles_Dongle__c,Owner_ID__c,
		Bentley__c,CADTOOL__c,NCTOOL__c,DNCTOOL_For_Windows__c,Sentinel__c,BaseModeler__c,Clone_detection_disabled__c,Multi_depth_Drill__c,Swiss_Type__c,Zoller_integration__c,Multi_Axis_Roughing__c,Screw_Machining__c,Order__c,Eureka_Simulator__c,Eureka_Machine_Editor__c,Eureka_Playlist__c,Eureka_Probe__c,Eureka_Cutting_Conditions__c,Eureka_Viewer__c,
		Cimco__c,Simulator__c,Vericut__c,Eureka__c,X5x_breaking__c	,X5x_Edge_Trimming__c,Tooltable_Only__c,HSM_Basic__c,Cimco_Add_On__c
		From Dongle__c	Where Id =: license Limit 1];
		
		return ARR;
		
	}
	
	public void GetLastAttachment(ID recordID)
	{
		List<Attachment> attachments =  [SELECT Id,Name FROM Attachment  WHERE Parentid IN  (Select Id from Dongle__c 
                    WHERE Id = :recordID) ORDER BY CreatedDate DESC];
                    
                 
                    
        for (Attachment attach : attachments) {
        	if(m_attachment == null && attach.Name.Contains(m_name) && attach.Name.Contains('zip'))
    			m_attachment = attach;
		}
                    
        
	}
		
	public String GeneratePK(ID license,Boolean Test,Boolean Validate)
	{
		dongle__c record;
		String day = '';
		String month = '';
		String year = '';
		String name = '';
		String AccountID = '';
		Date exp;
			
		
		GeneratePK p = new GeneratePK();
		List<Dongle__c> ARR = p.GetList(license);
		
		System.debug('Genereate PK start');
				
		
		if(ARR.size() > 0)
		{
			System.debug('License generation start');
			record = ARR[0];
			Boolean upload_to_opp = true;
            if(record.Order__r.Id == null)
	        	upload_to_opp = false;
			if(record != null)
			{
							
				exp = record.Dongle_Expiry_Date__c;
				if(exp != null)
				{
					if(exp.Day() < 10)
					{
						day = '0';
						day = day += string.valueof(exp.Day());
					}
					
					else
						day = string.valueof(exp.Day());
					
					if(exp.Month() < 10)
					{
						month = '0';
						month = month += string.valueof(exp.Month());
					}
					else
						month = string.valueof(exp.Month());
						
					year = string.valueof(exp.Year());
				}
		
						
				JSONGenerator gen = JSON.createGenerator(true);
		        gen.writeStartObject();
		        if(Validate)
	    	   		gen.writeBooleanField('Validate', true);
	    	   		
	    	   	gen.writeBooleanField('disable', m_disable_license);
	    	   	gen.writeBooleanField('cancelled', record.Activation_cancelled__c);
	    	   		
	    	   	if(record.Customer__r.Id == null || Test)
	    	   	{
	    	   		list<string> users = new list<String>();
			 		users.add('david.somekh@solidcam.com');
					
					string sNewName = record.Name;
					sNewName = sNewName.trim();
					
					String subject = 'Cannot generate PK - no access to account';
			        String link = '<a href="https://eu1.salesforce.com/' + record.Id + '">Link to record</a>';
			        String URL = '<a href="' + link +  '\">' + link;
			        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			        mail.setHtmlBody(link);
			        mail.setToAddresses(users);
			        mail.setSubject(subject);
			        if(!Test)
			        {
			        	Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
			        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error - cannot generate activation (No access to account). Please inform admin.'));
			        	return 'Error - cannot generate activation (No access to account). Please inform admin.';
			        }
	    	   	}
	    	   		
	    	   	if(!Test)
		        {
		        	gen.writeStringField('customer', record.Customer__r.Name);
		        	gen.writeStringField('customerID', record.Customer__r.Id);
		        }
		        
		        gen.writeStringField('dongleID',Id.valueOf(license));
		        gen.writeStringField('ExpDay', day);
		        gen.writeStringField('ExpMonth', month);
		        gen.writeStringField('ExpYear', year);
		        gen.writeBooleanField('network', record.Net_Dongle__c);
		        
		        gen = p.AddFeatures(record,gen,false);
		        if(gen.isClosed())
		        {
		        	m_finished = true;
		        	return 'Cannot generate product key';
		        }
		        if(record.Actual_Users__c != null)
		        	gen.WriteNumberField('netusers', record.Actual_Users__c);
      	        if(!Test)
      	        	gen.writeStringField('user', UserInfo.getUserName());
		        gen.writeEndObject();            
		        String JSON_DATA = gen.getAsString();
		        
		      	String EndPoint;
			    EndPoint = 'https://forms.solidcam.com/ldk/ldk.php';
			    
			    Integer Code = 0;
			    String PKNAME ='';
			    HTTPResponse response = null;
						    				    
			    if(!Test)
			    {
			    	System.debug('Starting http request');
			    	HttpRequest req = new HttpRequest();
			    	req.setEndpoint(EndPoint);
			    	req.setTimeout(120000);
			    	req.setHeader('Content-Type', 'application/json;charset=UTF-8');
			    	req.setBody(JSON_DATA);
			    	req.setMethod('GET');
			    			    			    	    
			     
			    	Http http = new Http();
					HTTPResponse res = null;

								try{
						res = http.send(req);
					}

					catch(Exception e){
						System.debug('ATTACH ERROR');
						System.debug(e.getMessage());
						System.debug(e.getStackTraceString());
					}
			    	response = res;
			 		PKNAME = response.getHeader('PK');
			 		Code = res.getStatusCode();
			 		m_status_code = Code;
			 		String s1=String.valueof(Code);


			 		
			 		
			 		System.debug(s1);
			 		
			    }
			    
			    if(Validate)
			    {
			    	PKNAME= PKNAME.trim();
			    	return PKNAME;
			    }
			    
			        
			    if(Test)
			    	Code = 202;

					

			 	
			 	if(Code == 202 || Code == 203 || Code == 206)
			 	{
			 		if(PKNAME != null)
			 			PKNAME= PKNAME.trim();
			 		if(Code == 203 || Test)
			 		{
			 			if(m_disable_license)
			 			{
			 				date myDate = date.today();
			 				record.Supply_Status__c	 = 'UnActive';
			 				record.Comments__c = 'ACTIVATION WAS CANCELLED BY '+UserInfo.getUserName()+ ' ON '+myDate.format();
			 				record.Activation_cancelled__c = true;
			 			}
			 			/*if(record.Network_Profiles_Dongle__c)
			 			{
			 				String subject = 'NEW network profiles PK';
							String link = 'https://eu1.salesforce.com/' + license;
							String URL = '<a href="' + link +  '\">' + link;
							Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
							mail.setHtmlBody(URL);
						    mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
						    mail.setSubject(subject);
						    Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
			 			}*/
			 			
			 			
			 			m_name = record.Name;
			 			m_finished = true;
			 			record.Date_Of_Order__c = date.today();
			 			
			 			String fileName = record.Customer__r.Name + ' ' + record.Name + '.zip';
		                if(response != null && response.getBodyAsBlob() != null )
				 		{
				 			Attachment attachment = new Attachment();
	            			attachment.Body = response.getBodyAsBlob();
	            			attachment.Name = fileName;
	            			attachment.ParentId = record.Id;
	            			Database.SaveResult InsertResult = Database.insert(attachment,false);
							
							
								if (InsertResult.isSuccess()) {
									// Operation was successful, so get the ID of the record that was processed
									System.debug('Successfully inserted attachmet');
								}
								else {
									// Operation failed, so get all errors                
									for(Database.Error err : InsertResult.getErrors()) {
									//	System.debug('ATTACHMENT FAILED');                    
										//System.debug(err.getStatusCode() + ': ' + err.getMessage());
										//System.debug('ATTACHMENT fields that affected this error: ' + err.getFields());

										String subject = 'Attachment FAILED ' + record.Name;
								
									Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
									String error = err.getStatusCode() + ': ' + err.getMessage();
									error = error + 'ATTACHMENT fields that affected this error: ' + err.getFields();
									mail.setHtmlBody(error);
									mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
									mail.setSubject(subject);
									Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
									}
								}
							
	            			
	            			if(upload_to_opp && record.Order__c != null)
			            	{	
			            		Attachment AttachOpp = new Attachment();
			               		AttachOpp.Body = response.getBodyAsBlob();
			            		AttachOpp.Name = fileName;
			            		AttachOpp.ParentID = record.Order__c;
			            		insert AttachOpp;
			          	    }
				 		}
					    	update record;
				 		}
			 		
			 		if(Code == 202 || Code == 206)
			 		{
			 			if(code == 206 && m_version_mode)
			 			{
			 				m_name = record.Name;
			 				GetLastAttachment(license);
			 				if(m_attachment != null)
			 					m_attachment_download = true;
			 				
			 			}
			 			else
			 				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,PKNAME));
			 				
			 			m_finished = true;
			 		}
			 		
			 		
			 		if(!Test)
			 			return PKNAME;
			 	}
			 	
				if((PKNAME != '' && Code == 201) || Test)
			 	{
			    
				   	/*if(record.Network_Profiles_Dongle__c)
		 			{
		 				String subject = 'NEW network profiles PK';
						String link = 'https://eu1.salesforce.com/' + license;
						String URL = '<a href="' + link +  '\">' + link;
						Messaging.SingleemaiNlmessage mail = new Messaging.Singleemailmessage();
						mail.setHtmlBody(URL);
					    mail.setToAddresses(new list<string>{'david.somekh@solidcam.com'});
					    mail.setSubject(subject);
					    Messaging.sendEmail(new Messaging.Singleemailmessage[] { mail});
		 			}*/
			 			
		 			
				   	PKNAME= PKNAME.trim();
				    m_name = PKNAME;
				    m_finished = true;
				    Product_keys__c	[] PK = new List<Product_keys__c	>();
				    Product_keys__c PKEY= new Product_keys__c(Name=PKNAME,	Customer__c = record.Customer__r.Id,OwnerId = record.Owner_ID__c);
				    PK.add(PKEY);
				    if(!Test)
				    	insert PK;
				    
				    record.Product_key__c = PKEY.Id;
				    record.Name = PKEY.Name;
				    record.Serial_No__c = PKEY.Name;
				    record.Date_Of_Order__c = date.today();
				    
				//    m_attachment = new Attachment();
		         //   m_attachment.Body = Blob.valueOf(PKNAME);
		          //  m_attachment.Name = record.Customer__r.Name + '.txt';
		           // m_attachment.ParentId = license;
		           // insert m_attachment;
		            
		            String fileName = record.Customer__r.Name + ' LICENSE.txt';
		           // if(fileName != null && fileName.contains('='))
          		  	//	fileName = fileName.split('=')[1];
		            if(response != null && response.getBodyAsBlob() != null )
			 		{
			 			Attachment attachment = new Attachment();
            			attachment.Body = response.getBodyAsBlob();
            			attachment.Name = fileName;
            			attachment.ParentId = record.Id;
            			insert attachment;
            			
            			if(upload_to_opp && record.Order__c != null)
		            	{	
		            		Attachment AttachOpp = new Attachment();
		               		AttachOpp.Body = response.getBodyAsBlob();
		            		AttachOpp.Name = fileName;
		            		AttachOpp.ParentID = record.Order__c;
		            		insert AttachOpp;
		          	    }
			 		}
		            
		            
		        	 
				    if(!Test)
						update record;
						
				    return PKNAME;
			 	}
				
			}
		}
		
	return 'Cannot generate product key';
		
	}
	
	webservice static String PK(ID license,Boolean Validate)
	{
		GeneratePK p = new GeneratePK();
		
		return p.GeneratePK(license,false,Validate);
		
		
	

		
		
		
	}
	

		
}