@isTest 
public class EmailNotificatonOnOpportunityContTest {
    
    @testSetup
    public static void EmailNotificatonOnOpportunityClass(){
        Account account = TestDataFactory.createAccount();
        System.assertEquals('Site', account.Type, 'Site');
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        System.runAs(userObj){
            Opportunity oppoorunity = TestDataFactory.createOpportunityForAccount(account.Id,'Prospecting',userObj);
            System.assertEquals('New', oppoorunity.Type, 'New');
            Opportunity oppoorunity1 = TestDataFactory.createOpportunityForAccount(account.Id,'Prospecting',userObj);
        }
    }
    
    @isTest 
    public static void testopportunityStageReport(){
        Test.startTest();
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        System.runAs(userObj){
            List<Opportunity> oppList = new List<Opportunity>();
            oppList = [SELECT Id, OwnerId, Name, StageName, CloseDate From Opportunity];
            EmailNotificationPendingsOppController.opportunityStageReport();
            EmailNotificationPendingsOppController.mapping(oppList, new Set<Id>{UserInfo.getUserId()});
            Test.stopTest();
        }
    }
}