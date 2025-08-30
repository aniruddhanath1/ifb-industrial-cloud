public class AzureFileUploadBatchable implements Database.Batchable<SObject>, Database.AllowsCallouts  {
    private List<Id> contentDocumentLinkIds;

    public AzureFileUploadBatchable(List<Id> contentDocumentLinkIds) {
        this.contentDocumentLinkIds = contentDocumentLinkIds;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE Id IN :contentDocumentLinkIds]);
    }

    public void execute(Database.BatchableContext BC, List<ContentDocumentLink> scope) {
        for (ContentDocumentLink cdl : scope) {
             system.debug('**AzureFileUploadBatchable _ cdl'+cdl);
            //AzureBlobUploader.handleFileUploadToAzure(cdl);
            AzureBlobChunkedUploader.handleFileUploadToAzure(cdl);
        }
    }

    public void finish(Database.BatchableContext BC) {
        // Any final logic after all jobs have been processed
    }


}