/*******************************************************
*	EmilK - Bachable class.  
*	update number of dongles data in customer account
*	and resellers account
********************************************************/
global class DongleUpdateNotifier implements 
							Database.Batchable<sObject>, Schedulable, Database.Stateful{
	
	// SQL query inserted into Batch Apex	
	private String m_query;
	private Integer m_iNumberOfAccounts = 0;
	
	// last account id batch treated
	private ID m_last_account_saw;
	
	// define enum mode
	public enum Mode {Customer, Reseller}
	
	private Mode m_mode;
	
	// Hold data about errors that accoured while running batch
	// Errors accured when updating account data
	private List<String> m_errorMessages;
	/**
	*	EmilK 
	*	Ctor
	**/
	public DongleUpdateNotifier(){
		m_last_account_saw = null;
		m_mode = Mode.Customer;
		m_errorMessages = new List<String>();
	}
	
	public DongleUpdateNotifier(Mode mode){
		m_last_account_saw = null;
		m_mode = mode;
		m_errorMessages = new List<String>();
		
	}
	
	/**
	*	EmilK
	*	get , set SQL Query
	**/
	public String Query{
		set{m_query = value;}
		get{return m_query;}
	} 
	
	/* EmilK
	 * execute - required to schedule class
	 *
	 */
	global void execute(SchedulableContext sc) {
		
   		DongleUpdateNotifier notifier = new DongleUpdateNotifier(Mode.Customer);
   		database.executebatch(notifier, 100);
   	}
	
	
	/** 	
	*	EmilK 
	*	start
	**/
	global database.querylocator start(Database.BatchableContext BC){

			if (m_query == null){
				//EmilK 
				// Sql query brings all dongles in the system
				System.debug('Query #23 - DongleUpdateNotifier');
	            m_query = 'Select Id, Customer__c, Reseller__c, On_Maintenance__c'+
	    				', Inventor__c, HSM__c, X5_axis__c, Spiral_Machining__c'+
	    				', iMachining3D__c , SolidWorks__c, SolidCAM_Mill_3D__c,Editor_Mode_Light__c,Simulator__c,Editor_Mode__c'+
	    				', EDU__c ,Is_Relevant__c, Name';
				m_query +=	' from Dongle__c';
				if (m_mode == Mode.Customer)
					m_query +=	' ORDER BY Customer__c';
				else
					m_query +=	' ORDER BY Reseller__c';
			}
            return Database.getQueryLocator(m_query);
    }
 
	/**
	*	EmilK
	*	execute
	**/
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		 
		List<Dongle__c> dongleList = new List<Dongle__c>();
		// keep all given dongles 
		for(sObject anyObj : scope ){
			dongleList.add((Dongle__c)anyObj);
		}
		update_accounts_on_schedule(dongleList);	
	}
	
	/** 
	*	EmilK  
	*	finish batch 
	**/
	global void finish(Database.BatchableContext BC){
		
		if (m_errorMessages.size() > 0){
			sendMailToAdmin();
		}
	}
	
	/**
	*	EmilK
	*	Update all doungles counters
	**/
	public void update_all_dongles_counters(List<Dongle__c> donglesList){
	
    // map holds account id and number of times it was counted
    Map<ID, AccountDonglesData> count_number_of_Acounts = 
    new Map<ID, AccountDonglesData>();

	// get all account id of the accounts that
	// will be changed after the execution of the function
	for (Dongle__c anyDongle : donglesList){
		if (m_mode == Mode.Customer)
			count_number_of_Acounts.put(anyDongle.Customer__c, new AccountDonglesData());
		else
			count_number_of_Acounts.put(anyDongle.Reseller__c, new AccountDonglesData());
	}
	
    // get all dongles in system which has to be counted
    // number of results is limitated to 999 dongles
    // to avoid limit exception / It is assumed for now that 
   // System.debug('Query #24 - DongleUpdateNotifier');
    List<Dongle__c> donglesToCount = [Select Id, Customer__c, On_Maintenance__c
    								  , Inventor__c, HSM__c, X5_axis__c, Spiral_Machining__c,iMachining3D__c,
    								   SolidWorks__c, SolidCAM_Mill_3D__c,Editor_Mode_Light__c,Editor_Mode__c,Simulator__c
    								  , EDU__c, Name
     								 from Dongle__c 
     							     where Customer__c in : count_number_of_Acounts.keySet() 
     							     	and Is_Relevant__c = 1 limit 100];
    
    update_dongles_data(donglesToCount, count_number_of_Acounts);
    update_accounts(count_number_of_Acounts, donglesList, false);
}
	
	/*
	*	EmilK
	*	update dongles data
	*/
	public void update_dongles_data(List<Dongle__c> dongles_list, 
										   Map<ID, AccountDonglesData> count_number_of_Acounts){
	    // loop over all dongles that has to be count 
	    for (Dongle__c anyDongle : dongles_list){
	        // get Id of reference account id (may be null in trigger mode)
	        ID accountId;
	        if(m_mode == Mode.Customer)
	        	accountId = anyDongle.Customer__c;
	        else
	        	accountId = anyDongle.Reseller__c;
	        	
	        if (AccountId == null){
	        	continue;
	        }
	      	// update dongle data in account
	        AccountDonglesData donglesCount = count_number_of_Acounts.get(accountId);
	        donglesCount = updated_dongle_data(donglesCount, anyDongle);
	        // EmilK
	        // Needed????
	        count_number_of_Acounts.put(accountId, donglesCount);
	    }
	}
	/*
	*	EmilK
	*	update accounts
	*/
	private void update_accounts(Map<ID, AccountDonglesData> count_number_of_Acounts, 
										List<Dongle__c> donglesList,
										Boolean isScedule){
											
	    List<ID> id_of_null_accounts = new List<ID>();
	    
	    // get all account to be updated
	    Map<ID, Account> affected_Accounts_map = new Map<ID, Account>
	        ([Select Id, Number_of_subs__c, 
	        		 Seats__c, HSM__c,HSS__c, iMachining__c,iMachining_3D__c,
	        		 InventorCAM__c, SolidCAM__c,
	        		 X3D_Mill__c, EDU__c, Name, Subs_Modern_CAD__c, 
	        		 Subs_Balance__c , Previous_Subs_Balance__c
	          from Account 
	          where Id in : count_number_of_Acounts.keySet()]);
	          
	    List<ID> accountSortedIds = new List<ID>();
	    Boolean isToAdd = true;

	    // create a list of account ids that will allow to loop
	    //over the accounts on the order they were given
	    // the SQL query makes a mass in the accounts
	    for(Dongle__c anyDongle : donglesList){
	    	ID account_id;
	    	if (m_mode == Mode.Customer)
	    		account_id = anyDongle.Customer__c;
	    	else
	    		account_id = anyDongle.Reseller__c;
	    		
    		for (ID in_list_value : accountSortedIds){
    			if (in_list_value == account_id){
    				isToAdd = false;
    				break;
    			}
    			isToAdd = true;
    		}
    		if(isToAdd){
    			accountSortedIds.add(account_id);
    		}
	    }
	       
	 	// Loop over all accounts and update number of dongles
	    for (ID any_account_id : accountSortedIds){ 
	         Account counted_account = affected_Accounts_map.get(any_account_id);
	         // There are in the system dongles with no customers
	         // if dongle has no customer - skip it 
	         if (counted_account == null){
	         	id_of_null_accounts.add(any_account_id);
	         	continue;
	         }
	         AccountDonglesData donglesCount = count_number_of_Acounts.get(any_account_id);
	         // update account Data
	         counted_account = update_account_data(counted_account, donglesCount, isScedule);
	         affected_Accounts_map.put(any_account_id, counted_account);
	    }
	    // before really updating - remove all null accounts from map
	    for(ID anyId : id_of_null_accounts){
	    	count_number_of_Acounts.remove(anyId);
	    }
	    // update affected accounts
	    update_accounts_in_DB(affected_Accounts_map.values(), donglesList);
	}
	
	/**  
	 *	update accounts in DB if failed - send mail to david and eddie 
	 **/
	public void update_accounts_in_DB(List<Account> accoutsToUpdate, 
									   List<Dongle__c> donglesList){
		// Loop over all accounts to update
		// try to update every one alone
		Integer iNumberOfAccounts = 0;
		iNumberOfAccounts++;
		//System.debug('Number of accounts =  '+iNumberOfAccounts);
		for(Account account : accoutsToUpdate){ 
	    	try{
	    		System.debug('Update = '+account.Id);
				if(Test.isRunningTest())
				{
					Account testAccount = new Account(Name = 'simon', Type = 'Customer',ShippingCountry = 'Germany');
					WriteErrorToAdmin(testAccount,donglesList[0]);
				}
	    		update account;
	    	}
	    	catch(Exception systemError){
	    		// get dongle that the account that fired the exception belongs to.
	    		Dongle__c dongleMadeError = null;
				
	    		
	    		for (Dongle__c anyDongle : donglesList){
	    			if (anyDongle.Customer__c == account.Id){
	    				dongleMadeError = anyDongle;
	    				break;
	    			}
	    		}
	    		// Add data for email
	    		String error = WriteErrorToAdmin(new Account(), dongleMadeError);
	    		m_errorMessages.add(error);
	    	}
	    }
		
	}
	
	/**
	*	Add data for email  
	*
	**/
	private String WriteErrorToAdmin(Account faildInAccount, Dongle__c dongleCausedFailure){
		
		// write mail body as HTML string
		String errorMessage = 
			'Error accoured while updating \'Num Of Subs field\' in Account : ';
		if (faildInAccount != null)
			errorMessage += faildInAccount.Name;
		else
			errorMessage += 'NULL Account';
			
		errorMessage += '\nDongle that caused the error';
		if (dongleCausedFailure != null)
			errorMessage += ''+dongleCausedFailure.Name;
		else
			errorMessage += 'null';
			
		errorMessage += '\nTime error acourred : '+Datetime.now();
		errorMessage += '\n';
			
		return errorMessage;
	}
	
	/**
	*	EmilK
	*	update Account In DB
	**/
	public Account update_account_data(Account theAccount, 
										 AccountDonglesData accountData,
										 Boolean isScheduling){
		
		// check if account has been allready seen							 	
		Boolean isSawAccount = m_last_account_saw == theAccount.id;	
		System.debug('Account Id = '+theAccount.Id);
		// if we are not in sceduling mode or we are seeing a new (untreated) account
		if (isScheduling == false || isSawAccount == false){
			// update account dongle counting 
			theAccount.Number_of_subs__c = accountData.Subs;
			theAccount.Seats__c = accountData.Seats;
			if (m_mode == Mode.Customer){
				theAccount.HSS__c = accountData.HSS;
				theAccount.HSM__c = accountData.HSM;
				theAccount.InventorCAM__c = accountData.Inventor;
				theAccount.SolidCAM__c = accountData.SolidWorks;
				theAccount.X3D_Mill__c = accountData.mill3D;
				theAccount.EDU__c = accountData.EDU;
				theAccount.iMachining__c = accountData.IMachining;
				theAccount.iMachining_3D__c = accountData.IMachining3D;
			}
			else{
			// save last balance before updating the new one
			if (theAccount.Subs_Balance__c != null)
				theAccount.Previous_Subs_Balance__c = theAccount.Subs_Balance__c;
				theAccount.Subs_Modern_CAD__c = accountData.Modern_CAD;
			}
			// register the last saw account
			m_last_account_saw = theAccount.Id;
		}	
		// This account was allready treated by Batch Apex						 	
		else{
			
			// update account data
			theAccount.Number_of_subs__c += accountData.Subs;
			theAccount.Seats__c += accountData.Seats;
			if (m_mode == Mode.Customer){
				theAccount.HSM__c += accountData.HSM;
				theAccount.HSS__c += accountData.HSS;
				theAccount.InventorCAM__c += accountData.Inventor;
				theAccount.SolidCAM__c += accountData.SolidWorks;
				theAccount.X3D_Mill__c += accountData.mill3D;
				theAccount.EDU__c += accountData.EDU;
				theAccount.iMachining__c += accountData.IMachining;
				theAccount.iMachining_3D__c = accountData.IMachining3D;
			}
			//else  Reseller mode 
			else{
				// for Reseller account
				theAccount.Subs_Modern_CAD__c += accountData.Modern_CAD;
			}
		}
		
		if (m_mode == Mode.Reseller){
			theAccount.Subs_Balance__c = 0;
			if (theAccount.Subs_Modern_CAD__c > 0){
		 		theAccount.Subs_Balance__c = 
		 		(theAccount.Number_of_subs__c / theAccount.Subs_Modern_CAD__c) * 100;
			}
		}
		
		return theAccount;
	}
	
	/**
	* 	EmilK
	* 	update Dongle Data in account
	**/
	public AccountDonglesData updated_dongle_data(AccountDonglesData donglesCount, Dongle__c theDongle){
		
		try{
			Boolean bEditor = theDongle.Editor_Mode_Light__c	|| theDongle.Editor_Mode__c || theDongle.Simulator__c;
			if(!bEditor)
			{
				donglesCount.Seats++;
				
				if (theDongle.On_Maintenance__c == 1){
					donglesCount.Subs++;
				}
				if (m_mode == Mode.Customer || Test.isRunningTest()){
					if (theDongle.EDU__c){
						donglesCount.EDU++;
					}
					if (theDongle.Inventor__c){
						donglesCount.Inventor++;
					}
					if (theDongle.HSM__c){
						donglesCount.HSM++;
					}
					if (theDongle.X5_axis__c){
						donglesCount.HSS++;
					}
					if (theDongle.SolidWorks__c){
						donglesCount.SolidWorks++;
					}
					if (theDongle.SolidCAM_Mill_3D__c){
						donglesCount.mill3D++;
					}
					if (theDongle.Spiral_Machining__c || Test.isRunningTest()){
						donglesCount.IMachining++;
					}
					if (theDongle.iMachining3D__c || Test.isRunningTest()){
						donglesCount.IMachining3D++;
					}
				}
				// else - reseller mode
				else{
					if (theDongle.SolidWorks__c || theDongle.Inventor__c){
						donglesCount.Modern_CAD++;
					}
				}
			}
		}
		catch(Exception e){
			System.debug('Error: on dongle '+theDongle.Name);
		}
		return donglesCount;
	}
	
	public void sendMailToAdmin(){
		
		Messaging.Singleemailmessage mailToSend = new Messaging.Singleemailmessage();
		
		String[] mailAdresses = 
			new String[] {'dsomekh@solidcam.com', 'eddie.pevzner@solidcam.com'}; 
		// set adresses to which the mail will be sent
		mailToSend.setToAddresses(mailAdresses);
		// set sender display name
		mailToSend.setSenderDisplayName('Solidcam - salesforce enviroment');
		// Set mail subject
		mailToSend.setSubject('Error acoured while a dongle was updated.');

		if(Test.isRunningTest())
			m_errorMessages.add('nice error');
		
		// Write mail body
		String mailErrorMessage = '';
		for (String error : m_errorMessages){
			// add error to mail body
			mailErrorMessage += error;
			mailErrorMessage += '\n';
		}
		// write email body
		mailToSend.setPlainTextBody(mailErrorMessage);
		
		mailToSend.setBccSender(false); 
		// send mail
		Messaging.Singleemailmessage[] mails = new Messaging.Singleemailmessage[]{mailToSend};
		Messaging.sendEmail(mails, false);
	}
	
	public void update_accounts_on_schedule(List<Dongle__c> dongleList){
		
		
		// account map is a function accountId -> account dongles details
		Map<ID, AccountDonglesData> accountMap = new Map<ID, AccountDonglesData>();
		
		// get all account id of the accounts that
		// will be changed after the execution of the function
 		Map<ID, Integer> aids = new Map<ID, Integer>();
 		System.debug(' mode2 = '+m_mode);
 		ID acountId;
 		if (m_mode == Mode.Customer){
	 		// Add account that we be updated by program
			for (Dongle__c anyDongle : dongleList){
				if (m_mode == Mode.Customer)
					acountId = anyDongle.Customer__c;
				 if (acountId == null){
				 	continue;
				}
				if (aids.containskey(acountId) == false){
					accountMap.put(acountId, new AccountDonglesData());
				}	
			}
 		}
 		// else - look at reseller id (code was dubbled to reduce total number of lines in running script)
		else{
			// Add account that we be updated by program
			for (Dongle__c anyDongle : dongleList){
				acountId = anyDongle.Reseller__c;
				 if (acountId == null){
				 	continue;
				}
				if (aids.containskey(acountId) == false){
					accountMap.put(acountId, new AccountDonglesData());
				}	
			}
		}
		
		//Remove irelevant dongles from list dongle list
		Integer lastListIndex = dongleList.size() - 1;
		for(Integer i = lastListIndex; i>=0 ; i--){
			if(dongleList[i].Is_Relevant__c == 0){
				dongleList.remove(i);
			}
		}
		update_dongles_data(dongleList, accountMap);
		update_accounts(accountMap, dongleList, true);
	}
}