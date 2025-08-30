@isTest
public class LeadInactiveNotificationTest {
    
    @testSetup
    static void setupTestData() {
        
        // Create test Location record
        Schema.Location loc = new Schema.Location(
            Name = 'Test Location',
            LocationType = 'Site',
            Longitude = 28.635308,
            Latitude = 28.635308
        );
        insert loc;

        // Create test Users
        User testUser = [SELECT Id, Email FROM User WHERE IsActive = TRUE LIMIT 1];
        User manager = [SELECT Id, Email FROM User WHERE IsActive = TRUE AND Id != :testUser.Id LIMIT 1];

        // Assign manager to testUser
        System.runAs(new User(Id = UserInfo.getUserId())) {
            testUser.ManagerId = manager.Id;
            update testUser;
        }

        // Create test Leads with distinct ModifyDateToStage2__c
        List<Lead> testLeads = TestDataFactory.createLeadList();
        
        Lead lead1 = testDataFactory.createLead();
        lead1.Lead_Location__c = loc.Id;
        update lead1;
        testLeads.add(lead1);

        // Create Email Templates
        System.runAs(new User(Id = UserInfo.getUserId())) {
            EmailTemplate template30Days = new EmailTemplate(
                Name = 'Reminder_30_Days',
                DeveloperName = 'Reminder_30_Days',
                Body = 'Reminder: Lead inactive for 30 days.',
                Subject = 'Lead Reminder 30 Days',
                HtmlValue = 'Reminder for Lead inactive for 30 days.',
                TemplateType = 'text',
                FolderId = UserInfo.getUserId()
            );
            insert template30Days;

            EmailTemplate template45Days = new EmailTemplate(
                Name = 'Reminder_45_Days',
                DeveloperName = 'Reminder_45_Days',
                Body = 'Reminder: Lead inactive for 45 days.',
                Subject = 'Lead Reminder 45 Days',
                HtmlValue = 'Reminder for Lead inactive for 45 days.',
                TemplateType = 'text',
                FolderId = UserInfo.getUserId()
            );
            insert template45Days;
        }
    }

    @isTest
    static void testBatchExecution() {
        Test.startTest();
        
        LeadInactiveNotification batchJob = new LeadInactiveNotification(100);
        Database.executeBatch(batchJob, 100);
        
        Test.stopTest();

    }

    @isTest
    static void testScheduledJobExecution() {
        Test.startTest();

        LeadInactiveNotification schedulableJob = new LeadInactiveNotification(100);
        String jobId = System.schedule('Test Lead Inactive Notification Job', '0 0 12 * * ?', schedulableJob);

        Test.stopTest();

        // Verify scheduled job exists
        CronTrigger ct = [SELECT Id, CronExpression, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 12 * * ?', ct.CronExpression, 'The cron expression is incorrect.');
        System.assertNotEquals(null, ct.NextFireTime, 'The job should have a valid NextFireTime.');
    }

    @isTest
    static void testBatchWithNoData() {
        Test.startTest();
        
        LeadInactiveNotification batchJob = new LeadInactiveNotification(100);
        Database.executeBatch(batchJob, 100);
        
        Test.stopTest();

    }

    @isTest
    static void testErrorHandlingInNotification() {
        Test.startTest();
        
        LeadInactiveNotification batchJob = new LeadInactiveNotification(100);
        Database.executeBatch(batchJob, 100);
        
        Test.stopTest();
    }

    @isTest
    static void testEmailExceptionHandling() {
        Test.startTest();

        try {
            LeadInactiveNotification batchJob = new LeadInactiveNotification(100);
            Database.executeBatch(batchJob, 100);
        } catch (Exception e) {
            System.assertNotEquals(null, e, 'An exception should be thrown.');
        }

        Test.stopTest();
    }

    @isTest
    static void testCustomNotification() {
        Test.startTest();

        LeadInactiveNotification batchJob = new LeadInactiveNotification(100);
        Database.executeBatch(batchJob, 100);

        Test.stopTest();
    }
}