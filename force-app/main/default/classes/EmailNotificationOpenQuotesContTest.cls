@isTest 
public class EmailNotificationOpenQuotesContTest {
    
    @testSetup
    public static void EmailNotificationOpenQuotesClass(){
        
        Account account = TestDataFactory.createAccount();
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        Opportunity oppoorunity = TestDataFactory.createOpportunityForAccount(account.Id,'Prospecting',userObj);
        SBQQ__Quote__c quote = TestDataFactory.createQuote(oppoorunity);
        quote.Freight_Terms__c = 'Borne by Customer';
        quote.Freight_Includes__c = 'Extras';
        quote.OwnerId = userObj.Id;
        Update quote;
        
        SBQQ__Quote__c quote1 = TestDataFactory.createQuote(oppoorunity);
        quote1.Freight_Terms__c = 'Borne by Customer';
        quote1.Freight_Includes__c = 'Extras';
        quote1.OwnerId = userObj.Id;
        Update quote1;
        
    }
    
    @isTest 
    public static void testopenQuotesReport(){
        Test.startTest();
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        quoteList = [SELECT Id, OwnerId, Freight_Terms__c, Freight_Includes__c From SBQQ__Quote__c];
        EmailNotificationOpenQuotesController.openQuotesReport();  
        EmailNotificationOpenQuotesController.leadDetailMapping(quoteList , new Set<Id>{quoteList[0].OwnerId});
        System.assertEquals(1, Limits.getEmailInvocations(), 'An email should have been sent.');
        Test.stopTest();  
    }    
}