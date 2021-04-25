/**********************************************************************
*	EmilK - sync seller , subreseller and customes between dongle an d sale
*
*
***********************************************************************/
trigger sync_Dongle_By_Sale on Dongle__c (before insert, before update) {
	
	//When user does not insert reseller/subreseller/customer we take this data from the sale related to it
	
	Dongle__c pCurrentDongle = Trigger.new[0]; //Pointer to the dongle
	
	UpdateDongleOwner OwnerClass = new UpdateDongleOwner();
	OwnerClass.UpdateOwner(pCurrentDongle);
	
	if(pCurrentDongle.Evaluation__c)
		pCurrentDongle.Logo__c = 32;
	else
		pCurrentDongle.Logo__c = 0;
	
	
	String sOrderNumber;
	String sSaleReseller;
	String sSaleCustomer;
	String sSaleSubReseller;
	
	if(pCurrentDongle.Order__c != null)
	{
		sSaleReseller       = pCurrentDongle.SaleReseller__c;     //String with sale reseller 
		sSaleSubReseller    = pCurrentDongle.SalesSubReseller__c; //String with sale sub reseller 
		sSaleCustomer       = pCurrentDongle.SaleCustomer__c;     //String with sale customer
		sOrderNumber        = pCurrentDongle.SaleOrderNumber__c;  //String with sale name
	}
		
	Boolean bDongleReseller     = (pCurrentDongle.Reseller__c         != null); //True if user inserted a reseller
	Boolean bDongleSubReseller  = (pCurrentDongle.SubReseller__c      != null); //True if user inserted a sub reseller
	Boolean bDongleCustomer     = (pCurrentDongle.Customer__c         != null); //True if user inserted a customer
	
	Boolean bSaleReseller       = (pCurrentDongle.SaleReseller__c     != null); //True if sale has a reseller
	Boolean bSaleSubReseller    = (pCurrentDongle.SalesSubReseller__c != null); //True if user has a sub reseller
	Boolean bSaleCustomer       = (pCurrentDongle.SaleCustomer__c     != null); //True if user has a customer
	
	if(sOrderNumber != null)
		sOrderNumber.ToLowerCase(); //We want to use lower case letters
	
	//Validations
	if(!bDongleReseller && !bSaleReseller) //If user did not insert reseller and sale does not have reseller
	{
		pCurrentDongle.addError('Cannot save dongle. Please insert a reseller.');
		return;
	}
	
	if(!bDongleCustomer && !bSaleCustomer) //If user did not insert customer and sale does not have customer
	{
		pCurrentDongle.addError('Cannot save dongle. Please insert a customer.');
		return;
	}
	
	//When sale is stock we do not want to take the details so we force the user to insert
	
	if(sOrderNumber != null)
	{
		if(sOrderNumber.contains('stock') && !bDongleReseller) //If sale is stock and user did not insert reseller
		{
			pCurrentDongle.addError('Cannot save dongle. Please insert a reseller.');
			return;
		}
		
		if(sOrderNumber.contains('stock') && !bDongleCustomer) //If sale is stock and user did not insert customer
		{
			pCurrentDongle.addError('Cannot save dongle. Please insert a customer.');
			return;
		}
	}
	
	//End of Validations
		
	//Sync dongle with sale
	
	if(!bDongleReseller) //If the user inserted a reseller so we don't overide
	{
		pCurrentDongle.Reseller__c = sSaleReseller;
	}
	
	if(!bDongleSubReseller) //If the user inserted a sub reseller so we don't overide
	{
		pCurrentDongle.SubReseller__c = sSaleSubReseller;
	}
	
	if(!bDongleCustomer) //User inserted a customer so we don't overide
	{
		pCurrentDongle.Customer__c = sSaleCustomer;
	}
	 	 	
 	//Validations
	if(pCurrentDongle.Reseller__c == null) //End of trigger and still no reseller - Error
	{
		pCurrentDongle.addError('Cannot save dongle. Please insert a reseller.');
		return;
	}
	
	if(pCurrentDongle.Customer__c == null) //End of trigger and still no customer - Error
	{
		pCurrentDongle.addError('Cannot save dongle. Please insert a customer.');
		return;
	}
		
	//End of Validations
 
}