@isTest
private class OpportunityRecaptureBatchTest {
    @testSetup
    static void setupTestData() {
        Account acc = TestDataFactory.createAccount();
        Product2 product = TestDataFactory.createProduct2();
        ID pbeId = TestDataFactory.createPricebookEntry(product.Id);
        Opportunity opp = TestDataFactory.createOpportunity('Test Opportunity', 'Prospecting', System.today().addDays(10), 'ILM', 'ELECTRIC');
        Id oliId = TestDataFactory.createOppLineItem(opp.Id, pbeId, 'Prospecting');
        opp.StageName = 'Closed Lost';
        opp.Closed_Lost_Date__c = System.today().addDays(-60);
        opp.Reasons_for_Closed_Lost__c = 'Price';
        update opp;  
    }

    @isTest
    static void testOpportunityRecaptureBatch() {
        Test.startTest();
        OpportunityRecaptureBatch batch = new OpportunityRecaptureBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        Opportunity processedOpp = [SELECT Id, Recapture_Processed__c FROM Opportunity LIMIT 1];
        System.assertEquals(true, processedOpp.Recapture_Processed__c, 'Recapture Processed should be marked as true');
        List<Opportunity> recaptureOpps = [SELECT Id, Name, StageName FROM Opportunity WHERE Name LIKE 'Recapture%' LIMIT 1];
        System.assertEquals(1, recaptureOpps.size(), 'One recapture opportunity should be created');
        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE Subject = :ConstantUtilities.RECAPTURE_SUBJECT LIMIT 1];
    }
    
    @isTest
    static void testSchedulerExecution() {
        Test.startTest();
        String jobId = System.schedule('Test Recapture Scheduler', '0 0 12 * * ?', new OpportunityRecaptureScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, State FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 12 * * ?', ct.CronExpression, 'Cron expression should match');
        System.assertEquals('WAITING', ct.State, 'Job should be in WAITING state');
        Test.stopTest();
    }
}