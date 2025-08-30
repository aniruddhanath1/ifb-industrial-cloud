@isTest
public class DeleteLeadsBatchTest {
    @testSetup
    static void setupTestData() {
        Lead lead1 = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company',
            Status = ConstantUtilities.LEAD_STATUS_UNVALIDATED,PostalCode='726117');
        insert lead1;
        Lead lead2 = new Lead(FirstName = 'TestLead', LastName = 'Lead', Company = 'Test Company',
            Status = ConstantUtilities.LEAD_STATUS_UNVALIDATED, MergeRecordId__c = lead1.Id,PostalCode='738228');
        insert lead2;
    }
    
    @isTest
    static void testBatchExecution() {
        Test.startTest();
        DeleteLeadsBatch batch = new DeleteLeadsBatch();
        Database.executeBatch(batch, 200);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT COUNT() FROM Lead WHERE Id = :[SELECT Id FROM Lead LIMIT 1].Id]);
    }
    
    @isTest
    static void testSchedulableExecution() {
        Test.startTest();
        DeleteLeadsBatch batch = new DeleteLeadsBatch();
        batch.execute(null);
        Test.stopTest();
        
        System.assertEquals(1, [SELECT COUNT() FROM Lead WHERE MergeRecordId__c != null]);
    }
}