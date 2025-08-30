@isTest
public class CheckStockAvailabilityControllerTest {
	
    @TestSetup
    public static void setupData(){
        TestDataFactory.createProduct2();
        TestDataFactory.createFacilityRecord();
    }
    
    @isTest
    public static void testClassMethods(){
        Test.startTest();
        HttpResponse response = new HttpResponse();
        response.setBody('{"stock":"available"}');
        response.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        String stockResult = CheckStockAvailabilityController.getStockAvailability('Test','Test','Test','Test');
        System.assertEquals('{"stock":"available"}', stockResult);
        CheckStockAvailabilityController.getOptionWrapper();
        Test.stopTest(); 
    }
    
    @isTest
    public static void testClassMethodsOne(){
        Test.startTest();
        HttpResponse response = new HttpResponse();
        response.setBody('{"stock":"not available"}');
        response.setStatusCode(500);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        try{
            String stockResult = CheckStockAvailabilityController.getStockAvailability('Test','Test','Test','Test');
            System.assertEquals('{"stock":"available"}', stockResult);
        }catch(AuraHandledException exp){
            
        }
        
        Test.stopTest(); 
    }
    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse response;
        public MockHttpResponseGenerator(HttpResponse response) {
            this.response = response;
        }
        
        public HttpResponse respond(HttpRequest req) {
            return response;
        }
    }
}