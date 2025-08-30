public class AzureFileUploadQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> contentDocumentLinkIds;

    public AzureFileUploadQueueable(List<Id> contentDocumentLinkIds) {
        this.contentDocumentLinkIds = contentDocumentLinkIds;
        system.debug('**AzureFileUploadQueueable _ contentDocumentLinkIds'+contentDocumentLinkIds);
    }

    public void execute(QueueableContext context) {
        if (!contentDocumentLinkIds.isEmpty()) {
            String jobid = Database.executeBatch(new AzureFileUploadBatchable(contentDocumentLinkIds), 1);
        } else {
            System.debug('No ContentDocumentLink IDs provided.');
        }
    }
    
}