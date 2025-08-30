@isTest
public class MyQuoteControllerTest {
    @isTest
    static void testMyQuoteController() {
        Id pricebookId = Test.getStandardPricebookId();

        Pricebook2 ilmPricebook = new Pricebook2(Name = 'Industrial Washing Machine', IsActive = true);
        Pricebook2 idwPricebook = new Pricebook2(Name = 'Industrial Dishwasher', IsActive = true);

        insert new List<Pricebook2>{ilmPricebook, idwPricebook};

        // Create Products and related Pricebook Entries
        Product2 product1 = new Product2(Name = 'Washer', Wash_Load_capacity__c = 10, Iron_Load_capacity__c = 60, Dry_load_capacity__c = 60, IsActive = true,Material_Code__c='1089876',Family = 'ILM Products', Heating_Type__c = 'Electric');
        Product2 product2 = new Product2(Name = 'Dryer', Wash_Load_capacity__c = 8, Iron_Load_capacity__c = 120, Dry_load_capacity__c = 120, IsActive = true,Material_Code__c='1098096',Family = 'ILM Products', Heating_Type__c = 'Gas');

        insert new List<Product2>{product1, product2};

        PricebookEntry pbe1 = new PricebookEntry(Product2Id = product1.Id, Pricebook2Id = pricebookId, UnitPrice = 1000, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Product2Id = product2.Id, Pricebook2Id = pricebookId, UnitPrice = 1500, IsActive = true);
        PricebookEntry pbe3 = new PricebookEntry(Product2Id = product1.Id, Pricebook2Id = ilmPricebook.Id, UnitPrice = 1100, IsActive = true);
        PricebookEntry pbe4 = new PricebookEntry(Product2Id = product2.Id, Pricebook2Id = idwPricebook.Id, UnitPrice = 1200, IsActive = true);
        // Create test data
        Account testAccount = new Account(Name = 'Test Account',BillingPostalCode='303303',BillingCity='jaipur',BillingCountryCode = 'IN',BillingStateCode = 'RJ',BillingStreet = 'BTM',ShippingPostalCode='302029',ShippingCity = 'Jaipur',ShippingCountryCode = 'IN',ShippingStateCode = 'RJ',ShippingStreet = 'BTM');
        insert testAccount; 
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com', AccountId = testAccount.Id);
        insert testContact;

        // Get Record Type IDs by Developer Name
        Id exportRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'Exports' LIMIT 1].Id;
        Id boqRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'SBQQ__Quote__c' AND DeveloperName = 'BOQ_specified' LIMIT 1].Id;

        // Create a test Quote
        SBQQ__Quote__c testQuote1 = new SBQQ__Quote__c(
            
            SBQQ__Account__c = testAccount.Id,
            SBQQ__PrimaryContact__c = testContact.Id,
            RecordTypeId = exportRecordTypeId,
            Payment_Term__c=30,
            Payment_Split_ratio__c = '30:50:20',
            SBQQ__ShippingCity__c= 'Jaipur',
            SBQQ__ShippingCountry__c= 'IN',
            SBQQ__ShippingName__c= 'Jaipur',
            SBQQ__ShippingPostalCode__c= '302029',
            SBQQ__ShippingState__c= 'Rj',
            SBQQ__ShippingStreet__c= 'aba',
            SBQQ__BillingStreet__c = 'Test st',
            SBQQ__BillingName__c = 'Test Bill Name',
            SBQQ__BillingCity__c = 'Bengaluru',
            SBQQ__BillingState__c = 'KA',
            SBQQ__BillingPostalCode__c = '560078',
            SBQQ__BillingCountry__c = 'IN'
        );

        SBQQ__Quote__c testQuote2 = new SBQQ__Quote__c(

                SBQQ__Account__c = testAccount.Id,
                SBQQ__PrimaryContact__c = testContact.Id,
                RecordTypeId = exportRecordTypeId,
                Payment_Term__c=30,
                Payment_Split_ratio__c = '30:50:20',
                SBQQ__ShippingCity__c= 'Jaipur',
                SBQQ__ShippingCountry__c= 'IN',
                SBQQ__ShippingName__c= 'Test Name',
                SBQQ__ShippingPostalCode__c= '302029',
                SBQQ__ShippingState__c= 'RJ',
                SBQQ__ShippingStreet__c= 'Test st',
                SBQQ__BillingStreet__c = 'Test st',
                SBQQ__BillingName__c = 'Test Name',
                SBQQ__BillingCity__c = 'Jaipur',
                SBQQ__BillingState__c = 'RJ',
                SBQQ__BillingPostalCode__c = '302029',
                SBQQ__BillingCountry__c = 'IN'
        );

        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>{ testQuote1, testQuote2 };
        insert quoteList;

        // Create Quote Line Items
        SBQQ__QuoteLine__c testQuoteLine1 = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = testQuote1.Id,
            SBQQ__Quantity__c = 5,
			SBQQ__Product__c = product1.Id
        );
        SBQQ__QuoteLine__c testQuoteLine2 = new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = testQuote2.Id,
                SBQQ__Quantity__c = 6,
                SBQQ__Product__c = product1.Id
        );
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>{ testQuoteLine1, testQuoteLine2 };
        insert quoteLineList;
		
		PageReference pageRef = new PageReference('/apex/fakePage');

        // Mock page parameters
       
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('qId', testQuote1.Id);
        ApexPages.currentPage().getParameters().put('tid', 'template123');

        // Instantiate the controller
        MyQuoteController controller = new MyQuoteController();

        // Assertions
        System.assertEquals(testQuote1.Id, controller.quote.Id, 'Quote ID should match.');
        //System.assertTrue(controller.isExportQuote, 'Should be export quote.');
        //System.assertFalse(controller.isBOQQuote, 'Should not be BOQ quote.');
        //System.assertTrue(controller.isDiscountMax, 'Discount max flag should be true.');
        System.assertEquals(30, controller.splitValue1, 'Split value 1 should be 30.');
        System.assertEquals(50, controller.splitValue2, 'Split value 2 should be 50.');
        System.assertEquals(20, controller.splitValue3, 'Split value 3 should be 20.');
    }
}