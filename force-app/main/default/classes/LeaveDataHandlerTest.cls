@isTest 
public class LeaveDataHandlerTest {
    @testSetup
    public static void testDataSetup(){
        API_Configuration__c apiConfigObj2 = TestDataFactory.createAPIConfigRecordSingal(false);
        apiConfigObj2.Parent_Object_Name__c = null;
        apiConfigObj2.Object_Name__c = 'Expense__c';
        apiConfigObj2.Include_Files__c = false;
        apiConfigObj2.Field_API_Name__c = 'Advance_Amount__c';
        apiConfigObj2.JSON_Key__c = 'startDate';
        apiConfigObj2.API_Type__c = 'LeaveUpdate';
        apiConfigObj2.Data_Type__c = 'Date';
        Insert apiConfigObj2;
        
        apiConfigObj2 = TestDataFactory.createAPIConfigRecordSingal(false);
        apiConfigObj2.Parent_Object_Name__c = null;
        apiConfigObj2.Object_Name__c = 'Expense__c';
        apiConfigObj2.Include_Files__c = false;
        apiConfigObj2.Field_API_Name__c = 'Advance_Amount__c';
        apiConfigObj2.JSON_Key__c = 'status';
        apiConfigObj2.API_Type__c = 'LeaveUpdate';
        apiConfigObj2.Data_Type__c = 'Integer';
        Insert apiConfigObj2;
        
        apiConfigObj2 = TestDataFactory.createAPIConfigRecordSingal(false);
        apiConfigObj2.Parent_Object_Name__c = null;
        apiConfigObj2.Object_Name__c = 'Expense__c';
        apiConfigObj2.Include_Files__c = false;
        apiConfigObj2.Field_API_Name__c = 'Advance_Amount__c';
        apiConfigObj2.JSON_Key__c = 'temp';
        apiConfigObj2.API_Type__c = 'LeaveUpdate';
        apiConfigObj2.Data_Type__c = 'Boolean';
        Insert apiConfigObj2;
        
        TestDataFactory.createEventRecordConditionaly(true);
        
    }
    
    @isTest
    public static void testSendLeaveRequest(){
        Test.startTest();
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"data": [{"startDate": "2024-09-22T08:00:00.000Z", "endDate": "2024-09-22T17:00:00.000Z", "status": "Approved"}]}');
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));
        LeaveDataHandler.sendLeaveRequest(new List<String>{'test'}, 1, 1);
        Test.stopTest();
        List<Log__c> logErrorObj = [SELECT Id From Log__c];
        System.assert(logErrorObj.size() > 0,'List Should Not Empty.');
    }
    
    @isTest
    public static void testHandleLeaveData(){
        List<Event> eventList = new List<Event>();
        eventList = [SELECT Id, Employee_Code__c, ActivityDate, Type From Event];
        LeaveDataHandler.upsertEvents(eventList);
        
        List<Object> leaveDataList = new List<Object>();
        // Create a map for each leave entry
        Map<String, Object> leaveEntry1 = new Map<String, Object>();
        leaveEntry1.put('startDate', '2024-09-22T08:00:00.000Z');
        leaveEntry1.put('endDate', '2024-09-22T17:00:00.000Z');
        leaveEntry1.put('status', '1');
        leaveEntry1.put('temp', true);
        leaveDataList.add(leaveEntry1);
        
        // You can add more entries as needed
        Map<String, Object> leaveEntry2 = new Map<String, Object>();
        leaveEntry2.put('startDate', '2024-09-23T08:00:00.000Z');
        leaveEntry2.put('endDate', '2024-09-23T17:00:00.000Z');
        leaveEntry2.put('status', '1');
        leaveEntry2.put('temp', true);
        leaveDataList.add(leaveEntry2);
        
        Map<String, Object> tempMap = new Map<String, Object>();
        tempMap.put('Data',leaveDataList);
        String str = JSON.serialize(tempMap);
        Test.startTest();
        LeaveDataHandler.handleLeaveData(str);
        Test.stopTest();
        List<Log__c> logErrorObj = [SELECT Id From Log__c];
        System.assert(logErrorObj.size() > 0,'List Should Not Empty.');
        Delete [SELECT Id From API_Configuration__c]; 
        LeaveDataHandler.handleLeaveData(str);
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