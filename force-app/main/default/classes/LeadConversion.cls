public class LeadConversion {
    public class LeadConversionInput {
        @InvocableVariable(required=true)
        public Id leadId;
        @InvocableVariable
        public Id accountId;
        @InvocableVariable
        public Id contactId;
        @InvocableVariable
        public Id opportunityId;
        @InvocableVariable
        public Boolean doNotCreateOpportunity;
    }
    public class LeadConversionOutput {
        @InvocableVariable
        public Boolean success;
        @InvocableVariable
        public String errorMessage;
        @InvocableVariable
        public Id accountId;
        @InvocableVariable
        public Id contactId;
        @InvocableVariable
        public Id opportunityId;
    }
    @InvocableMethod(label='Convert Lead' description='Converts a Lead into an Account, Contact, and optionally an Opportunity')
    public static List<LeadConversionOutput> convertLeads(List<LeadConversionInput> request) {
        try{
            List<LeadConversionOutput> results = new List<LeadConversionOutput>();
            Lead lead = new Lead();
            Set<Id> leadIds = new Set<Id>();
            for (LeadConversionInput input : request) {
                if (input.leadId != null) {
                    leadIds.add(input.leadId);
                }
            }
            if(leadIds!=null||!leadIds.isEmpty()){
                lead = [
                    SELECT Id, Product_Category__c,Type_of_Setup__c, LeadSource, Purchase_Timeline__c, 
                    Budget_Availablility_Budget_Source__c, Site_Suitability__c, Export_Agency_Name__c,Name_and_Place_of_the_Event__c,Name_of_Customer__c,
                    Space_Availability__c, Infrastructure_completed_in_30_days__c, Lead_Source_Direct_Lead__c,
                    Rating, Company, ConvertedAccountId, Operation_Parakram__c,OwnerId,Shipping__City__s,Shipping__PostalCode__s,Shipping__CountryCode__s,Shipping__StateCode__s,Shipping__Street__s,Budgetary_Quote__c
                    FROM Lead 
                    WHERE Id IN :leadIds
                ];
                lead.validationBypassDate__c = system.now();
                update lead;
            }
            else{
                throw new AuraHandledException('exceptionText');
            }
            for (LeadConversionInput input : request) {
                LeadConversionOutput output = new LeadConversionOutput();
                if (input == null) {
                    throw new IllegalArgumentException('LeadConversionInput cannot be null');
                }
                
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(input.leadId);
                if (input.accountId != null) {
                    lc.setAccountId(input.accountId);
                }
                if (input.contactId != null) {
                    lc.setContactId(input.contactId);
                }
                lc.setDoNotCreateOpportunity(true);
                lc.setConvertedStatus(ConstantUtilities.LEAD_STATUS);
                
                Database.LeadConvertResult result = Database.convertLead(lc);
                
                if (result.isSuccess()) {
                    output.success = true;
                    output.errorMessage = null;
                    output.accountId = result.getAccountId();
                    output.contactId = result.getContactId();
                    output.opportunityId = result.getOpportunityId();
                    leadTriggerHelper.handleProductCategoryForOpportunity(lead,output.accountId);
                } else {
                    output.success = false;
                    output.errorMessage = result.getErrors()[0].getMessage();
                }
                
                results.add(output);
            }
            return results;
            
        }
        catch(Exception e){
            ExceptionHandler.logException('LeadConversion', 'convertLeads', e);
            return null;
        }
        
    }
    
}