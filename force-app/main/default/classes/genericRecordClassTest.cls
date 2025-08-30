@isTest
public class genericRecordClassTest {
    
    @testSetup
    public static void setUpData(){
        Account account = TestDataFactory.createAccount();
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        TestDataFactory.createPriceBook2('Industrial Washing Machine');
        Opportunity opp = TestDataFactory.createOpportunityConditionaly(account.Id,'Prospecting', false);
        opp.BOQ_URS_Approved__c = true;
        opp.Product_Category__c = 'IDW';
        Insert opp;
        List<User> testUsers = new List<User>();
       
        for (Integer i = 0; i < 10; i++) {
            User user = TestDataFactory.createUserNotInsertedForBulk([SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id, i);
            testUsers.add(user);
        }
        insert testUsers;
    }
    
    @isTest
    static void getUserDetailTest() {
        List<User> testUsers = [SELECT Id From User];
        try{
            List<User> result0 = genericRecordClass.getUserDetails('Test@', 'User@');
            System.assertEquals(null, result0);
        }catch(DmlException exp){ 
            
        } 
        
        Opportunity opp = [SELECT Id, name From Opportunity Limit 1];
        Account account = [SELECT Id, name From Account Limit 1];
        List<Contact> contactList = genericRecordClass.getContactDetails(opp.name,opp.Id);
        System.assertEquals(0, contactList.size(), 'List Should Empty. ');
        Test.startTest();
        genericRecordClass.getContactDetails(opp.name,account.Id);
        Test.stopTest();
    }
}