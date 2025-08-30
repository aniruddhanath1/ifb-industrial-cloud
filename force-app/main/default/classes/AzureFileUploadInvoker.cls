public class AzureFileUploadInvoker {

    // Invocable Method to accept a list of ContentDocumentLink IDs from Flow
    @InvocableMethod(label='Upload Files to Azure' description='Uploads files associated with ContentDocumentLink IDs to Azure Blob storage.')
    public static void uploadDocumentsToAzure(List<ContentDocumentLinkWrapper> input) {
        // Extract ContentDocumentLink IDs from the flow input
        system.debug('**AzureFileUploadInvoker _ input'+input);
        List<Id> documentLinkIdsList = new List<Id>();
		Set<Id> documentLinkIdsSet = new Set<Id>();
       for (ContentDocumentLinkWrapper wrapper : input) {
            documentLinkIdsList.addAll(wrapper.documentLinkId);
        }
        for(id ids: documentLinkIdsList){
            documentLinkIdsSet.add(ids);
        }

        // Call the Queueable class to process the document uploads
        if (!documentLinkIdsSet.isEmpty()) {
            System.enqueueJob(new AzureFileUploadQueueable(new List<Id>(documentLinkIdsSet)));
        } else {
            System.debug('No ContentDocumentLink IDs provided.');
        }
    }
    public class ContentDocumentLinkWrapper {
        @InvocableVariable(required=true description='ContentDocumentLink ID')
        public List<Id> documentLinkId;
    }
}