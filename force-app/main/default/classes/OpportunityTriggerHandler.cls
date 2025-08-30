public class OpportunityTriggerHandler {
    public void  beforeInsert(List<Opportunity> newOpportunity) {
        OpportunityTriggerHelper.handleBeforeInsert(newOpportunity);
    }
    public void beforeUpdate(List<Opportunity> newOpportunityList, List<Opportunity> oldOpportunityList, Map<Id,Opportunity> oldOpportunityMap, Map<Id,Opportunity> newOpportunityMap ) {  
        OpportunityTriggerHelper.handleBeforeUpdate(newOpportunityList,oldOpportunityMap);
    }
    public void beforeDelete() {
    }
    public void afterInsert() {        
        
    } 
}