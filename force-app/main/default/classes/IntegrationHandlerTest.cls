@isTest
public class IntegrationHandlerTest {
    
    @testSetup
    static void setup() {
        List<Lead> leadObjList = TestDataFactory.getLeadList(1);
        Insert leadObjList;
        
        Expense__c expenseObj = TestDataFactory.createExpenseRecord();
        TestDataFactory.expenseLineIteamRecord(expenseObj.Id);
        API_Configuration__c apiConfigObj1 = TestDataFactory.createAPIConfigRecordSingal(false);
        apiConfigObj1.Parent_Object_Name__c = 'Expense__c';
        apiConfigObj1.Object_Name__c = 'Expense_Line_Item__c';
        apiConfigObj1.Include_Files__c = false;
        apiConfigObj1.Field_API_Name__c = 'Approved_Amount__c';
        apiConfigObj1.JSON_Key__c = 'test';
        apiConfigObj1.API_Type__c = 'Expense Sync Request';
        Insert apiConfigObj1;
        
        API_Configuration__c apiConfigObj2 = TestDataFactory.createAPIConfigRecordSingal(false);
        apiConfigObj2.Parent_Object_Name__c = null;
        apiConfigObj2.Object_Name__c = 'Expense__c';
        apiConfigObj2.Include_Files__c = false;
        apiConfigObj2.Field_API_Name__c = 'Advance_Amount__c';
        apiConfigObj2.JSON_Key__c = 'test';
        apiConfigObj2.API_Type__c = 'Expense Sync Request';
        Insert apiConfigObj2;
        
        API_Configuration__c apiConfigObj3 = TestDataFactory.createAPIConfigRecordSingal(false);
        apiConfigObj3.Parent_Object_Name__c = null;
        apiConfigObj3.Object_Name__c = 'Expense__c';
        apiConfigObj3.Include_Files__c = false;
        apiConfigObj3.Field_API_Name__c = 'Advance_Amount__c';
        apiConfigObj3.JSON_Key__c = 'test';
        apiConfigObj3.API_Type__c = 'Expense Sync Request';
        apiConfigObj3.Include_Files__c = true;
        Insert apiConfigObj3;
        
        TestDataFactory.contentDocumentLinkInsert(expenseObj.Id);
        Account accObj = TestDataFactory.createAccount();
        Order orderObj = TestDataFactory.createTestOrder(accObj.Id);
        Order_Installment__c orderInsObj = TestDataFactory.orderInstallmentRecordCreation(orderObj.Id);
 
    }
    
    @isTest
    public static void sendObejectDataToIFBInternalSysTest(){
        Test.startTest();
        Expense__c expenseObj = [SELECT Id From Expense__c Limit 1];
        IntegrationHandler.sendObejectDataToIFBInternalSys(new List<Id>{expenseObj.Id},'Lead Sync Request');
        Test.stopTest();
        
        Map<Id, Map<String, Object>> assertMap = IntegrationHandler.getFilesForRecords(new List<Id>{expenseObj.Id});
        System.assertEquals(1, assertMap.keySet().size(), 'Map should not empty');
        
        IntegrationHandler.flowInput wrapperObj = new IntegrationHandler.flowInput();
        wrapperObj.idsListToProccess = new List<id>{expenseObj.Id};
            wrapperObj.actionType = 'Expense Sync Request';
        IntegrationHandler.sendObejectDataToIFBInternalSysFromFlow(new List<IntegrationHandler.flowInput>{wrapperObj});
        
        Order orderObj = [SELECT Id From Order Limit 1];
        Order_Installment__c orderInsObj = [SELECT Id From Order_Installment__c Limit 1];
        TestDataFactory.contentDocumentLinkInsert(orderInsObj.Id);
        IntegrationHandler.sendOrderInstallmentDataToIFB(new List<Id>{orderInsObj.Id},'Expense Sync Request');
        try{
            IntegrationHandler.querySobjectWithSelectedField(new List<Id>(), new Set<String>(), new Map<String, Map<String, String>>(),new Map<String, String>(),'Retrieve');
        }catch(IllegalArgumentException exp){
            try{
            IntegrationHandler.querySobjectWithSelectedField(new List<Id>{orderInsObj.Id}, new Set<String>(), new Map<String, Map<String, String>>(),new Map<String, String>(),'Retrieve');
            }catch(IllegalArgumentException exp1){
                
            }
        }
        
    }
    
    @isTest
    static void testMakeHttpCallout() {
        // Test HTTP callout method separately
        String endpoint = 'https://example.com/api';
        String httpMethod = 'POST';
        String token = 'testToken';
        String requestBody = '{"test": "data"}';
        
        Test.startTest();
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"success": true}');
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        IntegrationHandler.generateToken([SELECT Id, Token_Generation_URL__c, Token_Http_Method__c, Token_Request_Body__c From Integration_Handler__mdt Limit 1]);
        HttpResponse response = IntegrationHandler.makeHttpCallout(endpoint, httpMethod, token, requestBody);
        Test.stopTest();
        System.assertEquals(200, response.getStatusCode(), 'Status code should be 200');
        System.assertEquals('{"success": true}', response.getBody(), 'Response body should match mock response');   
    }
    
    // Mock class for HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse response;
        
        public MockHttpResponseGenerator(HttpResponse response) {
            this.response = response;
        }
        
        public HttpResponse respond(HttpRequest req) {
            return response;
        }
    }
}