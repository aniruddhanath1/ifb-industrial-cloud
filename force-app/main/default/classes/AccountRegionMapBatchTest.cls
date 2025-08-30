@isTest
public class AccountRegionMapBatchTest {
    @isTest
    static void testAccountRegionMapBatch() {
        // Create test user
        User testUser = new User(
            Alias = 'tuser',
            Email = 'testuser62716271@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser62716271@example.com'
        );
        insert testUser;

        // Create test Region Map
        Region_Map__c regionMap = new Region_Map__c(
            Zipcode__c = '303303',
            Region_Owner__c = testUser.Id
        );
        insert regionMap;

        // Create test Account
        Account testAccount = new Account(
            Name = 'Test Account',
            BillingPostalCode = '303303'
        );
        insert testAccount;

        // Run the batch
        Test.startTest();
        AccountRegionMapBatch batch = new AccountRegionMapBatch();
        Database.executeBatch(batch, 10);
        Test.stopTest();

        // Verify the account owner is updated
        testAccount = [SELECT OwnerId FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(testUser.Id, testAccount.OwnerId);
    }
}