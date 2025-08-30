@isTest
private class ProformaInvoiceControllerTest {
    
    @isTest
    static void testProformaInvoiceController() {
        // Create test Account data
        Account testAccount = new Account(
            Name = 'Test Account',
            Phone = '9234567890',
            cgcloud__Account_Number__c = 'Account123',
            BillingStreet = 'Test Street',
            BillingCity = 'jaipur',
            BillingState = 'Rajasthan',
            BillingCountry = 'India',
            BillingPostalCode = '123451',
            ShippingStreet = 'Test Shipping Street',
            ShippingCity = 'jaipur',
            ShippingState = 'Rajasthan',
            ShippingCountry = 'India',
            ShippingPostalCode = '678901'
        );
        insert testAccount;
        
        order testorder = new order(
            AccountId = testAccount.id,
            Name='testorder',
            EffectiveDate=Date.today(),
            Status='SO Created'
        );
        insert testorder;
        // Create test Proforma_Invoice__c data
        Proforma_Invoice__c proformaInvoice = new Proforma_Invoice__c(
            Po_No__r = testorder,
            Total_Amount__c = 1000.00,
            Advance_Amount_to_be_collected__c = 100.00,
            
            Balance_Amount_to_be_collected__c = 900.00
            
        );
        insert proformaInvoice;
        
		Product2 prod = new Product2(
        Name = 'Test Product');
		
		Insert prod;
        // Create test Proforma_Invoice_Line_Item__c data
        Proforma_Invoice_Line_Item__c lineItem = new Proforma_Invoice_Line_Item__c(
            Proforma_Invoice__c = proformaInvoice.Id,
            Product__r = prod,
            Quantity__c = 10,
            Total_Amount__c = 500.00,
            CGST__c = 9.00,
            CGST_Value__c = 45.00,
            SGST__c = 9.00,
            SGST_Value__c = 45.00,
            IGST__c = 18.00,
            IGST_Value__c = 90.00,
            HSN_Code__c = '1234'
        );
        insert lineItem;
        
        // Set the current page parameters to simulate the request
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', proformaInvoice.Id);
        ApexPages.currentPage().getParameters().put('typeofpdf', 'Invoice');
        
        // Instantiate the controller
        ProformaInvoiceController controller = new ProformaInvoiceController();
        
        // Assertions to verify that the controller has been initialized correctly
        System.assertNotEquals(null, controller.wrapperObj);
        System.assertNotEquals(null, controller.wrapperObjAccount);
        System.assertNotEquals(null, controller.invoiceLineItemList);
        System.assertNotEquals(0, controller.invoiceLineItemList.size());
        //System.assertEquals('ORD123', controller.wrapperObj.invoiceNo);
        //System.assertEquals('Test Account', controller.wrapperObjAccount.nameOfConsignee);
        //System.assertEquals('Test Street Test City Test State Test Country 12345', controller.wrapperObjAccount.billingAddress);
        //System.assertEquals(1000.00, controller.wrapperObjLast.totalAmount);
        
        Test.stopTest();
    }
    
    @isTest
    static void testExceptionHandling() {
        // Test scenario where exception is thrown
        Test.startTest();
        
        // Set the current page parameters to simulate the request
        ApexPages.currentPage().getParameters().put('id', 'invalidId');
        
        // Instantiate the controller
        ProformaInvoiceController controller = new ProformaInvoiceController();
        
        // Assertions to check for exception handling
        // As the recordId is invalid, ensure that no wrapper objects are populated
        System.assertEquals(null, controller.wrapperObj);
        System.assertEquals(null, controller.wrapperObjAccount);
        
        Test.stopTest();
    }
}