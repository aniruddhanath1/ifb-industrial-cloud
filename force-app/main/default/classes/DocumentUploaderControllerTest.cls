@isTest
public class DocumentUploaderControllerTest {
    
    @isTest
    static void testUploadFile() {
        // Create a test record to link the file to
        Account testAccount =TestDataFactory.createAccount();      
        // Create an initial ContentVersion for testing
        ContentVersion initialContentVersion =TestDataFactory.CreateContentVersion();
        
        // Commit the transaction to ensure the ContentDocument is created
        // Query the ContentDocument associated with the ContentVersion
        List<ContentDocument> contentDocuments = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :initialContentVersion.Id)
        ];
        
        System.assertEquals(1, contentDocuments.size(), 'ContentDocument should be created.');
        Id contentDocumentId = contentDocuments[0].Id;
        try {
            Test.startTest();
            DocumentUploaderController.uploadFile(testAccount.Id, 'UpdatedFile.txt', contentDocumentId);
            Test.stopTest();
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Script-thrown exception'), e.getMessage());
            
        }
        
        // Verify that a new ContentVersion was created with the updated Title
        List<ContentVersion> contentVersions = [
            SELECT Id, Title
            FROM ContentVersion
            WHERE ContentDocumentId = :contentDocumentId
            ORDER BY CreatedDate DESC
        ];
        System.assert(contentVersions.size() > 1, 'There should be more than one ContentVersion.');        
        // Verify that the ContentDocumentLink was created
        List<ContentDocumentLink> contentDocLinks = [
            SELECT Id, ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE ContentDocumentId = :contentDocumentId AND LinkedEntityId = :testAccount.Id
        ];
        
    }
    
    
    @isTest
    static void testUploadFileWithInvalidParameters() {
        // Create a test record to link the file to
        Account testAccount =TestDataFactory.createAccount();      
        // Create an initial ContentVersion for testing
        ContentVersion initialContentVersion =TestDataFactory.CreateContentVersion();       
        // Commit the transaction to ensure the ContentDocument is created
        // Query the ContentDocument associated with the ContentVersion
        List<ContentDocument> contentDocuments = [
            SELECT Id 
            FROM ContentDocument 
            WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :initialContentVersion.Id)
        ];
        
        System.assertEquals(1, contentDocuments.size(), 'ContentDocument should be created.');
        Id contentDocumentId = contentDocuments[0].Id;
        
        try {
            Test.startTest();
            DocumentUploaderController.uploadFile(testAccount.Id, '', contentDocumentId);
            Test.stopTest();
            System.assert(false, 'An AuraHandledException should have been thrown for an empty fileName.');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Script-thrown exception'), e.getMessage());
            
        }
        
    }
}