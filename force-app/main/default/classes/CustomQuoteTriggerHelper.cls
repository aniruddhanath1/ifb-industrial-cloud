public class CustomQuoteTriggerHelper {
    private static Map<String, Id> quoteRecordTypeMap = new Map<String, Id>();
    private static void loadRecordTypeIds() {
        if (quoteRecordTypeMap.isEmpty()) {
            for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'SBQQ__Quote__c']) {
                quoteRecordTypeMap.put(rt.DeveloperName, rt.Id);
            }
        }
    }
    Public static void handleBeforeInsert(List<SBQQ__QuoteLine__c> newQuoteline){
        for (SBQQ__QuoteLine__c qli : newQuoteLine) {
            if (qli.SBQQ__ContractedPrice__c == null && qli.SBQQ__UnitCost__c>0 ) {
                qli.SBQQ__PricingMethod__c = 'cost';
            }
        } 
    }
    public static void handleAfterInsert(List<SBQQ__QuoteLine__c> newQuoteline)  {  
        loadRecordTypeIds();
        List<Id> quoteLineItemIds = new List<Id>();
        Set<Id> quoteids= new Set<Id>();
        
        // Collect Quote IDs from Quote Lines
        for (SBQQ__QuoteLine__c qli : newQuoteline) {
            if (qli.SBQQ__Quote__c != null) {
                quoteids.add(qli.SBQQ__Quote__c);
            }
        }
        Map<Id,String> quoteToRecordTypeMap = new Map<Id,String>();	
        for(SBQQ__Quote__c quote : [Select Id, RecordType.DeveloperName from SBQQ__Quote__c  where Id IN : quoteids]){
            quoteToRecordTypeMap.put(quote.Id,quote.RecordType.DeveloperName);
        }
        // Collect the record IDs that were inserted or updated
        for (SBQQ__QuoteLine__c qli : newQuoteline) {
            if(quoteToRecordTypeMap.get(qli.SBQQ__Quote__c) != 'Exports'){
                quoteLineItemIds.add(qli.Id);
            }
        }
        
        if (!quoteLineItemIds.isEmpty()) {
            // Prepare the flow input variable (the list of QuoteLineItem IDs)
            Map<String, Object> flowInputs = new Map<String, Object>();
            flowInputs.put('recordId', quoteLineItemIds);
            
            // Call the flow using the Flow API
            Flow.Interview.GstUpdate flowInterview = new Flow.Interview.GstUpdate(flowInputs);
            flowInterview.start();
        }
    }
    
    public static void handleAfterupdate(List<SBQQ__QuoteLine__c> oldQuoteline, List<SBQQ__QuoteLine__c> newQuoteline,Map<Id, SBQQ__QuoteLine__c> oldQuotelineMap, Map<Id, SBQQ__QuoteLine__c> newQuotelineMap)  {  
        List<Id> quoteLineItemIds = new List<Id>();
        Set<Id> quoteids= new Set<Id>();
        // Iterate over the newQuotelineMap to check for changes
        for (Id qliId : newQuotelineMap.keySet()) {
            SBQQ__QuoteLine__c newQli = newQuotelineMap.get(qliId);
            SBQQ__QuoteLine__c oldQli = oldQuotelineMap.get(qliId);
            
            // Collect Quote IDs from Quote Lines
            for (SBQQ__QuoteLine__c qli : newQuoteline) {
                if (qli.SBQQ__Quote__c != null) {
                    quoteids.add(qli.SBQQ__Quote__c);
                }
            }
            Map<Id,String> quoteToRecordTypeMap = new Map<Id,String>();	
            for(SBQQ__Quote__c quote : [Select Id, RecordType.DeveloperName from SBQQ__Quote__c  where Id IN : quoteids]){
                quoteToRecordTypeMap.put(quote.Id,quote.RecordType.DeveloperName);
            }
            
            // Check if UnitPrice or CostUnitPrice has changed
            if (oldQli != null && 
                (oldQli.SBQQ__NetTotal__c != newQli.SBQQ__NetTotal__c)) {
                    
                    if(quoteToRecordTypeMap.get(newQli.SBQQ__Quote__c) != 'Exports'){
                        
                        quoteLineItemIds.add(newQli.Id);
                    }
                }
        }
        
        if (!quoteLineItemIds.isEmpty()) {
            // Prepare the flow input variable (the list of QuoteLineItem IDs)
            Map<String, Object> flowInputs = new Map<String, Object>();
            flowInputs.put('recordId', quoteLineItemIds);
            
            
            // Call the flow using the Flow API
            Flow.Interview.GstUpdate flowInterview = new Flow.Interview.GstUpdate(flowInputs);
            flowInterview.start();
        }
    }
}