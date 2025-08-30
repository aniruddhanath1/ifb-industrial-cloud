public without sharing class LeadController {
    
    
    @AuraEnabled
    public static Id createLead(String leadDataJson) {
        try {
            
            Map<String, Object> leadDataMap = (Map<String, Object>) JSON.deserializeUntyped(leadDataJson);
            
            Lead newLead = new Lead();
            Map<String, Map<String, String>> picklistValues = getPicklistValues();

            if (leadDataMap.containsKey(ConstantUtilities.ACCOUNTTYPE)) {
                newLead.LeadSource = (String.valueOf(leadDataMap.get(ConstantUtilities.ACCOUNTTYPE)) == ConstantUtilities.ACCOUNTTYPE_CUSTOMER) ? ConstantUtilities.LEADSOURCE_EXISTING_EMAIL : (String.valueOf(leadDataMap.get(ConstantUtilities.ACCOUNTTYPE)) == ConstantUtilities.ACCOUNTTYPE_CALL_CENTER_TEAM) ? ConstantUtilities.DOMESTIC_CALL_CENTER_TEAM : leadDataMap.containsKey(ConstantUtilities.LEADSOURCE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEADSOURCE)) : '';
                newLead.Status = String.valueOf(leadDataMap.get(ConstantUtilities.ACCOUNTTYPE)) == ConstantUtilities.ACCOUNTTYPE_PARTNERS ? ConstantUtilities.LEADSTATUS_VALIDATED : ConstantUtilities.LEAD_STATUS_UNVALIDATED;
            }
            else {
                newLead.LeadSource = leadDataMap.containsKey(ConstantUtilities.LEADSOURCE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEADSOURCE)) : '';
                newLead.Status = ConstantUtilities.LEAD_STATUS_UNVALIDATED;
            }

            newLead.validationBypassDate__c = System.now();
            newLead.Lead_Sub_Source__c = leadDataMap.containsKey(ConstantUtilities.LEAD_SUB_SOURCE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_SUB_SOURCE)) : '';
            newLead.Sub_Source_Phone_number__c = leadDataMap.containsKey(ConstantUtilities.LEAD_SUB_SOURCE_PHONE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_SUB_SOURCE_PHONE)) : '';
            newLead.Type_of_Customer__c = leadDataMap.containsKey(ConstantUtilities.LEAD_TYPE_OF_CUSTOMER) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_TYPE_OF_CUSTOMER)) : '';
            newLead.Customer_Segment_Vertical__c = leadDataMap.containsKey(ConstantUtilities.CUSTOMER_SEGMENT_VERTICALS) ? String.valueOf(leadDataMap.get(ConstantUtilities.CUSTOMER_SEGMENT_VERTICALS)) : '';
            newLead.LastName = leadDataMap.containsKey(ConstantUtilities.LEAD_LASTNAME) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_LASTNAME)) : '';
            newLead.FirstName = leadDataMap.containsKey(ConstantUtilities.LEAD_FIRSTNAME) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_FIRSTNAME)) : '';
            newLead.Email = leadDataMap.containsKey(ConstantUtilities.LEAD_EMAIL) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_EMAIL)) : '';
            newLead.Phone = leadDataMap.containsKey(ConstantUtilities.LEAD_PHONE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_PHONE)) : '';
            newLead.Company = leadDataMap.containsKey(ConstantUtilities.LEAD_COMPANY) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_COMPANY)) : '';
            newLead.Product_Category__c = leadDataMap.containsKey(ConstantUtilities.LEAD_PRODUCT_CATEGORY) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_PRODUCT_CATEGORY)) : '';
            newLead.EmployeeID__c = leadDataMap.containsKey(ConstantUtilities.LEAD_EMPLOYEEID) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_EMPLOYEEID)) : '';
            newLead.EmployeeName__c = leadDataMap.containsKey(ConstantUtilities.LEAD_EMPLOYEENAME) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_EMPLOYEENAME)) : '';
            newLead.EmployeeName__c = leadDataMap.containsKey(ConstantUtilities.LEAD_EMPLOYEENAME) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_EMPLOYEENAME)) : '';
            newLead.Description = leadDataMap.containsKey(ConstantUtilities.LEAD_DESCRIPTION) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_DESCRIPTION)) : '';
            newLead.Call_Centre_Remarks__c = leadDataMap.containsKey(ConstantUtilities.LEAD_CALL_CENTRE_REMARKS) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_CALL_CENTRE_REMARKS)) : '';
            newLead.Sector__c = leadDataMap.containsKey(ConstantUtilities.SECTOR) ? String.valueOf(leadDataMap.get(ConstantUtilities.SECTOR)) : '';
            newLead.Sector__c = leadDataMap.containsKey(ConstantUtilities.SECTOR) ? String.valueOf(leadDataMap.get(ConstantUtilities.SECTOR)) : '';
            newLead.Partner_Email__c = leadDataMap.containsKey(ConstantUtilities.PARTNER_EMAIL) ? String.valueOf(leadDataMap.get(ConstantUtilities.PARTNER_EMAIL)) : '';
            newLead.Operation_Parakram__c = leadDataMap.containsKey(ConstantUtilities.OPERATION_PARAKRAM) ? String.valueOf(leadDataMap.get(ConstantUtilities.OPERATION_PARAKRAM)) : '';
            newLead.Bill_To_Name__c = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_NAME) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_NAME)) : '';
            newLead.Street = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_STREET) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_STREET)) : '';
            newLead.City = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_CITY) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_CITY)) : '';
            newLead.State = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_STATE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_STATE)) : '';
            newLead.PostalCode = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_POSTAL_CODE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_POSTAL_CODE)) : '';
            newLead.Country = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_COUNTRY) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_COUNTRY)) : '';
            newLead.Shipping_Address_Same_As_Billing_Address__c = leadDataMap.containsKey(ConstantUtilities.LEAD_IS_SAME_SHIPPING_ADDRESS_AS_BILLING) ? Boolean.valueOf(leadDataMap.get(ConstantUtilities.LEAD_IS_SAME_SHIPPING_ADDRESS_AS_BILLING)) : false;
            if (newLead.Shipping_Address_Same_As_Billing_Address__c == false) {
                newLead.Ship_to_Name__c = leadDataMap.containsKey(ConstantUtilities.LEAD_SHIP_TO_NAME) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_SHIP_TO_NAME)) : '';
                newLead.Shipping__Street__s = leadDataMap.containsKey(ConstantUtilities.LEAD_SHIP_TO_STREET) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_SHIP_TO_STREET)) : '';
                newLead.Shipping__City__s = leadDataMap.containsKey(ConstantUtilities.LEAD_SHIP_TO_CITY) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_SHIP_TO_CITY)) : '';
                newLead.Shipping__StateCode__s = leadDataMap.containsKey(ConstantUtilities.LEAD_SHIP_TO_STATE) ? picklistValues.get(ConstantUtilities.LEAD_SHIP_TO_STATE).get(String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_SHIP_TO_STATE))) : '';
                newLead.Shipping__PostalCode__s = leadDataMap.containsKey(ConstantUtilities.LEAD_SHIP_TO_POSTAL_CODE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_SHIP_TO_POSTAL_CODE)) : '';
                newLead.Shipping__CountryCode__s = leadDataMap.containsKey(ConstantUtilities.LEAD_SHIP_TO_COUNTRY) ? picklistValues.get(ConstantUtilities.LEAD_SHIP_TO_COUNTRY).get(String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_SHIP_TO_COUNTRY))) : '';
            }
            else {
                newLead.Ship_to_Name__c = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_NAME) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_NAME)) : '';
                newLead.Shipping__Street__s = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_STREET) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_STREET)) : '';
                newLead.Shipping__City__s = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_CITY) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_CITY)) : '';
                newLead.Shipping__StateCode__s = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_STATE) ? picklistValues.get(ConstantUtilities.LEAD_BILL_TO_STATE).get(String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_STATE))) : '';
                newLead.Shipping__PostalCode__s = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_POSTAL_CODE) ? String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_POSTAL_CODE)) : '';
                newLead.Shipping__CountryCode__s = leadDataMap.containsKey(ConstantUtilities.LEAD_BILL_TO_COUNTRY) ? picklistValues.get(ConstantUtilities.LEAD_BILL_TO_COUNTRY).get(String.valueOf(leadDataMap.get(ConstantUtilities.LEAD_BILL_TO_COUNTRY))) : '';
            }

            if (leadDataMap.containsKey(ConstantUtilities.NEXT_FOLLOWUP_DATETIME)) {
                
                try {
                    String nextfollowup = ((String) leadDataMap.get(ConstantUtilities.NEXT_FOLLOWUP_DATETIME)).trim()+'UTC';  
                    
                } catch (Exception e) { 
                    throw new AuraHandledException('Invalid DateTime format for Next Follow-Up Date: ' + e.getMessage());
                }
            }
          
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult sr = Database.insert(newLead, dml);
            
            if (sr.isSuccess()) {
                return newLead.Id;
                
            } else {
                throw new AuraHandledException('exceptionText');
            }
            
        }catch (Exception e) {           
            ExceptionHandler.logException('LeadController', 'createLead', e);
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static Map<String, Map<String, String>> getPicklistValues() {
        try{
            Map<String, Map<String, String>> picklistValues = new Map<String, Map<String, String>>();

            Map<String, String> countryMap = new Map<String, String>();
            Schema.DescribeFieldResult countryField = User.Countrycode.getDescribe();
            for (Schema.PicklistEntry entry : countryField.getPicklistValues()) {
                countryMap.put( entry.getLabel(),entry.getValue());
            }
            picklistValues.put(ConstantUtilities.LEAD_COUNTRY, countryMap);
            picklistValues.put(ConstantUtilities.LEAD_BILL_TO_COUNTRY, countryMap);
            picklistValues.put(ConstantUtilities.LEAD_SHIP_TO_COUNTRY, countryMap);
            Map<String, String> stateMap = new Map<String, String>();
            Schema.DescribeFieldResult stateField = User.statecode.getDescribe();
            for (Schema.PicklistEntry entry : stateField.getPicklistValues()) {
                stateMap.put(entry.getLabel(),entry.getValue());
            }
            picklistValues.put(ConstantUtilities.LEAD_STATE, stateMap);
            picklistValues.put(ConstantUtilities.LEAD_BILL_TO_STATE, stateMap);
            picklistValues.put(ConstantUtilities.LEAD_SHIP_TO_STATE, stateMap);
            return picklistValues;
        }
        catch(Exception e){
            ExceptionHandler.logException('LeadController', 'getPicklistValues', e);
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    @AuraEnabled
    public static list<lead> leadDuplicateCheck(String CompanyName,String ProductCategory,String postalCode){
        if (String.isBlank(companyName) || String.isBlank(productCategory) || String.isBlank(postalCode)) {
            throw new IllegalArgumentException('All input parameters must be provided.');
        }

        
        List<Lead> potentialDuplicates = [
            SELECT Id, Name, Company, Product_Category__c, PostalCode 
            FROM Lead
            WHERE Product_Category__c = :productCategory
              AND PostalCode = :postalCode
        ];

        
        List<Lead> duplicateLeads = new List<Lead>();
        for (Lead lead : potentialDuplicates) {
            if (isFuzzyMatch(lead.Company, companyName)) {
                duplicateLeads.add(lead);
            }
        }
        return duplicateLeads;
    }
    @TestVisible
    private static Boolean isFuzzyMatch(String source, String target) {
        if (String.isBlank(source) || String.isBlank(target)) {
            return false;
        }

        Integer levenshteinDistance = getLevenshteinDistance(source.toLowerCase(), target.toLowerCase());
        Integer length = Math.max(source.length(), target.length());

       
        return ((length - levenshteinDistance) / (Decimal)length) >= 0.8;
    }

    private static Integer getLevenshteinDistance(String s1, String s2) {
        if (s1 == null) s1 = '';
    if (s2 == null) s2 = '';

    Integer len1 = s1.length();
    Integer len2 = s2.length();

    List<List<Integer>> dp = new List<List<Integer>>();
    for (Integer i = 0; i <= len1; i++) {
        dp.add(new List<Integer>());
        for (Integer j = 0; j <= len2; j++) {
            dp[i].add(0);
        }
    }

 
    for (Integer i = 0; i <= len1; i++) {
        for (Integer j = 0; j <= len2; j++) {
            if (i == 0) {
                dp[i][j] = j; 
            } else if (j == 0) {
                dp[i][j] = i; 
            } else if (s1.charAt(i - 1) == s2.charAt(j - 1)) {
                dp[i][j] = dp[i - 1][j - 1]; 
            } else {
                dp[i][j] = 1 + Math.min(dp[i - 1][j - 1], 
                                        Math.min(dp[i - 1][j], dp[i][j - 1]));
            }
        }
    }

    return dp[len1][len2];
    }

  @InvocableMethod(label='Lead share' description='Processes a Lead record based on the given Lead ID')
  public static void leadshareRule(List<String> leadIds){

    List<Lead> leadRecords = [SELECT Id, OwnerId,CreatedById,CreatedBy.Name FROM Lead WHERE Id IN :leadIds];

         List<LeadShare> leadSharesToInsert = new List<LeadShare>();

  
    for (Lead leadRecord : leadRecords) {
       
     
        if(leadRecord.OwnerId!=leadRecord.CreatedById ){
         
        LeadShare share = new LeadShare();
                    share.LeadId = leadRecord.Id;
                    share.UserOrGroupId =leadRecord.CreatedById;
                    share.LeadAccessLevel = 'Read';
                    share.RowCause = Schema.LeadShare.RowCause.Manual; 
                    leadSharesToInsert.add(share);
        
        
    }
    
    if (!leadSharesToInsert.isEmpty()) {
        insert leadSharesToInsert;
    }
  }
    }
   
}