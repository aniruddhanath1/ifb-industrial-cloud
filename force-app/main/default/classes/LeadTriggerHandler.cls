public class LeadTriggerHandler implements InterfaceTriggerHandler{
    public void beforeInsert(List<Lead> newLeads) {
        List<Lead> leadsToCheckPhoneNumber = new List<Lead>();
        Map<String, Map<String, String>> picklistValues = LeadController.getPicklistValues();
        for(Lead leadRecord : newLeads){
            if(leadRecord.CountryCode == ConstantUtilities.COUNTRY_CODE_IN && leadRecord.Lead_Sub_Source__c != ConstantUtilities.SOURCE_EXPORT_AGENCY && leadRecord.ValidationBypass__c==false){
                leadsToCheckPhoneNumber.add(leadRecord);
            }
            if(leadRecord.Shipping__StateCode__s!=null){
                if (picklistValues.containsKey(leadRecord.Shipping__StateCode__s)) {
                    String StateName=picklistValues.get(ConstantUtilities.LEAD_STATE).get(leadRecord.Shipping__StateCode__s);
                    leadRecord.Shipping__StateCode__s =StateName;
                    
                }  
            }
            if(leadRecord.Shipping__CountryCode__s!=null){
                if (picklistValues.containsKey(leadRecord.Shipping__CountryCode__s)) {
                    String CountryName=picklistValues.get(ConstantUtilities.LEAD_COUNTRY).get(leadRecord.Shipping__CountryCode__s);
                    leadRecord.Shipping__CountryCode__s =CountryName ;
                }
            }   
        }
        if(leadsToCheckPhoneNumber.size() >0){
            Utilities.checkPhoneOrSTDcodeForSObjects(leadsToCheckPhoneNumber);
        }
        
    }
    public void beforeUpdate(List<Lead> oldLeads, List<Lead> newLeads, Map<ID, SObject> oldLeadMap, Map<ID, SObject> newLeadMap) {
        List<Lead> leadsToCheckPhoneNumber = new List<Lead>();
        for(Lead leadRecord : newLeads){
            Lead oldLead = (Lead) Trigger.OldMap.get(leadRecord.Id);
            if(leadRecord.CountryCode == ConstantUtilities.COUNTRY_CODE_IN ){
                if((leadRecord.Phone != null && leadRecord.Phone != oldLead.phone) || (leadRecord.Phone == oldLead.phone)){
                    leadsToCheckPhoneNumber.add(leadRecord);  
                } 
            }
        }
        if(leadsToCheckPhoneNumber.size() >0){
            Utilities.checkPhoneOrSTDcodeForSObjects(leadsToCheckPhoneNumber);
        }
    }
    public void beforeDelete(List<Lead> oldLeads, Map<ID, SObject> oldLeadMap) {
        
    }
    public void afterInsert(List<Lead> newLeads, Map<ID, SObject> newLeadMap) {
        try{
            Set<String> companyNames = new Set<String>();
            Set<String> locations = new Set<String>();
            List<Id> leadIDForSyncList = new List<Id>();
            List<Lead> mergedList = new List<Lead>(); 
            Set<String> leadCompanyNameSet = new Set<String>();
            Set<String> leadProductSet = new Set<String>();
            Set<String> leadShippingPostalSet = new Set<String>(); 
            
            for (Lead lead : newLeads) {
                if (lead.Company != null && lead.PostalCode != null) {
                    companyNames.add(lead.Company);
                    locations.add(lead.PostalCode);
                }
                if((System.label.Lead_Sources_For_Lead_Sync).split(';').contains(lead.LeadSource)
                   && (lead.Status == ConstantUtilities.LEAD_STATUS_UNVALIDATED
                       || lead.Customer_Category__c == ConstantUtilities.CUSTOMER_CATEGORY_DOMESTIC)){
                           leadIDForSyncList.add(lead.id);
                       }
            }
            List<Account> accountList = new List<Account>();
            if (!companyNames.isEmpty() && !locations.isEmpty()) {
                accountList = [
                    SELECT Id, BillingPostalCode, Name,RecordType.DeveloperName
                    FROM Account 
                    WHERE Name IN :companyNames 
                    AND BillingPostalCode IN :locations
                ];
            }
            List<Account> NotProvisionalAccount = new List<Account>();
            for(Account ac : accountList){
                if(ac.RecordType.DeveloperName != ConstantUtilities.PROVISIONAL_ACCOUNT){
                    NotProvisionalAccount.add(ac);
                }
            }
            Map<String, Account> accountMap = new Map<String, Account>();
            for (Account acc : NotProvisionalAccount) {
                String key = acc.Name + ':' + acc.BillingPostalCode;
                accountMap.put(key, acc);
            }
            List<Lead> duplicatesLeadsWithAccount = new List<Lead>();
            for(Lead led : newLeads){
                String key = led.Company + ':' + led.PostalCode;
                if(accountMap.containsKey(key)){
                    duplicatesLeadsWithAccount.add(led);
                }
            }
            for(Lead leadObject: newLeads){
                if( leadObject.Company != null && leadObject.Product_Category__c != null && leadObject.PostalCode != null ){  
                    leadCompanyNameSet.add(leadObject.Company);
                    leadProductSet.add(leadObject.Product_Category__c);
                    leadShippingPostalSet.add(leadObject.PostalCode);
                }
            }	 
            if(!leadCompanyNameSet.isEmpty()   && !leadProductSet.isEmpty() && !leadShippingPostalSet.isEmpty()){
                mergedList = LeadTriggerHelper.leadsMergeMethod(leadCompanyNameSet, leadProductSet, leadShippingPostalSet);
            }
            if(!duplicatesLeadsWithAccount.isEmpty()){
                LeadTriggerHelper.opportunityCreation(duplicatesLeadsWithAccount,accountMap);    
            }
            if(!mergedList.isEmpty()){
                LeadTriggerHelper.opportunityCreation(mergedList, accountMap);
            }  
        }
        catch(Exception e){
            ExceptionHandler.logException('LeadTriggerHandler', 'afterInsert',e); 	   
        }
    }
    public void afterUpdate(List<Lead> oldLeads, List<Lead> newLeads, Map<ID, SObject> oldLeadMap, Map<ID, SObject> newLeadMap) {
        try{
            List<Id> leadIDForSyncList = new List<Id>();
            String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
            for (Lead lead : newLeads) {
                if((System.label.Lead_Sources_For_Lead_Sync).split(';').contains(lead.LeadSource)
                   && (System.label.Profiles_To_Send_Update_From).split(';').contains(profileName)
                   && (lead.Status != (((Map<Id,Lead>)oldLeadMap).get(lead.id)).status
                       || lead.Customer_Category__c == ConstantUtilities.CUSTOMER_CATEGORY_DOMESTIC)){
                           leadIDForSyncList.add(lead.id);
                       } 
            }
        }
        catch(Exception e){
            ExceptionHandler.logException('LeadTriggerHandler', 'afterUpdate', e);
        }
    }
    public void afterDelete(List<Lead> oldLeads, Map<ID, SObject> oldLeadMap) {
        
    }
    
    public void afterUndelete(List<Lead> newLeads, Map<ID, SObject> newLeadMap) {
        
    }
}