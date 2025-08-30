public class DeleteLeadsBatch implements Database.Batchable<SObject>, Schedulable {

    
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, MergeRecordId__c 
            FROM Lead 
            WHERE Status = :ConstantUtilities.LEAD_STATUS_UNVALIDATED
            AND MergeRecordId__c != null
        ]);
    }

    
    public void execute(Database.BatchableContext context, List<SObject> scope) {
        List<Lead> leadsToDeleteByMergeId = new List<Lead>();

        Set<Id> deleteLeadsIds = new Set<Id>();
        for (Lead lead : (List<Lead>)scope) {
            deleteLeadsIds.add(lead.MergeRecordId__c);
        }

        if (!deleteLeadsIds.isEmpty()) {
            leadsToDeleteByMergeId = [
                SELECT Id 
                FROM Lead 
                WHERE Id IN :deleteLeadsIds
            ];
        }

        if (!leadsToDeleteByMergeId.isEmpty()) {
            delete leadsToDeleteByMergeId;
        }
    }

    public void finish(Database.BatchableContext context) {
    }

    public void execute(SchedulableContext context) {
        Database.executeBatch(this, 200);
    }
}