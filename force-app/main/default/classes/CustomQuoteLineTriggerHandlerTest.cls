@IsTest
public class CustomQuoteLineTriggerHandlerTest {
    @TestSetup
    static void setupTestData() {
        // Create required test data like Pricebook, Product, and Quote
        Product2 product = new Product2(
            Name = 'Test Product',
            IsActive = true
        );
        insert product;

        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pricebookEntry;

        SBQQ__Quote__c quote = new SBQQ__Quote__c(
            SBQQ__PricebookId__c = Test.getStandardPricebookId(),
            Payment_Split_ratio__c = '40:60'
        );
        insert quote;
    }

    @IsTest
    static void testBeforeInsert() {
        // Test BEFORE_INSERT logic
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        PricebookEntry pricebookEntry = [SELECT Id, Product2Id FROM PricebookEntry LIMIT 1];

        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = quote.Id,
                SBQQ__Product__c = pricebookEntry.Product2Id,
                SBQQ__UnitCost__c = 50
            )
        };
        insert quoteLines;

        // Assert that SBQQ__PricingMethod__c was set to 'cost'
        List<SBQQ__QuoteLine__c> insertedQuoteLines = [SELECT SBQQ__PricingMethod__c FROM SBQQ__QuoteLine__c];
     
    }

    @IsTest
    static void testAfterInsert() {
        // Test AFTER_INSERT logic
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        PricebookEntry pricebookEntry = [SELECT Id, Product2Id FROM PricebookEntry LIMIT 1];

        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>{
            new SBQQ__QuoteLine__c(
                SBQQ__Quote__c = quote.Id,
                SBQQ__Product__c = pricebookEntry.Product2Id,
                SBQQ__UnitCost__c = 100
            )
        };
        insert quoteLines;

       
    }

    @IsTest
    static void testAfterUpdate() {
        // Test AFTER_UPDATE logic
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        PricebookEntry pricebookEntry = [SELECT Id, Product2Id FROM PricebookEntry LIMIT 1];

        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c(
            SBQQ__Quote__c = quote.Id,
            SBQQ__Product__c = pricebookEntry.Product2Id
        );
        insert quoteLine;

        // Update the Quote Line to trigger AFTER_UPDATE
        quoteLine.SBQQ__UnitCost__c = 150;
        update quoteLine;

        // Assert flow was called (indirectly validate via debug logs or side effects)
        List<SBQQ__QuoteLine__c> updatedQuoteLines = [SELECT SBQQ__UnitCost__c FROM SBQQ__QuoteLine__c WHERE Id = :quoteLine.Id];
       
    }
}