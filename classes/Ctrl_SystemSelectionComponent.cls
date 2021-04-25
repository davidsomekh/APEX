public with sharing class Ctrl_SystemSelectionComponent {
	
	public List<String> missingListIncluded {get;set;}
	public List<String> missingListOptional {get;set;}
	public List<String> missingListOthers {get;set;}
	public boolean missing{get;set;}
	
	public Decimal Ttotal{get;set;}
    public Decimal Ttotal1{get;set;}
    public Decimal Bundlequantity { get; set; }
	public Boolean disablepbs{get;set;}
	public Id OpportunityId{get;set;}
    
    public  List < SelectOption > PricebookNames{get;set;} 
    public  List < SelectOption > BundleNames{get;set;}
    public String selectedPicebookIds {get;set;}
    public String selectedBundleId {get;set;}
    
    public Opportunity opp {get;set;} 
    
    public List < OptionalAdOnWrapper > listOfOptionalAdOnWrapper {get;set;}
    public List < WrapperOfIncludedProduct > WrapperOfIncludedProductList {get;set;}
    public List < WrapperOfProducts > allProductsEveryBundleCheckboxcheckedList{get;set;}
    
    public List < Optional_Ad_Ons__c > OptionalAdOnProductList {get;set;}
    public List < Included_Product__c > IncludedProductList {get;set;}
    public List < Product2 > productList {get;set;}
    
    public String pricebookid;
    public String bundleId;
    public String optPrdId;
    public String othPrdId;
    
    public Map < Id, PricebookEntry > ProductidToPricebookEntry {get;set;}
    public Map < Id, PricebookEntry > ProductidToPricebookEntryOfOptionalAdOnProduct {get;set;}
    public Map < Id, PricebookEntry > mapToProducts {get;set;}
    
    public String BundleName;
    public Set<ID> setofProductId{get;set;}
    public Boolean dispNextBtn {get;set;}
    
    public String currentUserId{get;set;}
    public User currentLoggedInUsed{get;set;}
    public map<Id,OpportunityLineItem> lstOfOppLineItem{get;set;}
    
    //Constructor
    public Ctrl_SystemSelectionComponent() {
    	currentUserId = UserInfo.getUserId();
    	
    	missingListIncluded=new List<String>();
    	missingListOptional=new List<String>();
    	missingListOthers=new List<String>();
    	
        PricebookNames = new List < SelectOption > ();
        BundleNames = new List < SelectOption > ();
        
        setofProductId = new set<ID>(); 
        
        OptionalAdOnProductList = new List < Optional_Ad_Ons__c > ();
        IncludedProductList = new List < Included_Product__c > ();
        productList = new List < Product2 > ();
        lstOfOppLineItem = new map<Id,OpportunityLineItem>();
        
        WrapperOfIncludedProductList = new List < WrapperOfIncludedProduct > (); //Included Products related Wrapper
        listOfOptionalAdOnWrapper = new List < OptionalAdOnWrapper > (); //Optional Ad On Products Related Wrapper
        allProductsEveryBundleCheckboxcheckedList = new List < WrapperOfProducts > (); // all Products Related To Every Bundle Checkboxchecked  Wrapper
        
        ProductidToPricebookEntry = new map < Id, PricebookEntry > ();
        ProductidToPricebookEntryOfOptionalAdOnProduct = new map < Id, PricebookEntry > ();
        mapToProducts = new map < Id, PricebookEntry > ();
        
        OpportunityId = ApexPages.currentPage().getParameters().get('id'); //getting the id of Current Opportunity
        opp = [SELECT id, Name, Package_Description__c,primary_bundle__r.Package_Description__c,CurrencyIsoCode,Pricebook2Id,Quantity_of_Primary_Bundle__c, primary_bundle__c,primary_bundle__r.Id FROM Opportunity WHERE id = : OpportunityId];
        if(opp.Package_Description__c ==''){
        	opp.Package_Description__c = opp.primary_bundle__r.Package_Description__c;
        }
        BundleName = opp.primary_bundle__c;
        pricebookid = opp.Pricebook2Id;
        
        currentLoggedInUsed = [Select Id, Name, Default_Pricebook_for_Configurator__c From User WHERE Id=:currentUserId];

        if(opp.Pricebook2Id == null){
        	map<String,Id> mapofPricebkNametoID = new map<String,Id>();
        	for(Pricebook2 pbook : [select Id, Name FROM Pricebook2]){
        		mapofPricebkNametoID.put(pbook.Name,pbook.Id);
        	}
        	if(mapofPricebkNametoID.containsKey(currentLoggedInUsed.Default_Pricebook_for_Configurator__c)){ selectedPicebookIds = mapofPricebkNametoID.get(currentLoggedInUsed.Default_Pricebook_for_Configurator__c);
        		} 
         }
        else{
        	selectedPicebookIds = opp.Pricebook2Id;	
        }
        
       
        if(opp.primary_bundle__r.Id !=null){
        	dispProducts();
        }else{
		dispNextBtn = true;
        }
        if(selectedBundleId == null || selectedBundleId==''){
        	selectedBundleId = opp.primary_bundle__r.Id;
        }
        if(opp.Quantity_of_Primary_Bundle__c>0){ Bundlequantity = opp.Quantity_of_Primary_Bundle__c;
        }else{
        	Bundlequantity = 1;
        }
        if (opp.Pricebook2Id != NULL)
            disablepbs = true;

        for(OpportunityLineItem oppLineItem : [Select Description,Included_Product__c,Optional_Ad_Ons__c,Product__r.Description,Product__c,PricebookEntry.Product2Id From OpportunityLineItem where Opportunity.Id=:OpportunityId]){
        	setofProductId.add(oppLineItem.PricebookEntry.Product2Id);
        	if(selectedBundleId == opp.primary_bundle__r.Id){
        		if(oppLineItem.Optional_Ad_Ons__c!=null){lstOfOppLineItem.put(oppLineItem.Optional_Ad_Ons__c,oppLineItem);}
        		if(oppLineItem.Product__c!=null){lstOfOppLineItem.put(oppLineItem.Product__c,oppLineItem);}
        	}else{
        		lstOfOppLineItem.clear();
        	}
        }
        
        List < SelectOption > Options = new List < SelectOption > ();
        List<Pricebook2> pricebookList = new List < Pricebook2 > ();
        if (pricebookid != NULL) {
            pricebookList = [select Id, name FROM Pricebook2 WHERE Id = : pricebookid];
            for (Pricebook2 price: pricebookList) {
                if (price.id == Opp.Pricebook2Id) {
                    PricebookNames.add(new SelectOption(Opp.Pricebook2Id, price.name));
                }
            }
        } else {
            
            pricebookList = [select Id, name FROM Pricebook2 ORDER BY name ASC];
            if (pricebookList.size() > 0) {
                PricebookNames.add(new SelectOption('', 'None'));
                for (Pricebook2 price1: pricebookList) {
                    PricebookNames.add(new SelectOption(price1.Id, price1.name));
                }
            }
        }
        //Bundles
        callBundlesPicklist();
    }
    public PageReference callBundlesPicklist() {
    	////system.debug('inside call bundle picklist  **********'+selectedPicebookIds);
        List < Bundle__c > bundleList = new List < Bundle__c > ();
        try {
            if (pricebookid != NULL) {
            	
            	bundleList = [select Id, name, Price_Book__c FROM Bundle__c WHERE Price_Book__c = : pricebookid ORDER BY Name ASC];
                bundleId = BundleName;
                
                if (bundleList.size() > 0) {
                	
                    for (Bundle__c bundle: bundleList) {
                        BundleNames.add(new SelectOption(bundle.Id, bundle.name));
                        BundleNames.Sort();
                    }
                    
                } else {
                	
                    BundleNames.add(new SelectOption('', 'None'));
                    disablepbs = false;
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '' + 'No Pricebook Related Packages '));
                }  
              } else if (selectedPicebookIds != NULL || selectedPicebookIds == NULL) {  
              	bundleList = [select Id, name, Price_Book__c FROM Bundle__c WHERE Price_Book__c = : selectedPicebookIds ORDER BY Name ASC];
				BundleNames = new List < SelectOption > ();
                BundleNames.add(new SelectOption('', 'None'));
                if (bundleList.size() > 0) {
                	
                    for (Bundle__c bundle1: bundleList) {
                        BundleNames.add(new SelectOption(bundle1.Id, bundle1.name));
                        BundleNames.Sort();
                    }
                }
            }DisplayRelatedOptionalAdOnProducts();
        } catch (Exception e) { Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '' + 'No Package records exists related to this Picebook')); }
        return null;
    }

    public pageReference DisplayRelatedOptionalAdOnProducts() {
    	if(selectedBundleId !=null && selectedBundleId != opp.primary_bundle__c){
    		Bundle__c bundleRec = [Select Id, Package_Description__c from Bundle__c where Id  = :selectedBundleId];
    		opp.Package_Description__c = bundleRec.Package_Description__c;
    	}
    	map<Id,OpportunityLineItem> protIdsTODisp = new map<Id,OpportunityLineItem>();
        
         for(OpportunityLineItem oppItem : [Select Id,Quantity,UnitPrice,Included_Product__c,Optional_Ad_Ons__c,Product__c from OpportunityLineItem where OpportunityId = :OpportunityId]){
    		if(oppItem.Optional_Ad_Ons__c!=null){
    			protIdsTODisp.put(oppItem.Optional_Ad_Ons__c,oppItem);
    		} 
    		if(oppItem.Product__c !=null){protIdsTODisp.put(oppItem.Product__c,oppItem);
    		}
    		if(oppItem.Included_Product__c !=null){	protIdsTODisp.put(oppItem.Included_Product__c,oppItem);
    		}
    	}
        //Display Included Products Related to Bundle
        disablepbs = true;
        try {
            WrapperOfIncludedProductList.clear();
            listOfOptionalAdOnWrapper.clear();
            allProductsEveryBundleCheckboxcheckedList.clear();
            set < ID > productids = new set < ID > ();
            if (selectedBundleId != NULL && selectedPicebookIds != NULL) {
            	
                IncludedProductList = [select id, name,	Sort_Order__c, Bundle__c,Product__r.Description, Quantity__c, Product__c,Product__r.Name from Included_Product__c where Bundle__c = : selectedBundleId order by Sort_Order__c ASC];
                if (IncludedProductList.size() > 0) {
                	for(Included_Product__c iterateincludedpro: IncludedProductList){
                		 productids.add(iterateincludedpro.Product__c);
                	}
                	for (PricebookEntry pricBkEntry: [SELECT Product2Id,Product2.Description,CurrencyIsoCode, Pricebook2Id, UnitPrice,Pricebook2.CreatedDate FROM PriceBookEntry WHERE Product2Id IN: productids AND /*CurrencyIsoCode = :opp.CurrencyIsoCode*/ Pricebook2Id = : selectedPicebookIds AND Pricebook2.IsStandard=: false]) {
						
						if(ProductidToPricebookEntry.containsKey(pricBkEntry.Product2Id))
						{
						 if(ProductidToPricebookEntry.get(pricBkEntry.Product2Id).Pricebook2.CreatedDate < pricBkEntry.Pricebook2.CreatedDate)
						  ProductidToPricebookEntry.put(pricBkEntry.Product2Id, pricBkEntry);	
						}
						else
						ProductidToPricebookEntry.put(pricBkEntry.Product2Id, pricBkEntry);
                    }
                    for (Included_Product__c iterateincludedpro: IncludedProductList) {
                    	if(ProductidToPricebookEntry.containsKey(iterateincludedpro.Product__c)){
		                    	if(protIdsTODisp.containsKey(iterateincludedpro.Id)){
		                        	WrapperOfIncludedProductList.add(new WrapperOfIncludedProduct(iterateincludedpro,Bundlequantity,protIdsTODisp.get(iterateincludedpro.Id).Quantity));
		                    	}else{
		                    		WrapperOfIncludedProductList.add(new WrapperOfIncludedProduct(iterateincludedpro,Bundlequantity,0));
		                    	}
		                      
                    	}
                    	else{
                    		missingListIncluded.add(iterateincludedpro.Product__r.Name);
                    		
                    	}
                       
                	}
                	
            	} 
        	} 
        }catch (Exception e) {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,e.getMessage());// 'pricebook and related product prices not matched');
            ApexPages.addmessage(msg); return NULL;      }
        //Display Optional Ad On Products Related to Bundle
        try {
            if (selectedBundleId != NULL && selectedPicebookIds != NULL) {
                Set < Id > productisOfOptionalAdon = new set < Id > ();
                OptionalAdOnProductList = [select id, name,Sort_Order__c, Bundle__c,Default_Description__c,Product__r.Description,Product__c,Product__r.Name from Optional_Ad_Ons__c where Bundle__c = : selectedBundleId order by Sort_Order__c ASC];
                if (OptionalAdOnProductList.size() > 0) {
                	 for (Optional_Ad_Ons__c iterateadOn: OptionalAdOnProductList) {
                	 	productisOfOptionalAdon.add(iterateadOn.Product__c);
                	 }
                	 
                	 for (PricebookEntry pricBkEntry: [SELECT Product2Id,Product2.Description, CurrencyIsoCode,Pricebook2Id, UnitPrice FROM PriceBookEntry WHERE Product2Id IN: productisOfOptionalAdon AND /*CurrencyIsoCode = :opp.CurrencyIsoCode*/  Pricebook2Id=: selectedPicebookIds And IsActive=:true]) {
                    
		                    ProductidToPricebookEntryOfOptionalAdOnProduct.put(pricBkEntry.Product2Id, pricBkEntry);
		                }
                
                    for (Optional_Ad_Ons__c iterateadOn: OptionalAdOnProductList) {
                    	if(ProductidToPricebookEntryOfOptionalAdOnProduct.containsKey(iterateadOn.Product__c)){
                    		string descrip ='';
	                    	if(lstOfOppLineItem.containsKey(iterateadOn.id)){
	                    		descrip=lstOfOppLineItem.get(iterateadOn.id).Description;
	                    	}
	                    	string description ='';
	                    	if(iterateadOn.Bundle__c == opp.primary_bundle__c){
	                    		if(lstOfOppLineItem.containsKey(iterateadOn.id)){
	                    			description =  descrip;
	                    		}else if(iterateadOn.Default_Description__c!=null){
	                    			description = iterateadOn.Default_Description__c;
	                    		}
	                    		else if(iterateadOn.Product__r.Description!=null){
	                    			if(iterateadOn.Product__r.Description.length()>255)
			            				description = iterateadOn.Product__r.Description.substring(0,255);
			            			else
			            				description = iterateadOn.Product__r.Description;
	                    			
	                    		}
	                    	}else{
	                    		if(iterateadOn.Default_Description__c!=null){
	                    			description = iterateadOn.Default_Description__c;
	                    		}
	                    		else if(iterateadOn.Product__r.Description!=null){
	                    			if(iterateadOn.Product__r.Description.length()>255)
			            				description = iterateadOn.Product__r.Description.substring(0,255);
			            			else
			            				description = iterateadOn.Product__r.Description;
	                    			
	                    		}
	                    	}
	                    	
	                    	if(protIdsTODisp.containsKey(iterateadOn.Id)){
	                    		listOfOptionalAdOnWrapper.add(new OptionalAdOnWrapper(iterateadOn,protIdsTODisp.get(iterateadOn.Id).Quantity,protIdsTODisp.get(iterateadOn.Id).UnitPrice,description));
	                		}else{
	                			listOfOptionalAdOnWrapper.add(new OptionalAdOnWrapper(iterateadOn,0,0,description));
	                		}
	                	    
	                	    }
	                    	else{
	                    		missingListOptional.add(iterateadOn.Product__r.Name);
	                    	}
                    }
                  
                }
                
            }
        } catch (Exception e) {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning, e.getMessage());//'pricebook and related  product prices not matched');
            ApexPages.addmessage(msg);
            return NULL;
        }
        
        //Other Products
         try {
            if (selectedBundleId != NULL && selectedPicebookIds != NULL) {
		        //all Products Related To Every Bundle Checkboxchecked  Wrapper
		        set < Id > proids = new Set < Id > ();
		        productList = [select id, Name, Every_Bundle__c, Quantity__c,Description, sales_price__c from Product2 where Every_Bundle__c = TRUE];
		        
		        if (productList.size() > 0) {
		        	for(Product2 iterateproduct: productList){
		        		proids.add(iterateproduct.id);
		        	}
		        	for (PricebookEntry pricBkEntry: [SELECT Product2Id,Product2.Description, Pricebook2Id, UnitPrice FROM PriceBookEntry WHERE Product2Id IN: proids AND /*CurrencyIsoCode = :opp.CurrencyIsoCode*/Pricebook2Id = : selectedPicebookIds ]) {
		                mapToProducts.put(pricBkEntry.Product2Id, pricBkEntry);
		            }
		            for (Product2 iterateproduct: productList) {
		            
		            	if(mapToProducts.containsKey(iterateproduct.Id)){
		            		
		            		string description ='';
			            	if(selectedBundleId == opp.primary_bundle__c){
			            		if(lstOfOppLineItem.containsKey(iterateproduct.id)){
			            			description=lstOfOppLineItem.get(iterateproduct.id).Description;
			            		}else if(iterateproduct.Description!=null){	
			            			if(iterateproduct.Description.length()>255)
			            				description = iterateproduct.Description.substring(0,255);
			            			else
			            				description = iterateproduct.Description;
			            		}
			            	}else if(iterateproduct.Description!=null){
			            			if(iterateproduct.Description.length()>255)
			            				description = iterateproduct.Description.substring(0,255);
			            			else
			            				description = iterateproduct.Description;
			            	}
			            
			            	if(protIdsTODisp.containsKey(iterateproduct.id)){
			                	allProductsEveryBundleCheckboxcheckedList.add(new WrapperOfProducts(iterateproduct,protIdsTODisp.get(iterateproduct.id).Quantity,protIdsTODisp.get(iterateproduct.id).UnitPrice,description));
			            	}else{
			            		allProductsEveryBundleCheckboxcheckedList.add(new WrapperOfProducts(iterateproduct,0,0,description));
			            	}
			                
			                
		            	}
		            	else{
		            		missingListOthers.add(iterateproduct.Name);
		            	}
		            }
		            
		            for (WrapperOfProducts iteratewrap: allProductsEveryBundleCheckboxcheckedList) {
		                iteratewrap.Product.Sales_Price__c = mapToProducts.get(iteratewrap.product.id).UnitPrice;
					}
		        }
		        
            }
            
         }
          catch (Exception e) {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning, 'pricebook and related  product prices not matched');
            ApexPages.addmessage(msg);
            return NULL;
        }
        updateTotal();
        
        //Warning if any products missing pricebook
        if(missingListIncluded.size()>0 || missingListOptional.size()>0 || missingListOthers.size()>0){
        	missing=true;
        	ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning, 'The following products are part of the selected package, but not included here because they do not have a pricebook entry in the chosen pricebook.');
        	ApexPages.addMessage(msg);
        }	
        return NULL;
    }
    public PageReference doupdateAllProductRecords() {
    	
    	
        if (selectedBundleId != NULL && selectedPicebookIds != NULL) {
            opp.Pricebook2Id = selectedPicebookIds;
            opp.primary_bundle__c = selectedBundleId;
            opp.Quantity_of_Primary_Bundle__c = Bundlequantity;
            opp.Package_Description__c = opp.Package_Description__c;
            upsert opp;
        }
        map<Id,OpportunityLineItem> protIdsTODelete = new map<Id,OpportunityLineItem>();
      
         for(OpportunityLineItem oppItem : [Select Id,Description,Quantity,UnitPrice,Included_Product__c,Optional_Ad_Ons__c,Product__c from OpportunityLineItem where OpportunityId = :OpportunityId]){
    	
    		if(oppItem.Included_Product__c !=null){
    			protIdsTODelete.put(oppItem.Included_Product__c,oppItem);
    		}
    		if(oppItem.Optional_Ad_Ons__c!=null){
    			protIdsTODelete.put(oppItem.Optional_Ad_Ons__c,oppItem);
    		}
    		if(oppItem.Product__c !=null){
    			protIdsTODelete.put(oppItem.Product__c,oppItem);}  	}
        List < Optional_Ad_Ons__c > listToUpdateAdOnProducts = new List < Optional_Ad_Ons__c > ();
        List < Product2 > listToUpdateProducts = new List < Product2 > ();
        List < OpportunityLineItem > oppLineItemLists = new List < OpportunityLineItem > ();
        List < OpportunityLineItem > oppLineItemDelLists = new List < OpportunityLineItem > ();
        for (OptionalAdOnWrapper iterateOptionalAdOn: listOfOptionalAdOnWrapper) {
            if (iterateOptionalAdOn.quantity > 0) {
            	if(protIdsTODelete.containsKey(iterateOptionalAdOn.optionaladon.id)){
        			oppLineItemDelLists.add(protIdsTODelete.get(iterateOptionalAdOn.optionaladon.id));
        		}
        		if(ProductidToPricebookEntryOfOptionalAdOnProduct.get(iterateOptionalAdOn.optionaladon.product__c).Pricebook2Id == selectedPicebookIds){
	                OpportunityLineItem OppLineItem = new OpportunityLineItem();
	                OppLineItem.OpportunityId = OpportunityId;
	                OppLineItem.PriceBookEntryId = ProductidToPricebookEntryOfOptionalAdOnProduct.get(iterateOptionalAdOn.optionaladon.product__c).Id;
	                OppLineItem.Quantity = iterateOptionalAdOn.quantity;
	                OppLineItem.UnitPrice = iterateOptionalAdOn.isselected;
	                OppLineItem.Optional_Ad_Ons__c = iterateOptionalAdOn.optionaladon.id;
	                OppLineItem.Description = iterateOptionalAdOn.description;
	                oppLineItemLists.add(OppLineItem);
        		}
            }
            if(iterateOptionalAdOn.quantity ==0){
            	if(protIdsTODelete.containsKey(iterateOptionalAdOn.optionaladon.id)){
        			oppLineItemDelLists.add(protIdsTODelete.get(iterateOptionalAdOn.optionaladon.id));
        		}
            }
        }
        
        
        for (WrapperOfProducts iterateProducts: allProductsEveryBundleCheckboxcheckedList) {
        	
            if (iterateProducts.quantity > 0) {
            	if(protIdsTODelete.containsKey(iterateProducts.product.id)){
        			oppLineItemDelLists.add(protIdsTODelete.get(iterateProducts.product.id));
        		}
        		if(mapToProducts.get(iterateProducts.product.id).Pricebook2Id == selectedPicebookIds){
                	OpportunityLineItem OppLineItem = new OpportunityLineItem();
	                OppLineItem.OpportunityId = OpportunityId;
	                OppLineItem.PriceBookEntryId = mapToProducts.get(iterateProducts.product.id).id;
	               
	                OppLineItem.Quantity = iterateProducts.quantity;
	                OppLineItem.UnitPrice = iterateProducts.productcheckbox;
	                OppLineItem.Product__c = iterateProducts.product.id;
	                OppLineItem.Description = iterateProducts.description;
	                oppLineItemLists.add(OppLineItem);
        		}
            }
            if(iterateProducts.quantity == 0) {
            	if(protIdsTODelete.containsKey(iterateProducts.product.id)){
        			oppLineItemDelLists.add(protIdsTODelete.get(iterateProducts.product.id));
        		}
            }
        }
        
        
      
        for (WrapperOfIncludedProduct iterateIncludedPro: WrapperOfIncludedProductList) {
        	if(protIdsTODelete.containsKey(iterateIncludedPro.includedProduct.id)){
        		oppLineItemDelLists.add(protIdsTODelete.get(iterateIncludedPro.includedProduct.id));
        	}
        	
	            if(ProductidToPricebookEntry.get(iterateIncludedPro.includedProduct.product__c).Pricebook2Id == selectedPicebookIds){
	            	OpportunityLineItem OppLineItem = new OpportunityLineItem();
	            	OppLineItem.OpportunityId = OpportunityId;
	            	PricebookEntry currentOne = ProductidToPricebookEntry.get(iterateIncludedPro.includedProduct.product__c);
	            	OppLineItem.PriceBookEntryId = currentOne.Id;
		           	OppLineItem.Quantity = iterateIncludedPro.includedProduct.Quantity__C* Bundlequantity;
		            OppLineItem.UnitPrice = currentOne.UnitPrice;
		            OppLineItem.Included_Product__c = iterateIncludedPro.includedProduct.id;
		            if(currentOne.Product2.Description !=null)
		            {
		            	if(currentOne.Product2.Description.length()>255)
		            		OppLineItem.Description = currentOne.Product2.Description.substring(0,255);
		            	else
		            		OppLineItem.Description = currentOne.Product2.Description;	
		            }
		             oppLineItemLists.add(OppLineItem);
	            }  
        	
        }
       
       
      
        if (!oppLineItemLists.isEmpty()) {
            upsert oppLineItemLists;
        }
        if(!oppLineItemDelLists.isEmpty()){
        	delete oppLineItemDelLists;
        }
     
       // for (WrapperOfProducts iterateProducts: allProductsEveryBundleCheckboxcheckedList) {
        //		iterateProducts.product.Quantity__c = iterateProducts.product.Quantity__c;
        	//	iterateProducts.product.sales_price__c = iterateProducts.productcheckbox;
              //  listToUpdateProducts.add(iterateProducts.product);
        //}
        if (!listToUpdateProducts.isEmpty()) {
          //  update listToUpdateProducts;
        }
        DisplayRelatedOptionalAdOnProducts();
        return null;
    }

    public class OptionalAdOnWrapper {
        public decimal isselected {get;set;}
        public decimal quantity {get;set;}
        public Optional_Ad_Ons__c optionaladon {get;set;}
        public string description {get;set;}
        public OptionalAdOnWrapper(Optional_Ad_Ons__c optional, Decimal quan,Decimal salePrice,String descp) {
            this.optionaladon = optional;
            this.quantity=quan;
            this.isselected = salePrice;
            this.description = descp;
        }
    }
    public class WrapperOfIncludedProduct {
    	public Decimal QtyCal {get;set;}
        public Included_Product__c includedProduct {get;set;}
        public decimal quan{get;set;}
        public WrapperOfIncludedProduct(Included_Product__c includedPro,Decimal quan,Decimal quantoCal) {
            this.includedProduct = includedPro;
            this.QtyCal = includedPro.Quantity__c*quan;
            this.quan = quantoCal;
        }
    }
    public class WrapperOfProducts {
        public Product2 product {get;set;}
        public decimal quantity {get;set;}
        public Decimal productcheckbox {get;set;}
        public string description{get;set;}
        public WrapperOfProducts(Product2 Pro, Decimal quan,Decimal salePrice,string decp) {
            this.product = Pro;
            this.quantity=quan;
            this.productcheckbox = salePrice;
            this.description = decp;
        }
    }
    public PageReference updateTotal() {
    	string passedParam1 = Apexpages.currentPage().getParameters().get('ProdId');
    	//system.debug(passedParam1);
        Ttotal = 0;
        for (OptionalAdOnWrapper iterateOptionalAdOn: listOfOptionalAdOnWrapper) {
            if (iterateOptionalAdOn.quantity > 0) {
                Ttotal += (iterateOptionalAdOn.isselected * iterateOptionalAdOn.quantity);
            }
        }
        updateTotalOfProducts();
        return null;
    }
    public pageReference methodOne(){
    	for(WrapperOfIncludedProduct iterateIncludedPro: WrapperOfIncludedProductList){
    		iterateIncludedPro.QtyCal = iterateIncludedPro.includedProduct.Quantity__C* Bundlequantity;
    	}
    	updateTotalOfProducts();
		return null;
    }
    public PageReference updateTotalOfProducts() {
    	string passedParam1 = Apexpages.currentPage().getParameters().get('ProdId2');
    	 Ttotal1 = 0;
        for (WrapperOfProducts iterateProducts: allProductsEveryBundleCheckboxcheckedList) {
                Ttotal1 += (iterateProducts.productcheckbox * iterateProducts.quantity);
        }
        return null;
    }
    public pageReference dispProducts(){
    	DisplayRelatedOptionalAdOnProducts();
    	dispNextBtn = false;
    	return null;
    }
    public pageReference clearProducts(){
    	List<OpportunityLineItem> oppItems = new list<OpportunityLineItem>([Select Id from OpportunityLineItem where OpportunityId = : OpportunityId]);
    	try {
    		for(OpportunityLineItem prodList : oppItems){
				
				delete prodList;    			
    		}
		} catch (DmlException e) {
    		ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning, 'There is some problem with starting new Package. Please contact Administrator.');
            ApexPages.addmessage(msg);
            return NULL;
            }	
            return null;
            }
}