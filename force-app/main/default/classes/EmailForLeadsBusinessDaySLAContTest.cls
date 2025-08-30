@isTest
public class EmailForLeadsBusinessDaySLAContTest {
    
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
        List<Lead> testLeads = TestDataFactory.createLeadList();
    }

    @isTest
    static void testBusinessDayReport_ValidData() {
        Test.startTest();
        EmailForLeadsBusinessDaySLAController.businessDayReport();
        Test.stopTest();
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage];
    }

    @isTest
    static void testBusinessDayReport_NoLeads() {
        delete [SELECT Id FROM Lead];

        Test.startTest();
        EmailForLeadsBusinessDaySLAController.businessDayReport();
        Test.stopTest();
        
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage];
        System.assertEquals(0, sentEmails.size(), 'No email should be sent when there are no leads.');
    }

    @isTest
    static void testLeadDetailMapping() {
        User owner = [SELECT Id, Email FROM User WHERE Email LIKE 'owner%@test.com' LIMIT 1];
        
        Lead testLead = new Lead(
                LastName = 'Lead',
                Company = 'Test Company',
                Status = 'New',
                LeadSource = 'Web',
                PostalCode = '123451',
                Shipping__CountryCode__s = 'US',
                Shipping__StateCode__s = 'CA',
                Phone = '8267282726'
            );
        insert testLead;

        List<Lead> leads = [SELECT Id, Name, OwnerId FROM Lead];
        Set<Id> ownerIds = new Set<Id>{owner.Id};

        Test.startTest();
        EmailForLeadsBusinessDaySLAController.leadDetailMapping(leads, ownerIds);
        Test.stopTest();
        
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage];
    }

    @isTest
    static void testSendEmail() {
        User owner = [SELECT Id, Email, Name, Manager.Email FROM User WHERE Email LIKE 'owner%@test.com' LIMIT 1];
        
        Lead testLead = TestDataFactory.createLead();
        Test.startTest();
        EmailForLeadsBusinessDaySLAController.sendEmail(owner, new List<Lead>{testLead});
        Test.stopTest();
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage];
    }

    @isTest
    static void testExceptionHandling() {
        Test.startTest();
        try {
            EmailForLeadsBusinessDaySLAController.leadDetailMapping(null, null);
        } catch(Exception e) {
            System.assertEquals('Argument cannot be null', e.getMessage(), 'Exception should be related to null argument.');
        }
        Test.stopTest();
    }

}