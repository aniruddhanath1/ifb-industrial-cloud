public class OpportunityRecaptureBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date targetDate = System.today().addDays(-60);
        Date startDate = targetDate;
        Date endDate = targetDate.addDays(1);
        String closedLostStage = 'Closed Lost';
        String query = 'SELECT Id, AccountId, Name, Description, StageName, Amount, Probability,Space_availability__c, '+
            'Budget__c,Heating_Type__c,Entry_side__c,Reasons_for_Closed_Lost__c,Purchase_timeline__c,Site__c,OwnerId,Infrastructure_completed_in_30_days__c '+
            'FROM Opportunity ' +
            'WHERE StageName = :closedLostStage ' +
            'AND Closed_Lost_Date__c >= :startDate ' +
            'AND Closed_Lost_Date__c < :endDate ' +
            'AND Recapture_Processed__c = FALSE';
        
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> listOfOpportunities) {
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
        List<Task> tasksToInsert = new List<Task>();
        List<OpportunityLineItem> lineItemsToInsert = new List<OpportunityLineItem>();
        Map<Id, List<OpportunityLineItem>> opportunityLineItemsMap = new Map<Id, List<OpportunityLineItem>>();
        Set<Id> opportunityIds = new Set<Id>();
        for (Opportunity opp : listOfOpportunities) {
            if (hasValidReason(opp.Reasons_for_Closed_Lost__c)) {
                opportunityIds.add(opp.Id);
            }
        }
        if (!opportunityIds.isEmpty()) {
            try {
                List<OpportunityLineItem> listOfOppLineItems = [
                    SELECT OpportunityId, PricebookEntryId, Quantity, UnitPrice, Discount 
                    FROM OpportunityLineItem 
                    WHERE OpportunityId IN :opportunityIds];
                if(!listOfOppLineItems.isEmpty()){
                    for (OpportunityLineItem oli : listOfOppLineItems) {
                        if (!opportunityLineItemsMap.containsKey(oli.OpportunityId)) {
                            opportunityLineItemsMap.put(oli.OpportunityId, new List<OpportunityLineItem>());
                        }
                        opportunityLineItemsMap.get(oli.OpportunityId).add(oli);
                    }
                }
                for (Opportunity opp : listOfOpportunities) {
                    if (opportunityLineItemsMap.containsKey(opp.Id)) {
                        Opportunity newRecaptureOpp = opp.clone(false, true, false, false);
                        newRecaptureOpp.Name = 'Recapture - ' + opp.Name;
                        newRecaptureOpp.CloseDate = System.today().addDays(30);
                        newRecaptureOpp.AccountId = opp.AccountId;
                        newRecaptureOpp.OwnerId = opp.OwnerId;
                        newRecaptureOpp.StageName = ConstantUtilities.OPP_STAGE_QUALIFICATION;
                        newRecaptureOpp.CurrentValidationTime__c = System.now();
                        opportunitiesToInsert.add(newRecaptureOpp);
                        
                        Task recaptureTask = new Task();
                        recaptureTask.Subject = ConstantUtilities.RECAPTURE_SUBJECT;
                        recaptureTask.OwnerId = opp.OwnerId;
                        recaptureTask.Status = ConstantUtilities.RECAPTURE_STATUS;
                        recaptureTask.Priority = ConstantUtilities.RECAPTURE_PRIORITY;
                        recaptureTask.ActivityDate = System.today().addDays(7);  
                        tasksToInsert.add(recaptureTask);
                        opp.Recapture_Processed__c = true;
                    }
                }
                if (!opportunitiesToInsert.isEmpty()) {
                    insert opportunitiesToInsert;
                    for (Integer i = 0; i < opportunitiesToInsert.size(); i++) {
                        tasksToInsert[i].WhatId = opportunitiesToInsert[i].Id;
                    }
                    insert tasksToInsert;
                    
                    for (Opportunity opp : listOfOpportunities) {
                        if (opportunityLineItemsMap.containsKey(opp.Id)) {
                            for (OpportunityLineItem oldLineItem : opportunityLineItemsMap.get(opp.Id)) {
                                OpportunityLineItem newLineItem = oldLineItem.clone(false, true, false, false);
                                newLineItem.OpportunityId = opportunitiesToInsert[listOfOpportunities.indexOf(opp)].Id;
                                lineItemsToInsert.add(newLineItem);
                            }
                        }
                    }
                    
                    if (!lineItemsToInsert.isEmpty()) {
                        insert lineItemsToInsert;
                    }
                }
                
                if (!listOfOpportunities.isEmpty()) {
                    update listOfOpportunities;
                }
                
            } catch (Exception e) {
                ExceptionHandler.logException('OpportunityRecaptureBatch', 'execute', e);
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
    }
    
    private Boolean hasValidReason(String reasonsForClosedLost) {
        if (String.isNotBlank(reasonsForClosedLost)) {
            Set<String> reasonsSet = new Set<String>(reasonsForClosedLost.split(';'));
            for (String reason : reasonsSet) {
                if (ConstantUtilities.RECAPTURE_OPP_CLOSEDLOST_REASONS.contains(reason)) {
                    return true;
                }
            }
        }
        return false;
    }
}