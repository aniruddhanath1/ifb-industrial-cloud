public class InvoiceLineItemTriggerHandler implements InterfaceTriggerHandler{
    public void beforeInsert(List<Invoice_Line_Item__c> newInvoiceLineItemsList) {
        InvoiceLineItemTriggerHelper.beforeInsert(newInvoiceLineItemsList);
    }
    public void beforeUpdate(List<Invoice_Line_Item__c> oldInvoiceLineItemsList, List<Invoice_Line_Item__c> newInvoiceLineItemsList, Map<ID, SObject> oldInvoiceLineItemsMap, Map<ID, SObject> newInvoiceLineItemsMap) {
    }
    public void beforeDelete(List<Invoice_Line_Item__c> oldInvoiceLineItemsList, Map<ID, SObject> oldInvoiceLineItemsMap) {
        
    }
    public void afterInsert(List<Invoice_Line_Item__c> newInvoiceLineItemsList, Map<ID, SObject> newInvoiceLineItemsMap) {
        
    }
    public void afterUpdate(List<Invoice_Line_Item__c> oldInvoiceLineItemsList, List<Invoice_Line_Item__c> newInvoiceLineItemsList, Map<ID, SObject> oldInvoiceLineItemsMap, Map<ID, SObject> newInvoiceLineItemsMap) {
        
    }
    
    public void afterDelete(List<Invoice_Line_Item__c> oldInvoiceLineItemsList, Map<ID, SObject> oldInvoiceLineItemsMap) {
    }
    
    public void afterUndelete(List<Invoice_Line_Item__c> newInvoiceLineItemsList, Map<ID, SObject> newInvoiceLineItemsMap) {
    }
}