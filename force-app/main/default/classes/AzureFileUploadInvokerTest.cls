@isTest
public class AzureFileUploadInvokerTest {
	@testSetup
    public static void dataSetup(){
       
        Account insertedAcc = TestDataFactory.createAccount();
        Expense__c expenseObj = TestDataFactory.createExpenseRecord();
        Expense_Line_Item__c expenseLITObj = TestDataFactory.expenseLineIteamRecord(expenseObj.Id);
        TestDataFactory.contentDocumentLinkInsert(expenseLITObj.Id);
      
    }
    
    @isTest
    public static void testUploadDocumentsToAzure(){
        
        Expense_Line_Item__c expenseLITObj = [SELECT Id From Expense_Line_Item__c Limit 1];
        ContentDocumentLink contentDocLinkObj = [SELECT Id, ContentDocumentId From ContentDocumentLink WHERE LinkedEntityId =: expenseLITObj.Id Limit 1];
        AzureFileUploadInvoker.ContentDocumentLinkWrapper wrapperObj = new AzureFileUploadInvoker.ContentDocumentLinkWrapper();
        wrapperObj.documentLinkId = new List<Id>{contentDocLinkObj.Id}; 
        AzureFileUploadInvoker.uploadDocumentsToAzure(new List<AzureFileUploadInvoker.ContentDocumentLinkWrapper>{wrapperObj});
        List<AsyncApexJob> jobListNew = [SELECT Id, Status, JobType, TotalJobItems, NumberOfErrors FROM AsyncApexJob];
        System.assert(jobListNew.size() > 0, 'From there Should be call AzureFileUploadQueueable Queueable class ');
    }
}