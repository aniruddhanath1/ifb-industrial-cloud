@isTest 
public class Account360ControllerTest {
    
    TestMethod  static void getAccountDataTest(){
        Account insertedAcc = TestDataFactory.createAccount();
        Profile prof = [Select Id From Profile Where Name='System Administrator' LIMIT 1];
        User usr = TestDataFactory.createUserNotInserted(prof.Id, null);
        insert usr;
        Product2 prodObj = TestDataFactory.createProduct2();
        Opportunity opp = TestDataFactory.createOpportunityForAccount(insertedAcc.Id,'Prospecting',usr);
        SBQQ__Quote__c quote = TestDataFactory.createQuote(opp);
        SBQQ__QuoteLine__c quoteLineObj = TestDataFactory.createQuoteLine(quote.Id,false,1,prodObj.Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMockHttpResponseGenerator());
        Account360Controller.getAccountData(insertedAcc.Id);
        try{
            Account360Controller.getAccountData(Null);
            System.assert(false, 'Expected AuraHandledException was not thrown');
        }catch(AuraHandledException ex){
            System.assert(ex.getMessage().contains('Script-thrown exception'), ex.getMessage());
        }
        
        Test.stopTest();
        
    }
    
    private class MyMockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"message":"Success"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testGetRedAccountData_True(){
        List<Map<String,String>> compMapList = new List<Map<String,String>>();
        for (Integer i = 0; i < 3; i++){
            Map<String, String> complaint = new Map<String, String>();
            complaint.put('callType', 'Service Call');
            complaint.put('status', 'Assigned');
            compMapList.add(complaint);
        }
        Account redAccount = new Account(Name = 'Red Flag Account', Is_Red_Flag__c = 'Yes',BillingPostalCode='172771');
        insert redAccount;
        Test.startTest();
        Account360Controller.checkComp(redAccount.Id,compMapList);
        Test.stopTest();
    }
    
}