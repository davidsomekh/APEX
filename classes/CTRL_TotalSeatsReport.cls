public with sharing class CTRL_TotalSeatsReport {
    
    public List<Reseller> resellers{get;private set;}
    public List<SelectOption> options{get;private set;}
    public Reseller total{get;private set;}
    public map<string,AutomationMail> accountToAutomationMailsMap {get;private set;}
    public string mailText{get;set;}
    public String to{get;set;}
    public String cc{get;set;}
    public String bcc{get;set;}
    public String SelectedReseller{get;set;}
    
    public CTRL_TotalSeatsReport(){
        this(false);
    }
    
    public CTRL_TotalSeatsReport(boolean fromWS){
        if(fromWS){
            init();
        }
        else{
            mailText = '<p>Dear Reseller,</b></p>'+
                '<p>Below you can see a summary of your SolidCAM modules seats and your Subscription %.'+
                '<p>Please make sure to increase substantially the following:'+
                '<ol>'+
                '<li>iMachining 2D/3D seats.'+
                '<li>Subscription rate.'+
                '</ol>'+
                '<p>A customer with <b><u>iMachining</b></u> and <b><u>on subscription</b></u> with our latest version SolidCAM 2015 is a happy customer and potential to buy additional modules and seats.'+
                '<p>Best Regards,'+
                '<br>SolidCAM Team';
            
            resellers = new List<Reseller>();
            init();
            initAccountToAutomationMailsMap();
        }
    }
    
    
    
    
    public void sendEmails(){
        sending(buildEmails());
    }
    
    public void sendOneEmail(){
        sending(new list<Messaging.Singleemailmessage> {buildOneEmail()});
    }
    
    public void sendResellerData(){
        sending(new list<Messaging.Singleemailmessage> {buildResellerEmail()});
    }
    
    public List<Reseller> getTop30Resellers(){
        List<Reseller> rLst = new List<Reseller>();
        for(Integer i=0; (i<resellers.size() && i<30); ++i){
            rLst.add(resellers.get(i));
        }
        return rLst;
    }
    
    private void init(){
        AggregateResult[] groupedResults = [Select Reseller__r.Name, Reseller__c, COUNT(ID), SUM(Number_of_seats__c), SUM(SolidWorks_seats__c), SUM(Inventor_seats__c), SUM(HSM_seats__c), SUM(Sim_5x_seats__c), SUM(HSS_seats__c), SUM(iMachining_seats__c), SUM(iMachining3D_seats__c), SUM(Seats_on_subscription__c), SUM(Xpress_seats__c), SUM(AFRM_seats__c), SUM(Turning_seats__c), SUM(Probe_No__c),SUM(SWISS_seats__c),SUM(MT_seats__c),SUM(Active_Seats__c) 
                                            From Dongle__c                        
                                            Where Modern_CAD__c = TRUE 
                                            Group By Reseller__r.Name, Reseller__c
                                            Order By SUM(Number_of_seats__c) DESC];
        
        options = new List<SelectOption>();
        
        List<String> sub_resellers = new List<String>();
        
        
        
        total = new Reseller();
        for(AggregateResult ag:groupedResults){
            Reseller r = new Reseller(ag);
            resellers.add(r);
            //	options.add(new SelectOption(r.reseller.Name, r.reseller.Name));
            total.addResellerTotal(r);
        }
        
        
        List<Dongle__c> recs_customer = new List<Dongle__c>();
        recs_customer = [Select SubReseller__r.Name, Reseller__r.Name,Customer__r.AccName__c 
                         From Dongle__c                        
                         Where Modern_CAD__c = TRUE ];
        
        Map<String, Integer> map_count = new Map<String, Integer>(); 
        Map<String, Integer> map_dups = new Map<String, Integer>(); 
        
        
        
        
        for (Dongle__c rec : recs_customer) {
            if(rec.SubReseller__c != null && !sub_resellers.contains(rec.SubReseller__r.Name))
            {
                //options.add(new SelectOption(rec.SubReseller__r.Name, rec.SubReseller__r.Name));
                sub_resellers.add(rec.SubReseller__r.Name);
            }
            
            String key = rec.Reseller__r.Name + rec.Customer__r.AccName__c;
            if(!map_dups.containsKey(key))
            {
                map_dups.put(key, 1);
                if(map_count.containsKey(rec.Reseller__r.Name))
                {
                    map_count.put(rec.Reseller__r.Name, map_count.get(rec.Reseller__r.Name) + 1);
                }
                else 
                {
                    map_count.put(rec.Reseller__r.Name,1);			
                }
            }
        }
        sub_resellers.sort();
        for (String sub_reseller_name : sub_resellers) 
        {
            options.add(new SelectOption(sub_reseller_name, sub_reseller_name));
        }
        
        
        Integer iTotal = 0;
        
        for (Reseller row_reseller : resellers) 
        {
            iTotal = iTotal + map_count.get(row_reseller.reseller.Name);
            row_reseller.SetTotalCustomers( map_count.get(row_reseller.reseller.Name));
            
            
            
            String new_name = row_reseller.reseller.Name;
            Pattern nonAlphanumeric = Pattern.compile('\\p{IsHan}');
            Matcher matcher = nonAlphanumeric.matcher(new_name);
            new_name = matcher.replaceAll('');
            row_reseller.setResellerName(new_name);
            
        }
        
        total.SetTotalCustomers(iTotal);
    }
    
    private void initAccountToAutomationMailsMap(){
        accountToAutomationMailsMap = new map<string,AutomationMail>();
        for(Automation_Mails__c tmpAM : [Select To__c, Mail_Subject__c, CC__c, BCC__c, Account__c 
                                         From Automation_Mails__c 
                                         Where Mail_Subject__c includes ('Subscription Status')
                                         limit 1000]){
                                             if(!accountToAutomationMailsMap.containsKey(tmpAM.Account__c)){
                                                 accountToAutomationMailsMap.put(tmpAM.Account__c, new AutomationMail());
                                             }
                                             accountToAutomationMailsMap.get(tmpAM.Account__c).add(tmpAM.To__c,tmpAM.CC__c, tmpAM.BCC__c );
                                         }
        for(Reseller r : resellers){
            if(!accountToAutomationMailsMap.containsKey(r.reseller.Id)){
                accountToAutomationMailsMap.put(r.reseller.Id,new AutomationMail());
            }
        }
    }
    
    private Messaging.Singleemailmessage buildResellerEmail(){
        
        
        String dave ='';
        AggregateResult[] groupedResults = [Select Reseller__c,SubReseller__r.Name,  COUNT(ID), SUM(Number_of_seats__c), SUM(Active_Seats__c), SUM(SolidWorks_seats__c), SUM(Inventor_seats__c), SUM(HSM_seats__c), SUM(Sim_5x_seats__c), SUM(HSS_seats__c), SUM(iMachining_seats__c), SUM(iMachining3D_seats__c), SUM(Seats_on_subscription__c), SUM(Xpress_seats__c), SUM(AFRM_seats__c), SUM(Turning_seats__c), SUM(Probe_No__c),SUM(SWISS_seats__c),SUM(MT_seats__c),SUM(Active_Seats__c)  
                                            From Dongle__c                        
                                            Where Modern_CAD__c = TRUE AND SubReseller__r.Name =: SelectedReseller
                                            Group By SubReseller__r.Name,Reseller__c
                                            Order By SUM(Number_of_seats__c) DESC];
        
        
        List<Dongle__c> recs_customer = new List<Dongle__c>();
        recs_customer = [Select SubReseller__r.Name, Reseller__r.Name,Customer__r.AccName__c 
                         From Dongle__c   
                         
                         Where Modern_CAD__c = TRUE  AND SubReseller__r.Name =: SelectedReseller];
        
        list<string> nat = new list<String>();
        
        list<string> customer_names = new list<String>();
        
        Integer iTotalCustomers = 0;
        
        for (Dongle__c rec : recs_customer) {
            if(!customer_names.contains(rec.Customer__r.AccName__c ))
            {
                iTotalCustomers++;
                customer_names.add(rec.Customer__r.AccName__c );
            }
        }
      	
        nat.add('david.somekh@solidcam.com');
		nat.add('emil.somekh@solidcam.com');
		nat.add('natalie.somekh@solidcam.com');
        nat.add('noah.benezra@solidcam.com');
        string header = htmlHeader();
        string body = header;
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        
        for(AggregateResult ag:groupedResults){
            
            Reseller r = new Reseller(ag);
            r.SetTotalCustomers(iTotalCustomers);
            body = body + htmlRow(r);
            Mail.setToAddresses(nat);
            mail.setCcAddresses(emailList(cc));
            Mail.setSubject(SelectedReseller + ' - SolidCAM seats summary report');
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(body);
        }
        
        
        return mail;
    }
    
    private Messaging.Singleemailmessage buildOneEmail(){
        list<string> nat = new list<String>();
        nat.add('noah.benezra@solidcam.com');
        nat.add('natalie.somekh@solidcam.com');
		nat.add('emil.somekh@solidcam.com');
		nat.add('shelly.dahan@solidcam.com');
        string header = htmlHeader();
        string body = header;
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        integer iCont = 0;
        for(Reseller r : resellers)
        {
            iCont++;
            if(iCont == 1)
                body = body + TotalRow(total);
            
            mail.setToAddresses(nat);
            mail.setCcAddresses(emailList(cc)
                               );
            body = body + htmlRow(r);
            mail.setSubject('SolidCAM seats summary report');
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(body); 
            
        }
        return mail;
    }
    
    private list<Messaging.Singleemailmessage> buildEmails(){
        string header = htmlHeader();
        list<Messaging.Singleemailmessage> mails = new list<Messaging.Singleemailmessage>();
        for(Reseller r : resellers) {
            if(r.sendEmail){
                if(accountToAutomationMailsMap.get(r.reseller.Id).isEmpty()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No mail automation rule defined for ' + r.reseller.Name));
                    continue;
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>(accountToAutomationMailsMap.get(r.reseller.Id).to));
                mail.setCcAddresses(new List<String>(accountToAutomationMailsMap.get(r.reseller.Id).cc));
                mail.setBccAddresses(new List<String>(accountToAutomationMailsMap.get(r.reseller.Id).bcc));
                string body = header + htmlRow(r);
                mail.setSubject(r.reseller.Name + ' SolidCAM seats summary report');
                mail.setSaveAsActivity(false);
                mail.setHtmlBody(body); 
                mails.add(mail);
            }
        }
        return mails;
    }
    
    private void sending(list<Messaging.Singleemailmessage> mails){
        try{
            list<Messaging.SendEmailResult> results = Messaging.sendEmail(mails);
            Integer mailCount = 0;
            string errorMsg = '';
            for(Messaging.SendEmailResult result : results){
                if(result.isSuccess()){
                    mailCount++;
                }
                else{
                    errorMsg += result.getErrors()[0].getMessage();
                }
            }
            if(mailCount > 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'You sent ' + mailCount + ' Email' + (mailCount > 1 ? 's.' : '.')));
            }
            if(errorMsg.length() > 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMsg));
            }
        }catch(Exception ex){ ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage())); }
    }
    
    private string htmlHeader(){
        return '<div style="font-family: Calibri !important; color: black;">'+
            '<table cellspacing="0" cellpadding="2" border="1" style="color: black; font-family: Calibri,sans-serif!important;">'+
            '<thead>'+
            '<tr bgcolor="#8DB4E2">'+	
            '<th>Reseller</th>'+
            '<th>Seats</th>'+
            '<th>Seats (4Y SUBS)</th>'+
            '<th>Customers</th>'+
            '<th>SW</th>'+
            '<th>IV</th>'+
            '<th>Xpress</th>'+
            '<th>AFRM</th>'+
            '<th>HSM</th>'+
            '<th>5X</th>'+
            '<th>HSS</th>'+
            '<th>Turn</th>'+
            '<th>MillTurn</th>'+
            '<th>Swiss</th>'+
            '<th>Probe</th>'+
            '<th>iMach 2D</th>'+
            '<th>iMach 2D %</th>'+
            '<th>iMach 3D</th>'+
            '<th>iMach 3D %</th>'+
            '<th>SUBS</th>'+
            '<th>SUBS %</th>'+
            '<th>Active SUBS % (4Y SUBS)</th>'+
            '</tr>'+
            '</thead>';
    }
    
    private string TotalRow(Reseller row){
        return '<tbody>'+
            '<tr style="background:#818290; color: white; font-weight: bold; font-family: Calibri,sans-serif!important;">'+
            '<td>'+row.reseller.Name+'('+row.nbRecords+((row.nbRecords > 1)? ' Records)</td>' : ' Record)</td>')+
            '<td align="center">'+row.nbOfSeats.format()+'</td>'+
            '<td align="center">'+row.nbOfactiveSeats.format()+'</td>'+
            '<td align="center">'+row.iTotalCustomers.format()+'</td>'+
            '<td align="center">'+row.nbSolidWorksSeats.format()+'</td>'+
            '<td align="center">'+row.nbInventorSeats.format()+'</td>'+
            '<td align="center">'+row.nbSeatXpress.format()+'</td>'+
            '<td align="center">'+row.nbSeatAFRM.format()+'</td>'+
            '<td align="center">'+row.nbHSMSeats.format()+'</td>'+
            '<td align="center">'+row.nbSim5xSeats.format()+'</td>'+
            '<td align="center">'+row.nbHSSSeats.format()+'</td>'+
            '<td align="center">'+row.nbSeatTurning.format()+'</td>'+
            '<td align="center">'+row.iMTSeats.format()+'</td>'+
            '<td align="center">'+row.iSwissSeats.format()+'</td>'+
            '<td align="center">'+row.nbSeatProbe.format()+'</td>'+
            '<td align="center">'+row.nbIMachining2DSeats.format()+'</td>'+
            '<td align="center">'+row.getIMachining2DPerc().setscale(2)+'</td>'+
            '<td align="center">'+row.nbIMachining3DSeats.format()+'</td>'+
            '<td align="center">'+row.getIMachining3DPerc().setscale(2)+'</td>'+
            '<td align="center">'+row.nbSeatsOnSubscription.format()+'</td>'+
            '<td align="center">'+row.getTotalSubscriptionPerc().setscale(2)+'</td>'+
            '<td align="center">'+row.getSubscriptionPerc().setscale(2)+'</td>'+
            '</tr>';
    }
    
    
    private string htmlRow(Reseller row){
        return '<tbody>'+
            '<tr style="background:#ddd9c4; font-family: Calibri,sans-serif!important;">'+
            '<td><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+row.reseller.Id+'">'+row.reseller.Name+'</a> ('+row.nbRecords+((row.nbRecords > 1)? ' Records)</td>' : ' Record)</td>')+
            '<td align="center">'+row.nbOfSeats.format()+'</td>'+
            '<td align="center">'+row.nbOfactiveSeats.format()+'</td>'+
            '<td align="center">'+row.iTotalCustomers.format()+'</td>'+            
            '<td align="center">'+row.nbSolidWorksSeats.format()+'</td>'+
            '<td align="center">'+row.nbInventorSeats.format()+'</td>'+
            '<td align="center">'+row.nbSeatXpress.format()+'</td>'+
            '<td align="center">'+row.nbSeatAFRM.format()+'</td>'+
            '<td align="center">'+row.nbHSMSeats.format()+'</td>'+
            '<td align="center">'+row.nbSim5xSeats.format()+'</td>'+
            '<td align="center">'+row.nbHSSSeats.format()+'</td>'+
            '<td align="center">'+row.nbSeatTurning.format()+'</td>'+
            '<td align="center">'+row.iMTSeats.format()+'</td>'+
            '<td align="center">'+row.iSwissSeats.format()+'</td>'+
            '<td align="center">'+row.nbSeatProbe.format()+'</td>'+
            '<td align="center">'+row.nbIMachining2DSeats.format()+'</td>'+
            '<td align="center">'+row.getIMachining2DPerc().setscale(2)+'</td>'+
            '<td align="center">'+row.nbIMachining3DSeats.format()+'</td>'+
            '<td align="center">'+row.getIMachining3DPerc().setscale(2)+'</td>'+
            '<td align="center">'+row.nbSeatsOnSubscription.format()+'</td>'+
            '<td align="center">'+row.getTotalSubscriptionPerc().setscale(2)+'</td>'+
            '<td align="center">'+row.getSubscriptionPerc().setscale(2)+'</td>'+
            '</tr>';
    }
    
    private list<string> emailList (string emails){
        list<String> returnList = new list<String>();
        if(String.isEmpty(emails)){
            return returnList;
        }
        for(string email : emails.split(',|;')){
            if(ApexUtils.is_valid_email_address(email.deleteWhitespace())){
                returnList.add(email.deleteWhitespace());
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'ERROR: wrong email - ' + email));
            }
        }
        return returnList;
    }
    
    public class AutomationMail{
        public set<string> to{get; set;}
        public set<string> cc{get; set;}
        public set<string> bcc{get; set;}
        
        public AutomationMail(){
            to = new set<string>();
            cc = new set<string>();
            bcc = new set<string>();
        }
        
        public void add(string to,string cc,string bcc){
            this.to.addAll(ApexUtils.text_get_mails_to_send(to));
            this.cc.addAll(ApexUtils.text_get_mails_to_send(cc));
            this.bcc.addAll(ApexUtils.text_get_mails_to_send(bcc));
        }
        
        public boolean isEmpty(){
            if(to.isEmpty() && cc.isEmpty() && bcc.isEmpty())
                return true;
            else
                return false;
        }
    }
    
    public class Reseller{
        public Account reseller{get; private set;}
        public Integer nbRecords{get;private set;}
        public Integer nbOfSeats{get;private set;}
        public Integer nbOfActiveSeats{get;private set;}
        public Integer nbSolidWorksSeats{get;private set;}
        public Integer nbInventorSeats{get;private set;}
        public Integer nbHSMSeats{get;private set;}
        public Integer nbSim5xSeats{get;private set;}
        public Integer nbHSSSeats{get;private set;}
        public Integer nbIMachining2DSeats{get;private set;}
        public Integer nbIMachining3DSeats{get;private set;}
        public Integer nbSeatsOnSubscription{get;private set;}
        public Boolean sendEmail{get;set;}
        public Integer nbSeatXpress{get;private set;}
        public Integer nbSeatAFRM{get;private set;}
        public Integer nbSeatTurning{get;private set;}
        public Integer nbSeatProbe{get;private set;}
        public Integer iTotalCustomers{get;private set;}
        public Integer iSwissSeats{get;private set;}
        public Integer iMTSeats{get;private set;}
        
        public Reseller(AggregateResult ar){
            
            reseller = new Account(name = (String)(ar.get('Name')), Id=(Id)(ar.get('Reseller__c')));
            nbRecords = Integer.valueOf(ar.get('expr0'));
            nbOfSeats = Integer.valueOf(ar.get('expr1'));
            nbSolidWorksSeats = Integer.valueOf(ar.get('expr2'));
            nbInventorSeats = Integer.valueOf(ar.get('expr3'));
            nbHSMSeats = Integer.valueOf(ar.get('expr4'));
            nbSim5xSeats = Integer.valueOf(ar.get('expr5'));
            nbHSSSeats = Integer.valueOf(ar.get('expr6'));
            nbIMachining2DSeats = Integer.valueOf(ar.get('expr7'));
            nbIMachining3DSeats = Integer.valueOf(ar.get('expr8'));
            nbSeatsOnSubscription = Integer.valueOf(ar.get('expr9'));
            nbSeatXpress = Integer.valueOf(ar.get('expr10'));
            nbSeatAFRM = Integer.valueOf(ar.get('expr11'));
            nbSeatTurning = Integer.valueOf(ar.get('expr12'));
            nbSeatProbe = Integer.valueOf(ar.get('expr13'));
            iSwissSeats = Integer.valueOf(ar.get('expr14'));
            iMTSeats = Integer.valueOf(ar.get('expr15'));
            nbOfActiveSeats = Integer.valueOf(ar.get('expr16'));
            sendEmail = false;
            iTotalCustomers = 0;
        }
        
        public Reseller(){
            reseller =  new Account(name='Grand Total');
            nbRecords = 0;
            nbOfSeats = 0;
            nbSolidWorksSeats = 0;
            nbInventorSeats = 0;
            nbHSMSeats = 0;
            nbSim5xSeats = 0;
            nbHSSSeats = 0;
            nbIMachining2DSeats = 0;
            nbIMachining3DSeats = 0;
            nbSeatsOnSubscription = 0;
            nbSeatXpress = 0;
            nbSeatAFRM = 0;
            nbSeatTurning = 0;
            nbSeatProbe = 0;
            iSwissSeats = 0;
            iMTSeats = 0;
            nbOfActiveSeats = 0;
            sendEmail = false;
        }
        
        public void addResellerTotal(Reseller r){
            nbRecords += r.nbRecords;
            nbOfSeats += r.nbOfSeats;
            nbSolidWorksSeats += r.nbSolidWorksSeats;
            nbInventorSeats += r.nbInventorSeats;
            nbHSMSeats += r.nbHSMSeats;
            nbSim5xSeats += r.nbSim5xSeats;
            nbHSSSeats += r.nbHSSSeats;
            nbIMachining2DSeats += r.nbIMachining2DSeats;
            nbIMachining3DSeats += r.nbIMachining3DSeats;
            nbSeatsOnSubscription += r.nbSeatsOnSubscription;
            nbSeatXpress += r.nbSeatXpress;
            nbSeatAFRM += r.nbSeatAFRM;
            nbSeatTurning += r.nbSeatTurning;
            nbSeatProbe += r.nbSeatProbe;
            iSwissSeats += r.iSwissSeats;
            iMTSeats += r.iMTSeats;
            nbOfActiveSeats += r.nbOfActiveSeats;
        }
        
        public void SetTotalCustomers(Integer iTotal)
        {
            iTotalCustomers = iTotal;
        }
        
        public void setResellerName(String Name)
        {
            reseller.name = Name;
        }
        
        public Decimal getSubscriptionPerc(){
            if(nbSeatsOnSubscription > 0 && nbOfActiveSeats > 0){
                return (Decimal)(nbSeatsOnSubscription*100/nbOfActiveSeats);
            }
            else{
                return 0;
            }
        }
        
        public Decimal getIMachining2DPerc(){
            return (Decimal)nbIMachining2DSeats*100/nbOfSeats;
        }
        
        public Decimal getIMachining3DPerc(){
            return (Decimal)nbIMachining3DSeats*100/nbOfSeats;
        }
        
        public Decimal getTotalSubscriptionPerc(){
           if(nbSeatsOnSubscription > 0 && nbOfSeats > 0){
                return (Decimal)(nbSeatsOnSubscription*100/nbOfSeats);
            }
            else{
                return 0;
            }
        }
       
        public void addXmlToNode(Dom.XmlNode parentNode){
            Dom.XmlNode resellerNode = parentNode.addChildElement('Reseller',null,null);
            resellerNode.addChildElement('Name',null,null).addTextNode(reseller.Name);
            resellerNode.addChildElement('Seats',null,null).addTextNode(nbOfSeats.format());
            resellerNode.addChildElement('Active_Seats',null,null).addTextNode(nbOfActiveSeats.format());
            resellerNode.addChildElement('SolidWorks',null,null).addTextNode(nbSolidWorksSeats.format());
            resellerNode.addChildElement('Inventor',null,null).addTextNode(nbInventorSeats.format());
            resellerNode.addChildElement('Xpress',null,null).addTextNode(nbSeatXpress.format());
            resellerNode.addChildElement('AFRM',null,null).addTextNode(nbSeatAFRM.format());
            resellerNode.addChildElement('HSM',null,null).addTextNode(nbHSMSeats.format());
            resellerNode.addChildElement('Sim5X',null,null).addTextNode(nbSim5xSeats.format());
            resellerNode.addChildElement('HSS',null,null).addTextNode(nbHSSSeats.format());
            resellerNode.addChildElement('Turning',null,null).addTextNode(nbSeatTurning.format());
            resellerNode.addChildElement('Probe',null,null).addTextNode(nbSeatProbe.format());
            resellerNode.addChildElement('iMachining2D',null,null).addTextNode(nbIMachining2DSeats.format());
            resellerNode.addChildElement('iMachining2D_Percent',null,null).addTextNode(String.valueOf(getIMachining2DPerc().setscale(2)));
            resellerNode.addChildElement('iMachining3D',null,null).addTextNode(nbIMachining3DSeats.format());
            resellerNode.addChildElement('iMachining3D_Percent',null,null).addTextNode(String.valueOf(getIMachining3DPerc().setscale(2)));
            resellerNode.addChildElement('Subscription',null,null).addTextNode(nbSeatsOnSubscription.format());
            resellerNode.addChildElement('Total_Subscription_Percent',null,null).addTextNode(nbSeatsOnSubscription.format());
            resellerNode.addChildElement('Subscription_Percent',null,null).addTextNode(String.valueOf(getSubscriptionPerc().setscale(2)));
        }
    }
    
}