/*********************************************
* EmilK
* class holds information about dongles in account
*
***********************************************/
public with sharing class AccountDonglesData {
	
	private Integer mSubs;
	private Integer mSeats;
	private Integer m3Dmill;
	private Integer mHSM;
	private Integer mHSS;
	private Integer mSolidWorks;
	private Integer mInventor;
	private Integer m_EDU;
	private Integer m_modern_CAD;
	private Integer m_imachining;
	private Integer m_imachining3d;
	
	/*
		Ctor
	*/
	public AccountDonglesData(){
		
		//Comment
		
		//EmilK
		// initial value of all fields is 0
		mSubs = 0;
		mSeats = 0;
		m3Dmill = 0;
		mHSM = 0;
		mHSS = 0;
		mSolidWorks = 0;
		mInventor = 0;
		m_EDU = 0;
		m_modern_CAD = 0;
		m_imachining = 0;
		m_imachining3d = 0;
	}
	
	public Integer Modern_CAD{
		set{m_modern_CAD = value;}
		get{return m_modern_CAD;}
	}
	
	/*
		Get & Set number dongles that are "on maintenence"
	*/
	public Integer Subs{
		set{mSubs = value;}
		get{return mSubs;}
	}
	
	/*
		Get & Set number of dongles that are EDU dongles
	*/
	public Integer EDU{
		set{m_EDU = value;}
		get{return m_EDU;}
	}
	
	/*
		Get & Set number Seats
	*/
	public Integer Seats{
		set{mSeats = value;}
		get{return mSeats;}
	}
	
	/*
		Get & Set number of dongles that are mill3D
	*/
	public Integer mill3D{
		set{m3Dmill = value;}
		get{return m3Dmill;}
	}
	
	/*
		Get & Set number of dongles that are HSM
	*/
	public Integer HSM{
		set{mHSM = value;}
		get{return mHSM;}
	}
	
	/*
		Get & Set number of dongles with imachining
	*/	
		public Integer IMachining{
		set{m_imachining = value;}
		get{return m_imachining;}
	}
	/*
	
	/*
		Get & Set number of dongles with imachining
	*/	
		public Integer IMachining3D{
		set{m_imachining3D = value;}
		get{return m_imachining3D;}
	}
	/*
		Get & Set number of dongles that are HSS
	*/
	public Integer HSS{
		set{mHSS = value;}
		get{return mHSS;}
	}
	
	/*
		Get & Set number of dongles that SolidWorks
	*/
	public Integer SolidWorks{
		set{mSolidWorks = value;}
		get{return mSolidWorks;}
	}
	
	/*
		Get & Set number of dongles that are Inventor
	*/
	public Integer Inventor{
		set{mInventor = value;}
		get{return mInventor;}
	}
}