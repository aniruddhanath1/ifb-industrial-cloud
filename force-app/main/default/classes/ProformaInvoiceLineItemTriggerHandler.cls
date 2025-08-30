public class ProformaInvoiceLineItemTriggerHandler implements InterfaceTriggerHandler{
    public void beforeInsert(List<Proforma_Invoice_Line_Item__c> newProformaLineItemsList) {
        ProformaInvoiceLineItemTriggerHelper.beforeInsert(newProformaLineItemsList);
    }
    public void beforeUpdate(List<Proforma_Invoice_Line_Item__c> oldProformaLineItemsList, List<Proforma_Invoice_Line_Item__c> newProformaLineItemsList, Map<ID, SObject> oldProformaLineItemsMap, Map<ID, SObject> newProformaLineItemsMap) {
        
        
    }
    public void beforeDelete(List<Proforma_Invoice_Line_Item__c> oldProformaLineItemsList, Map<ID, SObject> oldProformaLineItemsMap) {
        
    }
    public void afterInsert(List<Proforma_Invoice_Line_Item__c> newProformaLineItemsList, Map<ID, SObject> newProformaLineItemsMap) {
      
    }
    public void afterUpdate(List<Proforma_Invoice_Line_Item__c> oldProformaLineItemsList, List<Proforma_Invoice_Line_Item__c> newProformaLineItemsList, Map<ID, SObject> oldProformaLineItemsMap, Map<ID, SObject> newProformaLineItemsMap) {
        
    }
    
    public void afterDelete(List<Proforma_Invoice_Line_Item__c> oldProformaLineItemsList, Map<ID, SObject> oldProformaLineItemsMap) {
    }
    
    public void afterUndelete(List<Proforma_Invoice_Line_Item__c> newProformaLineItemsList, Map<ID, SObject> newProformaLineItemsMap) {
    }
}