/***************************************************
*	EmilK
*	don't allow 2 accounts with the same name
* in the system 
****************************************************/
trigger On_Account_Insert on Account (before insert, before update) {
	
	Account ACC = Trigger.new[0]; //Pointer to the dongle
	UpdateAccountOwner OwnerClass = new UpdateAccountOwner();
	
	OwnerClass.UpdateOwner(ACC);
	
	map<String, Account> accountNames = new map<String, Account>();
	PAD.requiredOnce.add('On_Account_Insert'); 
	if(PAD.canTrigger('On_Account_Insert')){
		for(Account anyAccount : Trigger.new){
			// if account is new or its name was changed
			if (Trigger.isInsert || anyAccount.Name != Trigger.oldMap.get(anyAccount.Id).Name){
				if (accountNames.containsKey(anyAccount.Name)){
					anyAccount.addError('Trying to insert/ update 2 accounts with name = \''+anyAccount.Name+'\'');
				}	
				else{
					accountNames.put(anyAccount.Name, anyAccount);
				}
			}
		}
		System.debug('Query #6 - On_Account_Insert');
		List<Account> accountsInSys = [Select Name From Account where Name IN :accountNames.keySet()];
		// now check if there are allready in sys more accounts with same name
		for(Account inSys : accountsInSys ){
			if(accountNames.containsKey(inSys.Name))
				accountNames.get(inSys.Name).addError(' can not insert / update account with this name exsists');
		}
	}
}