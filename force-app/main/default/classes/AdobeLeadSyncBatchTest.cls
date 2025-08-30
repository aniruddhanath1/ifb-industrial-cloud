@isTest
public class AdobeLeadSyncBatchTest {

    @testSetup
    static void setupTestData() {
        Account acc = TestDataFactory.createAccount();
        Contact con  = TestDataFactory.createContactForAccount(acc.Id, 'test@mail.com');
        Lead leadL = TestDataFactory.createLead();
        Opportunity opp1 =TestDataFactory.createOpportunityConditionaly(acc.Id, 'Qualification', false);
        opp1.LeadIDText__c = leadL.Id;

        Opportunity opp2 = TestDataFactory.createOpportunityConditionaly(acc.Id, 'Qualification', false);
        opp2.LeadIDText__c = leadL.Id;
        insert new List<Opportunity>{ opp1, opp2 };
        List<Lead> testLeads = TestDataFactory.createLeadList();
    }

    @isTest
    static void testExecuteMethod() {
        Test.setMock(HttpCalloutMock.class, new AdobeLeadSyncMock());
        List<Opportunity> oppList = [ SELECT Id, StageName, LeadSource, Rating__c, Next_Follow_up_Date_Time__c, Purchase_timeline__c, Site__c, Space_Availability__c, 
       LeadIDText__c,Lead_Score__c,Adobe_Sync__c, Product_category__c, Type, Type_of_Customer__c, Name, Budget__c, Type_of_Setup__c, Account.Name,
       Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, 
       Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode, 
       Account.AnnualRevenue, Account.Website, Account.Other_Business__c, Account.Other_Locations_if_applicable__c, 
       Account.Sector__c, Account.Customer_Segment__c, AccountId,Account.Customer_Sub_segment__c
FROM Opportunity where LeadIDText__c!=null AND AccountId!=null AND Adobe_Sync__c=false];
        
        List<Lead> testLeads = [SELECT Id, Status, Lead_Score__c, Rating, Next_Follow_up_Date_Time__c, Requirement__c ,Purchase_Timeline__c, Site_Suitability__c, Space_Availability__c,
                                    LeadSource,  Lead_Sub_Source__c,  Product_Category__c,  Type__c, 
                                    Type_of_Customer__c, 
                                    FirstName, LastName, Company, Phone,Alternative_Phone_Number__c, Email, 
                                    Is_our_contact_a_Key_Decision_Maker__c,  Customer_Department__c, Customer_Designation__c,
                                    Street, City, State, PostalCode, Country,
                                    Shipping__Street__s, Shipping__City__s,Shipping__StateCode__s, Shipping__PostalCode__s, Shipping__CountryCode__s,
                                    Name,  Sector__c, Customer_Segment_Vertical__c, Customer_Sub_segment_Sub_Vertical__c, 
                                    Other_Business__c, Other_Locations__c, Region_Name__c, 
                                    Type_of_Setup__c, AnnualRevenue,  Website,CreatedDate from lead ];

        Test.startTest();
        AdobeLeadSyncBatch leadBatch = new AdobeLeadSyncBatch();
        leadBatch.execute(null, testLeads);
        Test.stopTest();

        List<Lead> updatedLeads = [SELECT Id, Adobe_Sync__c FROM Lead WHERE Adobe_Sync__c = true];
    }

    @isTest
    static void testSchedulableExecuteMethod() {
        Test.startTest();
        AdobeLeadSyncBatch batch = new AdobeLeadSyncBatch();
        //batch.execute(null);
        Test.stopTest();
    }

    private class AdobeLeadSyncMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"data":[{"leadId":"' + [SELECT Id FROM Lead LIMIT 1].Id + '","status":"SUCCESS"}]}');
            return res;
        }
    }
    
     @isTest
    static void testScheduledBatchExecution() {
        String cronExp = '0 0 12 * * ?';

        String jobId = System.schedule('Test Adobe Lead Sync Job', cronExp, new AdobeLeadSyncBatch());

        Test.startTest();
        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Scheduled job ID should not be null.');
    }
    
    
}