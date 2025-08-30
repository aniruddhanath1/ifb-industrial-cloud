public class OpportunityLineItemTriggerHelper {
    //for updating Lifecycle_Expiration_Date__c on opp
    public static void afterInsert(List<OpportunityLineItem> newOpportunityLineItems,Map<ID, SObject> newOppLineItemsMap) {
        try {
            Set<Id> opportunityIds = new Set<Id>();
            for (OpportunityLineItem oli : newOpportunityLineItems) {
                if (oli.OpportunityId != null) {
                    opportunityIds.add(oli.OpportunityId);
                }
            }
            Map<Id, Date> opportunityLifecycleUpdates = new Map<Id, Date>();
            List<OpportunityLineItem> allOLIs = [
                SELECT Id, Product2Id, Product2.Shelf_Life_in_Days__c, OpportunityId
                FROM OpportunityLineItem
                WHERE OpportunityId IN :opportunityIds
            ];
            
            for (OpportunityLineItem oli : allOLIs) {
                Integer shelfLifeDays = Integer.valueOf(oli.Product2.Shelf_Life_in_Days__c);
                if (shelfLifeDays != null) {
                    Date expirationDate = System.today().addDays(shelfLifeDays);
                    if (!opportunityLifecycleUpdates.containsKey(oli.OpportunityId) ||
                        expirationDate < opportunityLifecycleUpdates.get(oli.OpportunityId)) {
                            opportunityLifecycleUpdates.put(oli.OpportunityId, expirationDate);
                        }
                }
            }
            List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
            for (Id oppId : opportunityLifecycleUpdates.keySet()) {
                Opportunity oppToUpdate = new Opportunity(Id = oppId);
                oppToUpdate.Lifecycle_Expiration_Date__c = opportunityLifecycleUpdates.get(oppId);
                opportunitiesToUpdate.add(oppToUpdate);
            }
            if (!opportunitiesToUpdate.isEmpty()) {
                update opportunitiesToUpdate;
            }
        } catch (Exception e) {
            ExceptionHandler.logException('OpportunityLineItemTriggerHelper', 'execute', e);
        }
    }
}