public class OpportunityLineItemTriggerHandler implements InterfaceTriggerHandler{
    public void beforeInsert(List<OpportunityLineItem> newOppLineItems) {
    }
    public void beforeUpdate(List<OpportunityLineItem> oldOppLineItems, List<OpportunityLineItem> newOppLineItems, Map<ID, SObject> oldOppLineItemsMap, Map<ID, SObject> newOppLineItemsMap) {
    }
    public void beforeDelete(List<OpportunityLineItem> oldOppLineItems, Map<ID, SObject> oldOppLineItemsMap) {
    }
    public void afterInsert(List<OpportunityLineItem> newOppLineItems, Map<ID, SObject> newOppLineItemsMap) {
        OpportunityLineItemTriggerHelper.afterInsert(Trigger.New,Trigger.newMap);
    }
    public void afterUpdate(List<OpportunityLineItem> oldOppLineItems, List<OpportunityLineItem> newOppLineItems, Map<ID, SObject> oldOppLineItemsMap, Map<ID, SObject> newOppLineItemsMap) {
    }
    public void afterDelete(List<OpportunityLineItem> oldOppLineItems, Map<ID, SObject> oldOppLineItemsMap) {
    }
    public void afterUndelete(List<OpportunityLineItem> newOppLineItems, Map<ID, SObject> newOppLineItemsMap) {
    }
}