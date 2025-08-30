@isTest
public class InvoiceLineItemTriggerTest {
    @testSetup
    static void setupTestData() {
        
        Product2 prod = TestDataFactory.createProduct('1121', 'Test prod', 'Test Prod');
        Invoice__c inv = TestDataFactory.createInvoice('100');
        TestDataFactory.createLineItemInvoice('1121', inv.Id);
    
    }
    @isTest
    public static void beforeInsert(){
        Product2 prod = [SELECT Id, Name, Description, Material_Code__c 
                         FROM Product2 
                         WHERE Material_Code__c = '1121' 
                         LIMIT 1];
        
        List<Invoice_Line_Item__c> lineItems = [
            SELECT Id, Material_Code__c, Invoice__c 
            FROM Invoice_Line_Item__c WHERE Material_Code__c = '1121'
        ];
        System.assertEquals(1, lineItems.size(), 'Invoice Line Items should be present.');
        System.assertNotEquals(0, lineItems.size(), 'Invoice Line Items should be present.');
    }
    @isTest
    public static void testUpdate(){
        List<Invoice_Line_Item__c> lineItems = [
            SELECT Id, Material_Code__c, Invoice__c 
            FROM Invoice_Line_Item__c WHERE Material_Code__c = '1121'
        ];
        lineItems[0].Material_Code__c = '1321';
        update lineItems;
        delete lineItems;
    }
    @isTest
    public static void testBeforeUpdate(){
        List<Invoice_Line_Item__c> lineItems = [
            SELECT Id, Material_Code__c,Invoice__c 
            FROM Invoice_Line_Item__c WHERE Material_Code__c = '1121'
        ];
        Map<ID, Invoice_Line_Item__c> oldInvoiceLineItemsMap = new Map<ID, Invoice_Line_Item__c>();
        for(Invoice_Line_Item__c pi : lineItems){
            oldInvoiceLineItemsMap.put(pi.Id,pi);
        }
        Test.startTest();
        InvoiceLineItemTriggerHandler handler = new InvoiceLineItemTriggerHandler();
        handler.beforeInsert(lineItems);
        handler.beforeUpdate(lineItems, lineItems, oldInvoiceLineItemsMap, oldInvoiceLineItemsMap);
        handler.beforeDelete(lineItems, oldInvoiceLineItemsMap);
        handler.afterInsert(lineItems, oldInvoiceLineItemsMap);
        handler.afterUpdate(lineItems, lineItems, oldInvoiceLineItemsMap, oldInvoiceLineItemsMap);
        handler.afterDelete(lineItems, oldInvoiceLineItemsMap);
        handler.afterUndelete(lineItems, oldInvoiceLineItemsMap);
        Test.stopTest();
    }
}