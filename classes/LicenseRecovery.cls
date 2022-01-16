@isTest
public with sharing class LicenseRecovery {

    public Dongle__c m_record {get;set;}

    static testMethod void myTest() {

        

        //LicenseRecovery lic = new LicenseRecovery();
        //lic.Process();
    
        
      }

    

    public LicenseRecovery (Apexpages.Standardcontroller ctrl){

        m_record = (Dongle__c)ctrl.getRecord();
    }

  
    
    
    
}