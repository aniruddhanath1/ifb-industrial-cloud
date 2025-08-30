public with sharing class DocumentUploaderController {
    @AuraEnabled
    public static void uploadFile(Id recordId, String fileName, String contentDocumentId) {
        try {
            if (String.isBlank(contentDocumentId) || String.isBlank(fileName) || recordId == null) {
                throw new AuraHandledException('Invalid parameters: recordId, fileName, or contentDocumentId is null or empty.');
            }
            
            ContentVersion existingContentVersion = [
                SELECT Id, Title, ContentDocumentId, VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId ORDER BY CreatedDate DESC LIMIT 1
            ];
            
            if (existingContentVersion == null) {
                throw new AuraHandledException('ContentVersion not found for ContentDocumentId: ' + contentDocumentId);
            }
            
            ContentVersion newContentVersion = new ContentVersion();
            newContentVersion.ContentDocumentId = contentDocumentId;
            newContentVersion.Title = fileName;
            newContentVersion.VersionData = existingContentVersion.VersionData;
            newContentVersion.PathOnClient = fileName;
            newContentVersion.IsMajorVersion = false;
            insert newContentVersion;
            
            Integer existingLinks = [SELECT Count() FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentId AND LinkedEntityId = :recordId ];
            
            if (existingLinks == 0) {
                ContentDocumentLink contentDocLink = new ContentDocumentLink();
                contentDocLink.ContentDocumentId = newContentVersion.ContentDocumentId;
                contentDocLink.LinkedEntityId = recordId;
                contentDocLink.ShareType = ConstantUtilities.ShareType;
                contentDocLink.Visibility = ConstantUtilities.Visibility;
                insert contentDocLink;
            } else {
            }
        } catch (Exception e) {
            ExceptionHandler.logException('DocumentUploaderController', 'uploadFile', e);
            throw new AuraHandledException('Error in DocumentUploaderController.uploadFile: ' + e.getMessage());
        }
    }
}