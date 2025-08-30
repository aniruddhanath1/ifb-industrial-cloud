public class OpportunityTriggerHelper {
    public static void handleBeforeInsert(List<Opportunity> newOpportunities) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        
        Map<Id, Account> accountsMap = new Map<Id, Account>(
            [SELECT Id, CurrencyIsoCode FROM Account WHERE Id IN :accountIds]
        );
        
        for (Opportunity opp : newOpportunities) {
            if (opp.AccountId != null && accountsMap.containsKey(opp.AccountId) && accountsMap.get(opp.AccountId).CurrencyIsoCode != null) {
                opp.CurrencyIsoCode = accountsMap.get(opp.AccountId).CurrencyIsoCode;
            }
        }
        Set<String> productCategoryAPINames = new Set<String>();
        for (Opportunity opp : newOpportunities) {
            if (opp.Product_Category__c != null) {
                productCategoryAPINames.add(opp.Product_Category__c);
            }
        }
        Map<String, Id> apiNameToPricebookIdMap = new Map<String, Id>();
        Map<String, String> apiNameToLabelMap = ConstantUtilities.CATEGORY_TO_PRICEBOOK_NAME_MAP;
        Map<String, String> labelToApiNameMap = new Map<String, String>();
        for (String apiName : apiNameToLabelMap.keySet()) {
            labelToApiNameMap.put(apiNameToLabelMap.get(apiName), apiName);
        }
        if (!labelToApiNameMap.isEmpty()) {
            List<Pricebook2> pricebooks = [
                SELECT Id, Name
                FROM Pricebook2
                WHERE Name IN :labelToApiNameMap.keySet()
            ];
            for (Pricebook2 pb : pricebooks) {
                if (labelToApiNameMap.containsKey(pb.Name)) {
                    String apiName = labelToApiNameMap.get(pb.Name);
                    apiNameToPricebookIdMap.put(apiName, pb.Id);
                }
            }
        }
        for (Opportunity opp : newOpportunities) {
            if (opp.Product_Category__c != null && apiNameToPricebookIdMap.containsKey(opp.Product_Category__c)) {
                Id pricebookId = apiNameToPricebookIdMap.get(opp.Product_Category__c);
                opp.Pricebook2Id = pricebookId;
                opp.SBQQ__QuotePricebookId__c = pricebookId;
            }
        }
    }
    public static void handleBeforeUpdate(List<Opportunity> newOpportunityList, Map<Id, Opportunity> oldOpportunityMap) {
        try {
            Set<Id> opportunityIds = new Set<Id>();
            Map<Id, SBQQ__Quote__c> validQuoteMap = new Map<Id, SBQQ__Quote__c>();
            for (Opportunity opp : newOpportunityList) {
                if (opp.StageName == ConstantUtilities.OPPORTUNITY_CLOSEWON && oldOpportunityMap.get(opp.Id).StageName != ConstantUtilities.OPPORTUNITY_CLOSEWON) {
                    opportunityIds.add(opp.Id);
                }
            }
            if (opportunityIds.isEmpty()) {
                return;
            }
            for (SBQQ__Quote__c quote : [SELECT Id, SBQQ__Opportunity2__c, SBQQ__Primary__c, SBQQ__Status__c, ExpiredQuotes__c, Customer_Quote_Approval__c
                                         FROM SBQQ__Quote__c
                                         WHERE SBQQ__Opportunity2__c IN :opportunityIds 
                                         and ExpiredQuotes__c = FALSE and SBQQ__Primary__c = TRUE and SBQQ__Status__c = :ConstantUtilities.QUOTE_APPROVED 
                                         and Customer_Quote_Approval__c = :ConstantUtilities.QUOTE_CUSTOMER_ACCEPTED
                                        ]){
                                            validQuoteMap.put(quote.SBQQ__Opportunity2__c, quote);
                                        }
            for (Opportunity opp : newOpportunityList) {
                if (opp.StageName == ConstantUtilities.OPPORTUNITY_CLOSEWON && !validQuoteMap.containsKey(opp.Id)) {
                    opp.addError(ConstantUtilities.OPPORTUNITY_CLOSEWON_ERROR);
                }
            }
            
            for (Opportunity opp : newOpportunityList){
                Opportunity oldOpp = oldOpportunityMap.get(opp.Id);
                if (opp.StageName == ConstantUtilities.OPP_STAGE_CLOSED_LOST && 
                    oldOpp.StageName != ConstantUtilities.OPP_STAGE_CLOSED_LOST) {
                        Set<String> reasonsSet = new Set<String>(opp.Reasons_for_Closed_Lost__c.split(';'));
                        if (hasValidReason(reasonsSet, ConstantUtilities.RECAPTURE_OPP_CLOSEDLOST_REASONS)) {
                            opp.Closed_Lost_Date__c = System.today();  
                        }
                    }
            }
            
        } catch (Exception e) {
            ExceptionHandler.logException('OpportunityTriggerHelper' , 'handleBeforeUpdate', e);
        }
    }
    
    public static Boolean hasValidReason(Set<String> reasonsSet, Set<String> validReasons) {
        for (String reason : validReasons) {
            if (reasonsSet.contains(reason)) {
                return true;
            }
        }
        return false;
    }
    
    
}