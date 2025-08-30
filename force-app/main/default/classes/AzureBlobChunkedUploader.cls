public class AzureBlobChunkedUploader {
    // Method to upload document to Azure with chunking
    public static String uploadDocumentToAzure(String fileName, Blob fileBlob, String fileType) {
        try {
            String accountName = System.Label.Azure_AccountName;
            String accountKey = System.Label.Azure_AccountKey;
            String containerName = System.Label.Azure_ContainerName;
            String endpointSuffix = System.Label.Azure_EndpointSuffix;
            String sasToken = System.Label.Azure_SASToken; // Assuming SAS Token is already configured
            Integer chunkSize = 4 * 1024 * 1024; // 4 MB

            // Divide the original blob into smaller chunks
            List<Blob> blobChunks = divideBlobIntoChunks(fileBlob, chunkSize);
            List<String> blockList = new List<String>();

            // Upload each chunk
            Integer blockIdCounter = 0;
            String blobUrl = 'https://' + accountName + '.blob.' + endpointSuffix + '/' + containerName + '/' + fileName;

            for (Blob chunk : blobChunks) {
                // Generate block ID
                String blockId = EncodingUtil.base64Encode(Blob.valueOf(String.valueOf(blockIdCounter++)));
                blockList.add(blockId);

                // Upload the chunk (block)
                System.debug('Uploading block ID: ' + blockId);
                uploadBlockToAzure(blobUrl, blockId, chunk, accountName, accountKey, containerName, fileName);
            }

            // Commit the uploaded blocks to create the full blob
            System.debug('Committing block list: ' + blockList);
            commitBlob(blobUrl, blockList, accountName, accountKey, containerName, fileName);

            // Return the file URL with SAS Token for access
            String fileUrl = blobUrl + '?' + sasToken;
            System.debug('File URL: ' + fileUrl);
            return fileUrl;

        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            ExceptionHandler.logException('AzureBlobChunkedUploader' , 'uploadDocumentToAzure', e);
            return null;
        }
    }

    // Method to divide the blob into chunks
    public static List<Blob> divideBlobIntoChunks(Blob originalBlob, Integer chunkSize) {
                // Get the total size of the blob
        Integer blobSize = originalBlob.size();
        
        // Initialize a list to hold the smaller blob chunks
        List<Blob> blobChunks = new List<Blob>();

        // Start at the beginning of the blob and divide it into chunks
        for (Integer startPosition = 0; startPosition < blobSize; startPosition += chunkSize) {
            // Calculate the end position for each chunk
            Integer endPosition = Math.min(startPosition + chunkSize, blobSize);
            
            // Extract the chunk from the original blob
            Blob chunk = Blob.valueOf(originalBlob.toString().substring(startPosition, endPosition));
            
            // Add the chunk to the list
            blobChunks.add(chunk);
        }

        // Return the list of chunks
        return blobChunks;
    }

    // Helper method to generate authorization header for Azure
    private static String generateAuthorizationHeader(String accountName, String accountKey, Blob fileBody, String containerName, String fileName, String dateString, String blockId) {
        // Canonicalized resource including blockid and comp:block
        String canonicalizedResource = '/' + accountName + '/' + containerName + '/' + fileName + '\nblockid:' + blockId + '\ncomp:block';

        // Canonicalized headers (x-ms- headers sorted alphabetically)
        String canonicalizedHeaders = 'x-ms-blob-type:BlockBlob\n' +
                                      'x-ms-date:' + dateString + '\n' +
                                      'x-ms-version:2020-10-02\n';

        // Construct the string to sign based on Azure's specification
        String stringToSign = 'PUT\n' +  // HTTP Verb
                              '\n' +  // Content-Encoding (empty)
                              '\n' +  // Content-Language (empty)
                              fileBody.size() + '\n' +  // Content-Length
                              '\n' +  // Content-MD5 (empty)
                              'application/octet-stream\n' +  // Content-Type
                              '\n' +  // Date (use x-ms-date instead)
                              '\n' +  // If-Modified-Since (empty)
                              '\n' +  // If-Match (empty)
                              '\n' +  // If-None-Match (empty)
                              '\n' +  // If-Unmodified-Since (empty)
                              '\n' +  // Range (empty)
                              canonicalizedHeaders +  // Canonicalized Headers
                              canonicalizedResource;  // Canonicalized Resource

        // Generate the HMAC-SHA256 signature
        Blob mac = Crypto.generateMac('HMACSHA256', Blob.valueOf(stringToSign), EncodingUtil.base64Decode(accountKey));
        String signature = EncodingUtil.base64Encode(mac);
        return 'SharedKey ' + accountName + ':' + signature;
    }

    // Helper method to upload each block (chunk)
    private static void uploadBlockToAzure(String blobUrl, String blockId, Blob chunk, String accountName, String accountKey, String containerName, String fileName) {
        try {
            String dateString = DateTime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');

            // Generate the authorization header
            String authHeader = generateAuthorizationHeader(accountName, accountKey, chunk, containerName, fileName, dateString, blockId);

            HttpRequest req = new HttpRequest();
            req.setMethod('PUT');
            req.setEndpoint(blobUrl + '?comp=block&blockid=' + blockId);
            req.setHeader('x-ms-blob-type', 'BlockBlob');
            req.setHeader('x-ms-date', dateString);
            req.setHeader('x-ms-version', '2020-10-02');
            req.setHeader('Authorization', authHeader);
            req.setHeader('Content-Type', 'application/octet-stream');
            req.setHeader('Content-Length', String.valueOf(chunk.size()));
            req.setBodyAsBlob(chunk);

            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() != 201) {
                throw new CalloutException('Error uploading block: ' + res.getBody());
            }

        } catch (Exception e) {
            ExceptionHandler.logException('AzureBlobChunkedUploader' , 'uploadBlockToAzure', e);
            throw e;
        }
    }

    // Helper method to commit the blocks and finalize the upload
    private static void commitBlob(String blobUrl, List<String> blockList, String accountName, String accountKey, String containerName, String fileName) {
        try {
            String dateString = DateTime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
            String blockListXml = '<BlockList>';
            for (String block : blockList) {
                blockListXml += '<Latest>' + block + '</Latest>';
            }
            blockListXml += '</BlockList>';

            // Canonicalized resource including comp=blocklist
            String canonicalizedResource = '/' + accountName + '/' + containerName + '/' + fileName + '\ncomp:blocklist';

            // Canonicalized headers
            String canonicalizedHeaders = 'x-ms-date:' + dateString + '\n' +
                                          'x-ms-version:2020-10-02\n';

            // Construct the string to sign for committing the block list
            String stringToSign = 'PUT\n' +  // HTTP Verb
                                  '\n' +  // Content-Encoding (empty)
                                  '\n' +  // Content-Language (empty)
                                  blockListXml.length() + '\n' +  // Content-Length
                                  '\n' +  // Content-MD5 (empty)
                                  'application/octet-stream\n' +  // Content-Type
                                  '\n' +  // Date (use x-ms-date instead)
                                  '\n' +  // If-Modified-Since (empty)
                                  '\n' +  // If-Match (empty)
                                  '\n' +  // If-None-Match (empty)
                                  '\n' +  // If-Unmodified-Since (empty)
                                  '\n' +  // Range (empty)
                                  canonicalizedHeaders +  // Canonicalized Headers
                                  canonicalizedResource;  // Canonicalized Resource

            // Generate the authorization header for commit
            Blob mac = Crypto.generateMac('HMACSHA256', Blob.valueOf(stringToSign), EncodingUtil.base64Decode(accountKey));
            String signature = EncodingUtil.base64Encode(mac);
            String authHeader = 'SharedKey ' + accountName + ':' + signature;

            // Create the HTTP request for committing the block list
            HttpRequest req = new HttpRequest();
            req.setMethod('PUT');
            req.setEndpoint(blobUrl + '?comp=blocklist');
            req.setHeader('x-ms-date', dateString);
            req.setHeader('x-ms-version', '2020-10-02');
            req.setHeader('Authorization', authHeader);
            req.setHeader('Content-Length', String.valueOf(blockListXml.length()));
            req.setHeader('Content-Type', 'application/octet-stream');
            req.setBody(blockListXml);

            // Send the request and check the response
            Http http = new Http();
            HttpResponse res = http.send(req);
            if (res.getStatusCode() != 201) {
                throw new CalloutException('Error committing block list: ' + res.getBody());
            }

        } catch (Exception e) {
            throw e;
        }
    }
    public static void handleFileUploadToAzure(ContentDocumentLink cdl){
        List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId, Title, FileType, VersionData,FileExtension FROM ContentVersion WHERE ContentDocumentId = :cdl.ContentDocumentId limit 1];
        if(contentVersions != null && !contentVersions.isEmpty()){
            String fileblob = EncodingUtil.base64Encode(contentVersions[0].VersionData);
            String fileUrl = AzureBlobUploader.uploadDocumentToAzure(contentVersions[0].Title,EncodingUtil.base64Encode(contentVersions[0].VersionData), contentVersions[0].FileExtension);
            System.debug('**fileUrl ==> '+fileUrl);
            if(fileUrl != null){
                if(String.valueOf((cdl.LinkedEntityId).getsobjecttype()) == ConstantUtilities.EXPENSELINEITEM){

                    update new Expense_Line_Item__c(Id = cdl.LinkedEntityId, Bill_Link__c = fileUrl);

                }else if(String.valueOf((cdl.LinkedEntityId).getsobjecttype()) == ConstantUtilities.ORDER){
					List<Order> ordersToUpdate = new List<Order>();
                    if(contentVersions[0].Title.startsWithIgnoreCase('PO_')){
						Order ordRecPO = new Order(Id = cdl.LinkedEntityId, PO_Link__c = fileUrl, PO_Received__c = true);
						ordersToUpdate.add(ordRecPO);
                        // update new Order(Id = cdl.LinkedEntityId, PO_Link__c = fileUrl,PO_Received__c = true);
                    }
					else if(contentVersions[0].Title.startsWithIgnoreCase('GST_')){
						Order ordRecGST = new Order(Id = cdl.LinkedEntityId, GST_Doc_Link__c = fileUrl, GST_Certificate_Provided__c = true);
						ordersToUpdate.add(ordRecGST);
                       	// update new Order(Id = cdl.LinkedEntityId, GST_Doc_Link__c = fileUrl,GST_Certificate_Provided__c = true);
                    }
					else if(contentVersions[0].Title.startsWithIgnoreCase('PAN_')){
						Order ordRecPAN = new Order(Id = cdl.LinkedEntityId, PAN_Doc_Link__c = fileUrl, PAN_Card_Provided__c = true);
						ordersToUpdate.add(ordRecPAN);
                        // update new Order(Id = cdl.LinkedEntityId, PAN_Doc_Link__c = fileUrl,PAN_Card_Provided__c = true);
                    }

					System.debug('Orders to update ==> ' + JSON.serializePretty(ordersToUpdate));

					try {
						Database.update(ordersToUpdate, true);
					}
					catch(Exception ex) {
						ExceptionHandler.logException('AzureBlobChunkedUploader', 'handleFileUploadToAzure', ex);
					}
                    
                }else if(String.valueOf((cdl.LinkedEntityId).getsobjecttype()) == ConstantUtilities.ORDERINSTALLMENT){
                    update new Order_Installment__c(Id = cdl.LinkedEntityId, Transaction_Proof_Link__c = fileUrl);
                }
            }
        }
    }
}