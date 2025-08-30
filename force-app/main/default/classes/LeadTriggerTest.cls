@isTest
public class LeadTriggerTest {
    
    
    @testSetup
    static void setupTestData() {
       Account acc1 =new Account(
            Name = 'Lead',
            BillingPostalCode = '565685',
            Type = 'Site'
        );
        insert acc1;
        
        Account acc2 =new Account(
            Name = 'Test Account 1',
            BillingPostalCode = '565685',
            Type = 'Site'
        );
        insert acc2;
        List<Lead> leadListToInsert = new List<Lead>();
        leadListToInsert.add(TestDataFactory.createTestLead('Lead', '565685', 'GoogleAds', 'Domestic', 'IDW', 'Washing','565685',false));
        leadListToInsert.add(TestDataFactory.createTestLead('Lead', '565685', 'GoogleAds', 'Domestic', 'IDW', 'Washing','565685',false));
        leadListToInsert.add(TestDataFactory.createTestLead('Lead', '565685', 'GoogleAds', 'Domestic', 'IDW', 'Washing','565685',false));
        try{
            Insert leadListToInsert;
        }catch(exception e){
            
        }
        
    }

    @isTest
    static void testAfterInsertANDUpdate() {
        try{
            Test.startTest();
        List<Lead> leadListForNewRecordsInsert = new List<Lead>();
        leadListForNewRecordsInsert.add(TestDataFactory.createTestLead('Test Company2', '123452', 'GoogleAds', 'Domestic', 'IDW', 'Washing','123452',false));
        Insert leadListForNewRecordsInsert;
        Lead newLead2 = new Lead(); 
        newLead2 = TestDataFactory.createTestLead('Test Company 3', '123452', 'GoogleAds', 'Domestic', 'Both', 'Washing','123452',true);
        LeadTriggerHelper.handleProductCategoryForOpportunity(newLead2,[SELECT Id From Account WHERE Name = 'Lead' Limit 1].Id);
        newLead2.Alternative_Phone_Number__c = '9856784536';
        Update newLead2;
        List<Lead> leadObj = [SELECT Id From Lead WHERE Alternative_Phone_Number__c = '9856784536'];
        Test.stopTest();
        }catch(exception e){
            
        }
       
    }
    @isTest
    static void testOpportunityCreation(){
        Map<String, Account> accountMap = new Map<String, Account>();
        List<Lead> leads = [SELECT Id, Company, PostalCode FROM Lead];
        List<Account> accounts = [SELECT Id, Name, BillingPostalCode FROM Account];
        for (Account acc : accounts) {
            accountMap.put(acc.Name + ':' + acc.BillingPostalCode, acc);
        }
        Test.startTest();
        LeadTriggerHelper.opportunityCreation(leads, accountMap);
        Test.stopTest();
    }
}