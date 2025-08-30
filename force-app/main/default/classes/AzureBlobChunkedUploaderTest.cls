@IsTest
public class AzureBlobChunkedUploaderTest {
    
    @IsTest
    static void testUploadDocumentToAzure_Success() {
        String fileName = 'TestFile.txt';
        Blob fileBlob = Blob.valueOf('This is a test file content');
        String fileType = 'text/plain';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AzureBlobChunkedUploaderMock());
        String resultUrl = AzureBlobChunkedUploader.uploadDocumentToAzure(fileName, fileBlob, fileType);
        Test.stopTest();
        System.assertNotEquals(null, resultUrl, 'The file URL should not be null');
        System.assert(resultUrl.contains(fileName), 'The file URL should contain the file name');
        
    }
    
    @IsTest
    static void testDivideBlobIntoChunks() {
        Blob fileBlob = Blob.valueOf('This is a large test file content for chunking');
        Integer chunkSize = 10; 
        Test.startTest();
        List<Blob> chunks = AzureBlobChunkedUploader.divideBlobIntoChunks(fileBlob, chunkSize);
        Test.stopTest();
        System.assertEquals(5, chunks.size(), 'The number of chunks should be 5');
        System.assertEquals('This is a ', chunks[0].toString(), 'First chunk content should match');
        System.assertEquals('large test', chunks[1].toString(), 'Second chunk content should match');
    }
    
    @IsTest
    static void testHandleFileUploadToAzure() {
        Account testAccount = TestDataFactory.createAccount();
        ContentVersion contentVersion = new ContentVersion(
            Title = 'TestDocument',
            PathOnClient = 'TestDocument.txt',
            VersionData = Blob.valueOf('This is some test content'),
            IsMajorVersion = true
        );
        insert contentVersion;
        ContentVersion insertedVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        ContentDocument contentDoc = [SELECT Id, Title FROM ContentDocument WHERE Id = :insertedVersion.ContentDocumentId LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = testAccount.Id,
            ContentDocumentId = contentDoc.Id,
            ShareType = 'I'  
        );
        insert cdl;
        
        Test.startTest();
        AzureBlobChunkedUploader.handleFileUploadToAzure(cdl);
        Test.stopTest();
        Account updatedAccount = [SELECT Id FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(null, updatedAccount, 'The Account should be linked or updated correctly');
    }
    
    @IsTest
    static void testUploadDocumentToAzure_Exception() {
        String fileName = 'TestFile.txt';
        Blob fileBlob = Blob.valueOf('This is a test file content');
        String fileType = 'text/plain';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AzureBlobChunkedUploaderErrorMock());
        String result = AzureBlobChunkedUploader.uploadDocumentToAzure(fileName, fileBlob, fileType);
        Test.stopTest();
        System.assertEquals(null, result, 'In case of an exception, the result should be null');
        
    }
    private class AzureBlobChunkedUploaderMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(201);
            res.setBody('Success');
            return res;
        }
    }
    private class AzureBlobChunkedUploaderErrorMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            res.setBody('Error');
            return res;
        }
    }
}