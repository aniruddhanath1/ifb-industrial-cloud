@isTest
public class EmailForLeadsReportsControllerTest {
    
    @testSetup
    static void setupTestData() {
        User manager = new User(
            FirstName = 'Manager', 
            LastName = 'Test', 
            Email = 'manager@test.com', 
            Username = 'manager' + System.currentTimeMillis() + '@test.com', 
            Alias = 'mgr', 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            LanguageLocaleKey='en_US',
            EmailEncodingKey = 'UTF-8', 
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
        );
        insert manager;

        User owner = new User(
            FirstName = 'Owner', 
            LastName = 'Test', 
            Email = 'owner@test.com', 
            Username = 'owner' + System.currentTimeMillis() + '@test.com', 
            Alias = 'ownr', 
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US',
            LanguageLocaleKey='en_US',
            EmailEncodingKey = 'UTF-8', 
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            ManagerId = manager.Id
        );
        insert owner;

        List<Lead> dailyLeads = TestDataFactory.createLeadList();
        
        List<Lead> weeklyLeads = TestDataFactory.createLeadList();
    }

    @isTest
    static void testBusinessDayReport_DailyEmail() {
        EmailForLeadsReportsController.testClassTime = ConstantUtilities.DAILY_HOUR;

        Test.startTest();
        EmailForLeadsReportsController.businessDayReport();
        Test.stopTest();

        Integer emailCountAfter = Limits.getEmailInvocations();
    }

    @isTest
    static void testBusinessDayReport_WeeklyEmail() {
        EmailForLeadsReportsController.testClassTime = ConstantUtilities.WEEKLY_HOUR;

        Test.startTest();
        EmailForLeadsReportsController.businessDayReport();
        Test.stopTest();
    }

    @isTest
    static void testBusinessDayReport_NoLeads() {
        delete [SELECT Id FROM Lead];

        EmailForLeadsReportsController.testClassTime = ConstantUtilities.DAILY_HOUR;

        Test.startTest();
        EmailForLeadsReportsController.businessDayReport();
        Test.stopTest();

        Integer emailCountAfter = Limits.getEmailInvocations();
        System.assertEquals(0, emailCountAfter, 'No email should be sent since there are no leads.');
    }

    @isTest
    static void testLeadDetailMapping() {
        User owner = [SELECT Id FROM User WHERE Email LIKE 'owner%@test.com' LIMIT 1];
        
        List<Lead> leads = [SELECT Id, Name, OwnerId FROM Lead WHERE OwnerId = :owner.Id];
        Set<Id> ownerIds = new Set<Id>{owner.Id};

        Test.startTest();
        EmailForLeadsReportsController.leadDetailMapping(leads, ownerIds, ConstantUtilities.DAILY_HOUR);
        Test.stopTest();
        
    }

    @isTest
    static void testCreateEmail() {
        User owner = [SELECT Id, Email, Name FROM User WHERE Email LIKE 'owner%@test.com' LIMIT 1];
        Lead lead = [SELECT Id, Name,Company,Phone FROM Lead LIMIT 1];

        List<Lead> leads = new List<Lead>{ lead };
        
        Messaging.SingleEmailMessage email = EmailForLeadsReportsController.createEmail(owner, leads);
        
        System.assertNotEquals(null, email, 'Email should be created successfully.');
        System.assert(email.getToAddresses().size() > 0, 'Email should have a recipient.');
        System.assertNotEquals('', email.getSubject(), 'Email subject should not be empty.');
    }

    @isTest
    static void testCreateEmailFor7Days() {
        User owner = [SELECT Id, Email, Name FROM User WHERE Email LIKE 'owner%@test.com' LIMIT 1];
        Lead lead = [SELECT Id, Name,Company,Phone FROM Lead LIMIT 1];

        List<Lead> leads = new List<Lead>{ lead };
        
        Messaging.SingleEmailMessage email = EmailForLeadsReportsController.createEmailFor7Days(owner, leads);
        
        System.assertNotEquals(null, email, 'Email should be created successfully.');
        System.assert(email.getToAddresses().size() > 0, 'Email should have a recipient.');
        System.assertNotEquals('', email.getSubject(), 'Email subject should not be empty.');
    }

    @isTest
    static void testExceptionHandling() {
        Test.startTest();
        try {
            EmailForLeadsReportsController.leadDetailMapping(null, null, ConstantUtilities.DAILY_HOUR);
        } catch(Exception e) {
            System.assertNotEquals(null, e.getMessage(), 'Exception should have a message.');
        }
        Test.stopTest();
    }
}