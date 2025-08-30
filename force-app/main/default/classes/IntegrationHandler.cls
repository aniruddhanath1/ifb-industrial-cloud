public without sharing class IntegrationHandler {
    
    //Added by Atul : June 6,2024 : this method will be used to send the objects data to out of salesfroce to IFB internal systems.
    @future(callout=true)
    public static void sendObejectDataToIFBInternalSys(List<Id> idListToProccess, String actionType){
        try{
            system.debug('idListToProccess'+idListToProccess);
            Map<String, String> fieldAPIVsConfigRecMap = new Map<String, String>();
            Map<String, Map<String, String>> childfieldAPIVsConfigRecMap = new Map<String, Map<String, String>>(); 
            Map<String, String> childRealtionshipMap = new Map<String, String>();
            Boolean isFilesIncluded = false;
            String fileJsonLabel;
            List<Sobject> childSobjectList = new List<Sobject>();
            Map<String,Map<String, Object>> mapOfParentObjectDataWithId = new Map<String,Map<String, Object>>();
            Map<String, Map<String, List<Map<String, Object>>>> parentIdVsChildDataList = new Map<String, Map<String, List<Map<String, Object>>>>();
            Map<Id, Map<String, Object>> parentRecordVsFileMap = new Map<Id, Map<String, Object>>();
            //This API_Configuration__c obecjt records are having the field API Name and there json tag value 
            Integration_Handler__mdt integrationHandlerInstance = Integration_Handler__mdt.getInstance(actionType.replace(' ','_'));
            if(integrationHandlerInstance != null && integrationHandlerInstance.Is_Active__c){
                
                for(API_Configuration__c apiConfigInst : [select API_Type__c,Data_Type__c,Field_API_Name__c,JSON_Key__c,Object_Name__c,
                                                          Include_Files__c, Parent_Object_Name__c
                                                          from API_Configuration__c 
                                                          where (Object_Name__c =:String.valueOf(idListToProccess[0].getsobjecttype()) 
                                                                 OR Parent_Object_Name__c =:String.valueOf(idListToProccess[0].getsobjecttype()))
                                                          AND API_Type__c= :actionType])
                {    
                    if(apiConfigInst.Include_Files__c){
                        isFilesIncluded = true; // try to have this thing on custom metadata type records so this additional condition can be eleiminted.  or we can have the another query just to query this specific value.
                        fileJsonLabel = apiConfigInst.JSON_Key__c;
                    }else{
                        //storing parent fields and child fields in respective map to build query.
                        if(apiConfigInst.Parent_Object_Name__c == null){
                            fieldAPIVsConfigRecMap.put(apiConfigInst.Field_API_Name__c, apiConfigInst.JSON_Key__c);
                        }
                        else if(apiConfigInst.Parent_Object_Name__c != null){
                            if(!childfieldAPIVsConfigRecMap.containsKey(apiConfigInst.Object_Name__c)){
                                childfieldAPIVsConfigRecMap.put(apiConfigInst.Object_Name__c, new Map<String, String>{apiConfigInst.Field_API_Name__c => apiConfigInst.JSON_Key__c});
                            }
                            childfieldAPIVsConfigRecMap.get(apiConfigInst.Object_Name__c).put(apiConfigInst.Field_API_Name__c, apiConfigInst.JSON_Key__c);
                        }
                    }
                    
                }
                
                //getting child relationship name to do the query with parent.
                if(!childfieldAPIVsConfigRecMap.isEmpty()){
                    childRealtionshipMap = IntegrationHandler.getChildRelationships(childfieldAPIVsConfigRecMap.keySet(), idListToProccess[0].getsobjecttype());
                }
                
                for(SObject objInst : IntegrationHandler.querySobjectWithSelectedField(idListToProccess, fieldAPIVsConfigRecMap.keySet(),childfieldAPIVsConfigRecMap, childRealtionshipMap,actionType)){
                    Map<String, Object> mapOfobjectData = new Map<String, Object>();
                    
                    //This for loop is storing all the child records in a list to process the json key change out for loop.
                    for(String childObjectAPIName : childfieldAPIVsConfigRecMap.keySet()){
                        if(childRealtionshipMap.containsKey(childObjectAPIName)){
                            if(objInst.getSObjects(childRealtionshipMap.get(childObjectAPIName)) != null){
                                childSobjectList.addAll(objInst.getSObjects(childRealtionshipMap.get(childObjectAPIName)));
                            }
                            
                        }
                    }
                     for (String fieldAPIName : fieldAPIVsConfigRecMap.keySet()) {
                        List<String> fieldParts = fieldAPIName.split('\\.');
                        if (fieldParts.size() == 1) {
                            if (objInst.get(fieldAPIName) != null) {
                                mapOfobjectData.put(fieldAPIVsConfigRecMap.get(fieldAPIName), objInst.get(fieldAPIName));
                            }
                        } else {
                            SObject parentObj = objInst;
                            Boolean isValid = true;
                            for (Integer i = 0; i < fieldParts.size() - 1; i++) {
                                String relationshipName = fieldParts[i];
                                parentObj = parentObj.getSObject(relationshipName);
                                if (parentObj == null) {
                                    isValid = false;
                                    break;
                                }
                            }
                            if (isValid && parentObj.get(fieldParts[fieldParts.size() - 1]) != null) {
                                mapOfobjectData.put(fieldAPIVsConfigRecMap.get(fieldAPIName), parentObj.get(fieldParts[fieldParts.size() - 1]));
                            }
                        }
                    }
                    mapOfParentObjectDataWithId.put(objInst.id,mapOfobjectData );
                    
                }
                for(Sobject sobjInst : childSobjectList){
                    Map<String, Object> mapOfChildobjectData = new Map<String, Object>();
                    
                    for(string fieldAPIName : childfieldAPIVsConfigRecMap.get(sobjInst.getSobjectType().getDescribe().getName()).keySet()){
                        mapOfChildobjectData.put(childfieldAPIVsConfigRecMap.get(sobjInst.getSobjectType().getDescribe().getName()).get(fieldAPIName), sobjInst.get(fieldAPIName));
                    }
                    if(!parentIdVsChildDataList.containsKey((String)sobjInst.get('Parent_ID_Config__c'))){
                        parentIdVsChildDataList.put((String)sobjInst.get('Parent_ID_Config__c'), new Map<String, List<Map<String, Object>>>());
                    }
                    if(!parentIdVsChildDataList.get((String)sobjInst.get('Parent_ID_Config__c')).containsKey((childRealtionshipMap.get(sobjInst.getSobjectType().getDescribe().getName())).replace('__r', ''))){
                        parentIdVsChildDataList.get((String)sobjInst.get('Parent_ID_Config__c')).put((childRealtionshipMap.get(sobjInst.getSobjectType().getDescribe().getName())).replace('__r', ''), new List<Map<String, Object>>{mapOfChildobjectData});
                    }else{
                        parentIdVsChildDataList.get((String)sobjInst.get('Parent_ID_Config__c')).get((childRealtionshipMap.get(sobjInst.getSobjectType().getDescribe().getName())).replace('__r', '')).add(mapOfChildobjectData);
                    }
                }
                //here calling a funcation to get the all related files from parent object.
                if(isFilesIncluded){
                    parentRecordVsFileMap = IntegrationHandler.getFilesForRecords(idListToProccess);
                }
                for(String parentId : mapOfParentObjectDataWithId.keySet()){
                    if(parentRecordVsFileMap.containsKey(parentId) && isFilesIncluded){
                        mapOfParentObjectDataWithId.get(parentId).put(fileJsonLabel,parentRecordVsFileMap.get(parentId).values());
                    }
                    if(parentIdVsChildDataList.containsKey(parentId)){
                        mapOfParentObjectDataWithId.get(parentId).putAll(parentIdVsChildDataList.get(parentId));
                    }
                    
                    
                }
                //Make callout here when we get the details Integration
                String token;
                if( integrationHandlerInstance.is_Static_Token__c ){
                    token = integrationHandlerInstance.Static_Token_Value__c;
                }else{
                    token = IntegrationHandler.generateToken(integrationHandlerInstance);
                }
                IntegrationHandler.makeHttpCallout(integrationHandlerInstance.URL__c, integrationHandlerInstance.Http_Method__c, token, JSON.serialize(mapOfParentObjectDataWithId.values()));
            }else{
                throw new CalloutException('HTTP callout failed: Not able to find any Active Integration handler -custom metadata type for '+actionType +' Record List - '+idListToProccess);
            }
        }catch(Exception e){
            insert Utilities.getExceptionErrorLog('IntegrationHandler' , 'sendObejectDataToIFBInternalSys', e, String.valueOf(idListToProccess));
        }
    }
    
    // Method to make HTTP callouts
    public static HttpResponse makeHttpCallout(String endpoint, String httpMethod, String token, String requestBody) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse res;
        System.debug('request Body-->'+ requestBody);
        try {
            req.setEndpoint(endpoint); 
            req.setMethod(httpMethod);
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setTimeout(120000);
            if (requestBody != null && (httpMethod == 'POST' || httpMethod == 'PUT' || httpMethod == 'PATCH')) {
                req.setBody(requestBody);
            }
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                if(httpMethod == 'POST' || httpMethod == 'PUT' || httpMethod == 'PATCH'){
                    insert Utilities.getInfoLog('IntegrationHandler' , 'sendObejectDataToIFBInternalSys', requestBody,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody());
                } 
                return res;
            } else {
                insert Utilities.getInfoLog('IntegrationHandler' , 'sendObejectDataToIFBInternalSys', requestBody,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody());
                throw new CalloutException('HTTP callout failed with status: ' + res.getStatusCode() + ' and body: ' + res.getBody());
            }
            
        } catch (CalloutException e) {
            throw e;
            
        } catch (Exception e) {
            throw new CalloutException('HTTP callout failed: ' + e.getMessage());
        }
    }
    
    public static List<sObject> querySobjectWithSelectedField(List<Id> ids, Set<String> fieldList, Map<String, Map<String, String>> childFieldRecordMap, Map<String, String>  childRealtionshipMap, String actionType){
        if (ids == null || ids.isEmpty()) {
            throw new IllegalArgumentException('The list of Ids cannot be null or empty.');
        }
        if (fieldList == null || fieldList.isEmpty()) {
            throw new IllegalArgumentException('The list of fields cannot be null or empty.');
        }
        String query = 'Select ' + String.join(fieldList, ',') ;
        if(!childFieldRecordMap.isEmpty()){
            
            for(String childObjectName : childFieldRecordMap.keySet()){
                if(actionType == ConstantUtilities.APIType_ExpenseSyncRequest){
                    query += ',( Select Parent_ID_Config__c,' + String.join(childFieldRecordMap.get(childObjectName).KeySet(), ',') + ' From '+ childRealtionshipMap.get(childObjectName) + ' Where Not_From_Travel_System__c = true ' + ')';
                }else{
                    query += ',( Select Parent_ID_Config__c,' + String.join(childFieldRecordMap.get(childObjectName).KeySet(), ',') + ' From '+ childRealtionshipMap.get(childObjectName) +')';
                }
                  
            }
        } 
        query += ' from ' + ids[0].getsobjecttype() + ' where id in :ids';
        return database.queryWithBinds( query, 
                                       new Map<String, Object>{'ids' => (Object)ids}, 
                                       AccessLevel.SYSTEM_MODE
                                      );
    }
   
    public static Map<String, String> getChildRelationships(Set<String> childObjectNames, Schema.SObjectType parentObjectType) {
        Map<String, String> childRelationshipMap = new Map<String, String>();
        Schema.DescribeSObjectResult parentDescribe = parentObjectType.getDescribe();
        List<Schema.ChildRelationship> childRelationships = parentDescribe.getChildRelationships();
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        for (Schema.ChildRelationship childRel : childRelationships) {
            String childSObjectName = childRel.getChildSObject().getDescribe().getName();
            if (childObjectNames.contains(childSObjectName)) {
                childRelationshipMap.put(childSObjectName, childRel.getRelationshipName());
            }
        }
        
        return childRelationshipMap;
    }
	 
    public static Map<Id, Map<String, Object>> getFilesForRecords(List<Id> recordIds) {
        Map<Id, Map<String, Object>> recordFilesMap = new Map<Id, Map<String, Object>>();
        Set<Id> contentDocumentIds = new Set<Id>();
        Map<Id, Id> contentDocumentToRecordMap = new Map<Id, Id>();
        Set<Id> contentVersionIds = new Set<Id>();
        
        List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :recordIds];
        if (contentDocumentLinks.isEmpty()) {
            return recordFilesMap;
        }
        for (ContentDocumentLink cdl : contentDocumentLinks) {
            contentDocumentIds.add(cdl.ContentDocumentId);
            contentDocumentToRecordMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
        }
        List<ContentDocument> contentDocuments = [SELECT Id, LatestPublishedVersionId FROM ContentDocument WHERE Id IN :contentDocumentIds];
        
        if (contentDocuments.isEmpty()) {
            return recordFilesMap;
        }
        
        for (ContentDocument cd : contentDocuments) {
            contentVersionIds.add(cd.LatestPublishedVersionId);
        }
        List<ContentVersion> contentVersions = [SELECT Id, ContentDocumentId, Title, FileType, VersionData FROM ContentVersion WHERE Id IN :contentVersionIds];
        
        if (contentVersions.isEmpty()) {
            return recordFilesMap;
        }
        for (ContentVersion cv : contentVersions) {
            Id recordId = contentDocumentToRecordMap.get(cv.ContentDocumentId);
            if (!recordFilesMap.containsKey(recordId)) {
                recordFilesMap.put(recordId, new Map<String, Object>());
            }
            Map<String, Object> fileData = new Map<String, Object>();
            fileData.put('fileName', cv.Title);
            fileData.put('fileType', cv.FileType);
            fileData.put('fileData', EncodingUtil.base64Encode(cv.VersionData));
            recordFilesMap.get(recordId).put(cv.Id, fileData);
        }
        
        return recordFilesMap;
    }
    
    // Custom exception class for callout errors
    public class CalloutException extends Exception {}
    
    public static string generateToken(Integration_Handler__mdt integrationHandlerInstance){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse res;
        try {
            req.setEndpoint(integrationHandlerInstance.Token_Generation_URL__c); 
            req.setMethod(integrationHandlerInstance.Token_Http_Method__c);
            req.setBody(integrationHandlerInstance.Token_Request_Body__c);
            req.setHeader('Content-Type', 'application/json');
            res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<string, object> responseDataMap = (Map<string, object>)JSON.deserializeUntyped(res.getBody());
                return String.valueOf(responseDataMap.get('token'));
            } else {
                throw new CalloutException('HTTP Token callout failed with status: ' + res.getStatusCode() + ' and body: ' + res.getBody());
            }
        } catch (Exception e) {
            throw new CalloutException('HTTP Token callout failed: ' + e.getMessage());
        }
    }
    
    @InvocableMethod(label='sendObjectDataToIFB' description='This action will send data dynamically based on action Type')
    public static void sendObejectDataToIFBInternalSysFromFlow(List<flowInput> flowinp){
        List<id> idsToProcess = new List<id>();
        for(flowInput finp : flowinp){
            idsToProcess.addAll(finp.idsListToProccess);
        }
        if(flowinp[0].actionType == 'Purchase Installment Sync'){
            IntegrationHandler.sendOrderInstallmentDataToIFB(idsToProcess, flowinp[0].actionType);
        }else{
            IntegrationHandler.sendObejectDataToIFBInternalSys(idsToProcess, flowinp[0].actionType);
        }
        
    } 
    @future(callout=true)
    public static void sendOrderInstallmentDataToIFB(List<Id> idsToProcess, String actionType){
        Map<Id, Map<String, Object>> fileDataWithRecordIdMap = IntegrationHandler.getFilesForRecords(idsToProcess);
        
        List<OrderInstallmentWrapper> ordInstWrapList = new List<OrderInstallmentWrapper>();
        List<Order_Installment__c> ordInstListForUpdate = new List<Order_Installment__c>();
        try{
            Integration_Handler__mdt integrationHandlerInstance = Integration_Handler__mdt.getInstance(actionType.replace(' ','_'));
            if(integrationHandlerInstance != null && integrationHandlerInstance.Is_Active__c){
                
				List<Order_Installment__c> orderInstallsList = [Select id, Type__c, Transaction_Id__c, Amount__c, Order__c, 
                                                            order__r.TotalAmount, order__r.Advance_Received_Amount__c,
                                                            order__r.Advance_Amount_p__c,order__r.Pending_Amount__c,order__r.Pending_Amount_p__c, Transaction_Proof_Link__c
                                                           From Order_Installment__c where Id in : idsToProcess];
                //Looping on records to Create Wrapper
                for(Order_Installment__c orderInstall : orderInstallsList){
                    OrderInstallmentWrapper OrderInstInst = new OrderInstallmentWrapper();
                    OrderInstallmentWrapper.OrderInstallment ordInstInst = new OrderInstallmentWrapper.OrderInstallment();
                        ordInstInst.Amount = orderInstall.Amount__c;
                        ordInstInst.TransactionId = orderInstall.Transaction_Id__c;
                   		 ordInstInst.TransactionProofLink = orderInstall.Transaction_Proof_Link__c;
                        ordInstInst.sType = orderInstall.Type__c;
                        ordInstInst.Order_InstallmentID = orderInstall.id;
                    	ordInstInst.OrderId = orderInstall.order__c;
                    
                    OrderInstInst.Order_Installments = new List<OrderInstallmentWrapper.OrderInstallment>{ordInstInst};
                    OrderInstInst.PendingAmountPercentage = orderInstall.order__r.Pending_Amount_p__c;
                    OrderInstInst.PendingAmount = orderInstall.order__r.Pending_Amount__c;
                    OrderInstInst.AdvanceAmountPercentage = orderInstall.order__r.Advance_Amount_p__c;
                    OrderInstInst.AdvanceReceivedAmount = orderInstall.order__r.Advance_Received_Amount__c;
                    OrderInstInst.OrderTotalAmount = orderInstall.order__r.TotalAmount;
                    
                    OrderInstInst.sId = orderInstall.order__c;
                    System.debug(fileDataWithRecordIdMap.get(orderInstall.id).values());
                    ordInstWrapList.add(OrderInstInst);
                }
                String requestBody = ((JSON.serialize(ordInstWrapList)).replace('sId','Id')).replace('sType','Type');
                //Make callout here when we get the details Integration
                String token = IntegrationHandler.generateToken(integrationHandlerInstance);
                HttpResponse response = IntegrationHandler.makeHttpCallout(integrationHandlerInstance.URL__c, integrationHandlerInstance.Http_Method__c, token, requestBody);
                if(response.getStatusCode() == 200){
                    for(Order_Installment__c orderInstall : orderInstallsList){
                        Order_Installment__c ordIns = new Order_Installment__c();
                        ordIns.Id = orderInstall.id;
                        ordIns.Synced_with_the_IFB_Internal_Portal__c = true;
                        ordInstListForUpdate.add(ordIns);
                    }
                }
                
                if(!ordInstListForUpdate.isEmpty()){
                    update ordInstListForUpdate;
                }
            }else{
                throw new CalloutException('HTTP callout failed: Not able to find any Active Integration handler -custom metadata type for '+actionType +' Record List - '+idsToProcess);
            }
                
        }catch(exception e){
            insert Utilities.getExceptionErrorLog('IntegrationHandler' , 'sendOrderInstallmentDataToIFB', e, String.valueOf(idsToProcess));
        }
    }
    public class flowInput{
        @InvocableVariable
        public List<id> idsListToProccess;
        @InvocableVariable
        public String actionType;  
    }
    
}