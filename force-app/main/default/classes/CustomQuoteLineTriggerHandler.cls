public class CustomQuoteLineTriggerHandler {
    
   public void  beforeInsert(list<SBQQ__QuoteLine__c> newQuoteline) {
       CustomQuoteTriggerHelper.handleBeforeInsert(newQuoteline);
    }
    public void beforeUpdate() { 
        // helper.doTask3();
        // helper.doTask4(); 
    }
    public void beforeDelete() {
        // helper.doTask5();
        // helper.doTask1();
    }
    public void afterInsert(list<SBQQ__QuoteLine__c> newQuoteline) {
         CustomQuoteTriggerHelper.handleAfterInsert(newQuoteline);
    }
     public void afterUpdate(List<SBQQ__QuoteLine__c> oldQuoteline,List<SBQQ__QuoteLine__c> newQuoteline,Map<Id, SBQQ__QuoteLine__c> oldQuotelineMap,Map<Id, SBQQ__QuoteLine__c> newQuotelineMap){
       	 CustomQuoteTriggerHelper.handleAfterupdate(oldQuoteline,newQuoteline,oldQuotelineMap,newQuotelineMap);
    }
   
}