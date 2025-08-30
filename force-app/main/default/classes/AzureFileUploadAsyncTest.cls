@isTest
public class AzureFileUploadAsyncTest {
    @testSetup
    public static void dataSetup(){
        
        Account insertedAcc = TestDataFactory.createAccount();
        Expense__c expenseObj = TestDataFactory.createExpenseRecord();
        Expense_Line_Item__c expenseLITObj = TestDataFactory.expenseLineIteamRecord(expenseObj.Id);
        TestDataFactory.contentDocumentLinkInsert(expenseLITObj.Id);
        Order orderObj = TestDataFactory.createTestOrderConditionaly(insertedAcc.Id,true);
        TestDataFactory.contentDocumentLinkInsert(orderObj.Id);
        Order_Installment__c orderInsObj = TestDataFactory.orderInstallmentRecordCreation(orderObj.Id);
        TestDataFactory.contentDocumentLinkInsert(orderInsObj.Id);
        
    }
    
    @isTest
    public static void runQueuebleJob(){
        
        Expense_Line_Item__c expenseLITObj = [SELECT Id From Expense_Line_Item__c Limit 1];
        Test.startTest();
        HttpResponse response = new HttpResponse();
        response.setBody('{"stock":"not available"}');
        response.setStatusCode(201);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        ContentDocumentLink contentDocLinkObj = [SELECT Id, ContentDocumentId From ContentDocumentLink WHERE LinkedEntityId =: expenseLITObj.Id Limit 1];
        AzureFileUploadQueueable azureFileUploadControllerObj = new AzureFileUploadQueueable(new List<Id>{contentDocLinkObj.Id});
        ID jobId = System.enqueueJob(azureFileUploadControllerObj);
        Test.stopTest();
        AsyncApexJob job = [SELECT Id, Status, JobType, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId LIMIT 1];
        System.assertEquals('Queueable', job.JobType, 'The job type should be Queueable.');
        
    }
    
    @isTest
    public static void runQueuebleJobAgain(){
        
        Order orderObj = [SELECT Id From Order Limit 1];
        Test.startTest();
        HttpResponse response = new HttpResponse();
        response.setBody('{"stock":"not available"}');
        response.setStatusCode(201);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        ContentDocumentLink contentDocLinkObj = [SELECT Id, ContentDocumentId From ContentDocumentLink WHERE LinkedEntityId =: orderObj.Id Limit 1];
        AzureFileUploadQueueable azureFileUploadControllerObj = new AzureFileUploadQueueable(new List<Id>{contentDocLinkObj.Id});
        ID jobId = System.enqueueJob(azureFileUploadControllerObj);
        Test.stopTest();
        AsyncApexJob job = [SELECT Id, Status, JobType, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId LIMIT 1];
        System.assertEquals('Queueable', job.JobType, 'The job type should be Queueable.');
        
    }
    
    @isTest
    public static void runQueuebleJobAgainOneFile(){
        
        Order_Installment__c orderInsObj = [SELECT Id From Order_Installment__c Limit 1];
        Test.startTest();
        HttpResponse response = new HttpResponse();
        response.setBody('{"stock":"not available"}');
        response.setStatusCode(201);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        ContentDocumentLink contentDocLinkObj = [SELECT Id, ContentDocumentId From ContentDocumentLink WHERE LinkedEntityId =: orderInsObj.Id Limit 1];
        AzureFileUploadQueueable azureFileUploadControllerObj = new AzureFileUploadQueueable(new List<Id>{contentDocLinkObj.Id});
        ID jobId = System.enqueueJob(azureFileUploadControllerObj);
        Test.stopTest();
        AsyncApexJob job = [SELECT Id, Status, JobType, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId LIMIT 1];
        System.assertEquals('Queueable', job.JobType, 'The job type should be Queueable.');
        
    }
    
    @isTest
    public static void runQueuebleJobWithoutOneFile(){
        
        Order_Installment__c orderInsObj = [SELECT Id From Order_Installment__c Limit 1];
        Test.startTest();
        HttpResponse response = new HttpResponse();
        response.setBody('{"stock":"not available"}');
        response.setStatusCode(201);
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        ContentDocumentLink contentDocLinkObj = [SELECT Id, ContentDocumentId From ContentDocumentLink WHERE LinkedEntityId =: orderInsObj.Id Limit 1];
        AzureFileUploadQueueable azureFileUploadControllerObj = new AzureFileUploadQueueable(new List<Id>{contentDocLinkObj.Id});
        ID jobId = System.enqueueJob(azureFileUploadControllerObj);
        Test.stopTest();
        AsyncApexJob job = [SELECT Id, Status, JobType, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId LIMIT 1];
        System.assertEquals('Queueable', job.JobType, 'The job type should be Queueable.');
        
    }
    
    @isTest
    public static void runQueuebleJobWithoutWrongStatus(){
        
        Order_Installment__c orderInsObj = [SELECT Id From Order_Installment__c Limit 1];
        Test.startTest();
        HttpResponse response = new HttpResponse();
        response.setBody('{"stock":"not available"}');
        response.setStatusCode(500);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(response));
        ContentDocumentLink contentDocLinkObj = [SELECT Id, ContentDocumentId From ContentDocumentLink WHERE LinkedEntityId =: orderInsObj.Id Limit 1];
        AzureFileUploadQueueable azureFileUploadControllerObj = new AzureFileUploadQueueable(new List<Id>{contentDocLinkObj.Id});
        ID jobId = System.enqueueJob(azureFileUploadControllerObj);
        Test.stopTest();
        AsyncApexJob job = [SELECT Id, Status, JobType, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId LIMIT 1];
        System.assertEquals('Queueable', job.JobType, 'The job type should be Queueable.');
        
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