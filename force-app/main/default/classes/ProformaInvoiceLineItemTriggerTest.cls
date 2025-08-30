@isTest
public class ProformaInvoiceLineItemTriggerTest {
    @testSetup
    static void setupTestData() {
        Product2 prod = TestDataFactory.createProduct('1121', 'Test prod', 'Test Prod');
        Proforma_Invoice__c pi = TestDataFactory.createProformaInvoice(100);
        TestDataFactory.createLineItem('1121', pi.Id);
       
    }
    @isTest
    public static void beforeInsert(){
        Product2 prod = [SELECT Id, Name, Description, Material_Code__c 
                         FROM Product2 
                         WHERE Material_Code__c = '1121' 
                         LIMIT 1];
        
        List<Proforma_Invoice_Line_Item__c> lineItems = [
            SELECT Id, Product_Sap_Id__c, Proforma_Invoice__c 
            FROM Proforma_Invoice_Line_Item__c WHERE Product_Sap_Id__c = '1121'
        ];
        System.assertEquals(1, lineItems.size(), 'Proforma Invoice Line Items should be present.');
        System.assertNotEquals(0, lineItems.size(), 'Proforma Invoice Line Items should be present.');
    }
    @isTest
    public static void testUpdate(){
        List<Proforma_Invoice_Line_Item__c> lineItems = [
            SELECT Id, Product_Sap_Id__c, Proforma_Invoice__c 
            FROM Proforma_Invoice_Line_Item__c WHERE Product_Sap_Id__c = '1121'
        ];
        lineItems[0].Product_Sap_Id__c = '1321';
        update lineItems;
        delete lineItems;
    }
    @isTest
    public static void testBeforeUpdate(){
        List<Proforma_Invoice_Line_Item__c> lineItems = [
            SELECT Id, Product_Sap_Id__c, Proforma_Invoice__c 
            FROM Proforma_Invoice_Line_Item__c WHERE Product_Sap_Id__c = '1121'
        ];
        Map<ID, Proforma_Invoice_Line_Item__c> oldProformaLineItemsMap = new Map<ID, Proforma_Invoice_Line_Item__c>();
        for(Proforma_Invoice_Line_Item__c pi : lineItems){
            oldProformaLineItemsMap.put(pi.Id,pi);
        }
        Test.startTest();
        ProformaInvoiceLineItemTriggerHandler handler = new ProformaInvoiceLineItemTriggerHandler();
        handler.beforeInsert(lineItems);
        handler.beforeUpdate(lineItems, lineItems, oldProformaLineItemsMap, oldProformaLineItemsMap);
        handler.beforeDelete(lineItems, oldProformaLineItemsMap);
        handler.afterInsert(lineItems, oldProformaLineItemsMap);
        handler.afterUpdate(lineItems, lineItems, oldProformaLineItemsMap, oldProformaLineItemsMap);
        handler.afterDelete(lineItems, oldProformaLineItemsMap);
        handler.afterUndelete(lineItems, oldProformaLineItemsMap);
        Test.stopTest();
    }
}