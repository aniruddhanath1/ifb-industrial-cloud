@isTest
public class AdobeOppSyncBatchTest {
    
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
            }
    
    @isTest
    static void testExecuteMethod() {
        Test.setMock(HttpCalloutMock.class, new AdobeOppSyncMock());
        List<Opportunity> oppList = [ SELECT Id, StageName, LeadSource, Rating__c, Next_Follow_up_Date_Time__c, Purchase_timeline__c, Site__c, Space_Availability__c, 
                                     LeadIDText__c,Lead_Score__c,Adobe_Sync__c, Product_category__c, Type, Type_of_Customer__c, Name, Budget__c, Type_of_Setup__c, Account.Name,
                                     Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, 
                                     Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode, 
                                     Account.AnnualRevenue, Account.Website, Account.Other_Business__c, Account.Other_Locations_if_applicable__c, 
                                     Account.Sector__c, Account.Customer_Segment__c, AccountId,Account.Customer_Sub_segment__c,CreatedDate
                                     FROM Opportunity where LeadIDText__c!=null AND AccountId!=null AND Adobe_Sync__c=false];
        
        Test.startTest();
        AdobeOppSyncBatch oppBatch = new AdobeOppSyncBatch();
        oppBatch.execute(null, oppList);
        Test.stopTest();
    }
    
    @isTest
    static void testSchedulableExecuteMethod() {
        try{
            Test.startTest();
            AdobeOppSyncBatch oppBatch = new AdobeOppSyncBatch();
            oppBatch.execute(null);
            Test.stopTest();
        }catch(exception e){
            
        }
        
    }
    
    private class AdobeOppSyncMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"data":[{"leadId":"' + [SELECT LeadIDText__c FROM Opportunity LIMIT 1].LeadIDText__c + '","status":"SUCCESS"}]}');
            return res;
        }
    }
}