public class AzureBlobUploader {

    public static String uploadDocumentToAzure(String fileNames,String fileBlob,String fileType) {
        try {
            String accountName = System.Label.Azure_AccountName;
            String accountKey = System.Label.Azure_AccountKey;
            String containerName = System.Label.Azure_ContainerName;
            String endpointSuffix = System.Label.Azure_EndpointSuffix;
            String SASToken = System.Label.Azure_SASToken; 
            
            Blob fileBody =  EncodingUtil.base64Decode(fileBlob);
            String timestamp = DateTime.now().getTime().toString();
            String fileName = fileNames+'.'+fileType.replace('/','.');
            String blobUrl = 'https://' + accountName + '.blob.' + endpointSuffix + '/' + containerName + '/' + fileName;
            System.debug('blobUrl--->'+blobUrl);
            String dateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss') + ' GMT';
            String storageAuthorizationHeader = generateAuthorizationHeader(accountName, accountKey, fileBody, containerName, fileName, dateString);

            HttpRequest req = new HttpRequest();
            req.setMethod('PUT');
            req.setEndpoint(blobUrl);
            req.setHeader('x-ms-blob-type', 'BlockBlob');
            req.setHeader('x-ms-date', dateString);
            req.setHeader('x-ms-version', '2020-10-02');  // Use the appropriate API version
            req.setHeader('Authorization', storageAuthorizationHeader);
            req.setHeader('Content-Type', 'application/octet-stream');
            req.setHeader('Content-Length', String.valueOf(fileBody.size()));
            req.setBodyAsBlob(fileBody);

            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('Response: ' + res);
            System.debug('Response Status: ' + res.getStatus());
            System.debug('Response Body: ' + res.getBody());
            //String sasToken=AzureSASGenerator.generateSasToken(containerName, fileName, 20);
            if(res.getStatusCode() == 201){
                return blobUrl+'?'+SASToken;
            }
            return null;
            
        } catch (Exception e) {
           ExceptionHandler.logException('AzureBlobUploader' , 'uploadDocumentToAzure', e);
            return null;
        }
    }

    private static String generateAuthorizationHeader(String accountName, String accountKey, Blob fileBody, String containerName, String fileName, String dateString) {
        String stringToSign = 'PUT\n\n\n' + fileBody.size() + '\n\napplication/octet-stream\n\n\n\n\n\n\nx-ms-blob-type:BlockBlob\nx-ms-date:' + dateString + '\nx-ms-version:2020-10-02\n/' + accountName + '/' + containerName + '/' + fileName;
        Blob mac = Crypto.generateMac('HMACSHA256', Blob.valueOf(stringToSign), EncodingUtil.base64Decode(accountKey));
        String signature = EncodingUtil.base64Encode(mac);
        return 'SharedKey ' + accountName + ':' + signature;
    }
    public static void handleFileUploadToAzure(ContentDocumentLink cdl){
        ContentVersion contentVersion = [SELECT Id, ContentDocumentId, Title, FileType, VersionData,FileExtension FROM ContentVersion WHERE ContentDocumentId = :cdl.ContentDocumentId limit 1];
        if(contentVersion != null){
            String fileblob = EncodingUtil.base64Encode(contentVersion.VersionData);
            String fileUrl = AzureBlobUploader.uploadDocumentToAzure(contentVersion.Title,EncodingUtil.base64Encode(contentVersion.VersionData), contentVersion.FileExtension);
            System.debug('**fileUrl'+fileUrl);
            if(fileUrl != null){
                if(String.valueOf((cdl.LinkedEntityId).getsobjecttype()) == ConstantUtilities.EXPENSELINEITEM){
                    update new Expense_Line_Item__c(Id = cdl.LinkedEntityId, Bill_Link__c = fileUrl);
                }else if(String.valueOf((cdl.LinkedEntityId).getsobjecttype()) == ConstantUtilities.ORDER){
                    if((contentVersion.Title).contains('PO_')){
                       update new Order(Id = cdl.LinkedEntityId, PO_Link__c = fileUrl,PO_Received__c = true); 
                    }else if((contentVersion.Title).contains('GST_')){
                       update new Order(Id = cdl.LinkedEntityId, GST_Doc_Link__c = fileUrl,GST_Certificate_Provided__c = true); 
                    }else if((contentVersion.Title).contains('PAN_')){
                        update new Order(Id = cdl.LinkedEntityId, PAN_Doc_Link__c = fileUrl,PAN_Card_Provided__c = true);
                    }
                    
                }else if(String.valueOf((cdl.LinkedEntityId).getsobjecttype()) == ConstantUtilities.ORDERINSTALLMENT){
                    update new Order_Installment__c(Id = cdl.LinkedEntityId, Transaction_Proof_Link__c = fileUrl);
                }
            }
        }
    }
}