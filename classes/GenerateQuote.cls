public class GenerateQuote {
    
    //For the QuotePDFAttachment component
    public String oppIdString;
    public void setOppIdString(String s){
    this.oppIdString =s;
    }
    public String getOppIdString ()
    {
    currentPageId=oppIdString;
    getOpportunityDetails();         
    return this.oppIdString;
    }

    //New Variables
    public Integer currentVersion {get;set;}
    public User u {get;set;}
    public OpportunityContactRole ocr {get;set;}
    public List<stc__c> conList {get;set;}
    
    public id currentPageId{get;set;}
    public Opportunity opp{get;set;}
    public List<OpportunityLineItem> listOfOppLineItem{get;set;}
    public List <Product2> listOfProduct {get;set;}
    
    public List<Included_Product__c> includedProduct{get;set;}
    public Integer ver{get;set;}
    
    public Decimal tot{get;set;}
    public String curencyCode{get;set;}
    
    public List<ProductWrapper> prdWrapper{get;set;}
            
    public GenerateQuote(ApexPages.StandardController controller){
        currentPageId = ApexPages.currentPage().getParameters().get('id');
            getOpportunityDetails();
    }
    public GenerateQuote(){
        
            getOpportunityDetails();
    }
    
    public void getOpportunityDetails(){
        try{
            
        //Custom settings for Standard terms and conditions
        conList = [Select Name,Sort_Order__c,Text__c 
                                    from stc__c where Name like 'Quote Standard Terms & Conditions%' order by Sort_Order__c];   
        
        opp = [SELECT Id, Name, CloseDate, Quote_Date__c, Quote_Expiry_Date__c, OwnerId,
                Sales_Person__c, Sales_Person__r.Name , Sales_Person__r.Email , Sales_Person__r.Phone ,
                AccountId, Account.Name,Account.Account_Manger__r.Name, 
                Account.BillingCity, Account.BillingState,Account.BillingStreet,Account.BillingPostalCode, Account.BillingCountry, 
                Account.ShippingCity,Account.ShippingState,Account.ShippingStreet,Account.ShippingPostalCode,Account.ShippingCountry, 
                primary_bundle__c, primary_bundle__r.Name, Package_Description__c, Quantity_of_Primary_Bundle__c,AttachmentCount__c,  
                Quote_Intro__c,Standard__c,Add_Rep_Quote_T_C__c
                FROM Opportunity WHERE Id =:currentPageId];
        currentVersion=Integer.valueOf(opp.AttachmentCount__c)+1;
        
        listOfOppLineItem = [SELECT Id, Optional_Ad_Ons__c,PricebookEntry.Name, PricebookEntry.CurrencyIsoCode, Description, Product__c, Product__r.Name, Included_Product__c, Quantity, Product_Description__c, UnitPrice, TotalPrice, Opportunity.primary_bundle__r.Name, Opportunity.Package_Description__c, Opportunity.Quantity_of_Primary_Bundle__c, OpportunityId FROM OpportunityLineItem WHERE OpportunityId =:opp.Id];        
        //listOfProduct = [select id, name, Every_Bundle__c, Description, Quantity__c, SW_price__c, Yearly_Subscription__c, Default_PDF_Description__c, sales_price__c from Product2 where Every_Bundle__c = TRUE];
        curencyCode = listOfOppLineItem[0].PricebookEntry.CurrencyIsoCode;
        tot = 0.0;
        
        List<OpportunityLineItem> optionalAddOn = new List<OpportunityLineItem>();
        List<OpportunityLineItem> otherProduct = new List<OpportunityLineItem>();
        List<OpportunityLineItem> includedProduct = new List<OpportunityLineItem>();
        
        for(OpportunityLineItem ol : listOfOppLineItem){
            if(ol.Product__c != NULL){
                otherProduct.add(ol);
            }
            if(ol.Optional_Ad_Ons__c != NULL){
                optionalAddOn.add(ol);
                //system.debug('check *******'+ol);
            }   
            if(ol.Included_Product__c != NULL){
                includedProduct.add(ol);
            }
        }
        
        //system.debug('-----optionalAddOn-----'+optionalAddOn);
        //system.debug('-----otherProduct-----'+otherProduct);
        //system.debug('-----includedProduct-----'+includedProduct);
        
        prdWrapper = new List<ProductWrapper>();
        for(OpportunityLineItem olt : includedProduct){
            tot = olt.TotalPrice + tot;
        }
                
        //for(OpportunityLineItem olt : includedProduct){
        if(includedProduct.size()>0){
            prdWrapper.add(new ProductWrapper(opp.primary_bundle__r.Name, opp.Package_Description__c, opp.Quantity_of_Primary_Bundle__c, tot, tot));
        }
        //}
        for(OpportunityLineItem olt : optionalAddOn){
            prdWrapper.add(new ProductWrapper(olt.PricebookEntry.Name, olt.Description, olt.Quantity, olt.UnitPrice, olt.TotalPrice));
        }
        for(OpportunityLineItem olt : otherProduct){
            prdWrapper.add(new ProductWrapper(olt.PricebookEntry.Name, olt.Description, olt.Quantity, olt.UnitPrice, olt.TotalPrice));
        }           
        
        //Owner details
        u = [Select Id,Remit_Address__c from User where Id=:opp.OwnerId];
        //Primary contact details
        ocr = [Select o.OpportunityId, o.IsPrimary, o.Contact.Name, o.ContactId  From OpportunityContactRole o Where o.IsPrimary=true AND o.OpportunityId=:opp.Id  Limit 1];
        
        
                            
        }
        catch(Exception e){
            //system.debug(e);
        }   
    }
    
    public class ProductWrapper{
        public sObject opl{get;set;}
        
        public String item{get;set;}
        public String description{get;set;}
        public Decimal quantity{get;set;}
        public Decimal rate{get;set;}
        public Decimal total{get;set;}      
        
        public ProductWrapper(String itm, String des, Decimal qty, Decimal rt, Decimal tot){            
            this.item = itm;
            this.description = des;
            this.quantity = qty;
            this.rate = rt;
            this.total = tot;
        }
    }
    
    public pageReference savePDF(){
        Blob body;
        //opp=[Select id, Name, AccountId From Opportunity where id=:ApexPages.currentPage().getParameters().get('id')];
        String oppName = opp.Name;
        List<Attachment> att = [SELECT Id, Name from Attachment WHERE ParentId =:opp.Id AND ContentType NOT IN ('image/png','image/gif','image/jpg','image/jpeg')];
        ver = att.size() + 1;
        PageReference pdfPage =  Page.GenerateQuotePage;
        pdfPage.getParameters().put('id',opp.id);
        pdfPage.setRedirect(true);
        Attachment attach = new Attachment();
        try 
        {
           body = pdfPage.getContent(); 
           //system.debug(body);
        }
        catch (VisualforceException e) 
        {
        body = Blob.valueOf('Some Text');
        }
        attach.Name = opp.Name+'Quote_V' +ver +'.pdf';
        attach.Body =body;
        //attach.IsPrivate = true; 
        attach.ParentId = opp.id;
       
       
         try {
            insert attach;
         
            //update the version no on the Opp 
                opp.AttachmentCount__c=String.valueOf(ver);
                update opp;
        
            
         } catch (Exception e) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error in saving the attachment'));
         }
        
        //return new PageReference('/apex/GenerateQuotePage');
        /*String emailURL = '/_ui/core/email/author/EmailAuthor?&doc_id=' + attach.Id;
        PageReference pp = new PageReference(emailURL);
        pp.setRedirect(true);
        return pp;
        */
        
        //Get org wide address for the contact
        OrgWideEmailAddress[] owea = null;
        if([select count() from OrgWideEmailAddress where Address =: opp.Sales_Person__r.Email] > 0)
            owea = [select Id,DisplayName,Address from OrgWideEmailAddress where Address =: opp.Sales_Person__r.Email];
        
        //Construct email author url
        EmailTemplate et = [Select Id from EmailTemplate where developerName='SendQuotePdf'];
        String url='';
        if(ocr!=null)
            url = '/_ui/core/email/author/EmailAuthor?rtype=003&p2_lkid='+ocr.ContactId+'&p3_lkid='+opp.Id+'&retURL=%2F'+opp.Id+'&template_id='+et.Id+'&new_template=1';
        else
            url = '/_ui/core/email/author/EmailAuthor?rtype=003&p3_lkid='+opp.Id+'&retURL=%2F'+opp.Id+'&template_id='+et.Id+'&new_template=1';
        if(owea!=null){
            url+='&p26='+ owea.get(0).Id;
            
        }       
        
        PageReference ReturnPage;
        ReturnPage = new PageReference(url); 
        return ReturnPage;
    } 

}