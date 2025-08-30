public interface InterfaceTriggerHandler {
    /*
@Description : Called by the trigger framework before insert of the records
@Parameters : List<sObject> newList , Map<Id, sObject> newMap
*/
    void beforeInsert(List<SObject> newRecords);
    
    /*
@Description : Called by the trigger framework after insert of the records
@Parameters : List<sObject> newList
*/
    void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap);
    
    /*
@Description : Called by the trigger framework before update of the records
@Parameters : List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap
*/
    void beforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap);
    
    /*
@Description : Called by the trigger framework after update of the records
@Parameters : List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap
*/
    void afterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap);
    
    /*
@Description : Called by the trigger framework before delete of the records
@Parameters : List<sObject> oldList , Map<Id, sObject> oldMap
*/           
    void beforeDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap);
    
    /*
@Description : Called by the trigger framework after delete of the records
@Parameters : Map<Id, sObject> oldMap
*/
    void afterDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap);
    
    /*
@Description : Called by the trigger framework after undelete of the records
@Parameters : List<sObject> newList, Map<Id, sObject> newMap
*/
    void afterUndelete(List<SObject> newRecords, Map<ID, SObject> newRecordMap);
    
}