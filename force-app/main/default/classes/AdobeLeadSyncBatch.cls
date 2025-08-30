/**
* @File Name : AdobeLeadSyncBatch.cls
* @Description :
* @Author : Aakash
* @Last Modified By :
* @Last Modified On : February 13, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | February 13, 2025 |   | Initial Version
**/

global class AdobeLeadSyncBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable  {
	global Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator([SELECT Id, Status, Lead_Score__c, Rating, Next_Follow_up_Date_Time__c, Requirement__c ,Purchase_Timeline__c, Site_Suitability__c, Space_Availability__c,
                                    LeadSource,  Lead_Sub_Source__c,  Product_Category__c,  Type__c, 
                                    Type_of_Customer__c, 
                                    FirstName, LastName, Company, Phone,Alternative_Phone_Number__c, Email, 
                                    Is_our_contact_a_Key_Decision_Maker__c,  Customer_Department__c, Customer_Designation__c,
                                    Street, City, State, PostalCode, Country,
                                    Shipping__Street__s, Shipping__City__s,Shipping__StateCode__s, Shipping__PostalCode__s, Shipping__CountryCode__s,
                                    Name,  Sector__c, Customer_Segment_Vertical__c, Customer_Sub_segment_Sub_Vertical__c, 
                                    Other_Business__c, Other_Locations__c, Region_Name__c, 
                                    Type_of_Setup__c, AnnualRevenue,  Website,CreatedDate from lead Where (Status=:ConstantUtilities.LEAD_VALIDATED OR Status=:ConstantUtilities.LEAD_CONTACTED OR Status=:ConstantUtilities.LEAD_NURTURING) AND Adobe_Sync__c=false AND  CreatedDate < LAST_N_DAYS:2]);
	}
	global void execute(Database.BatchableContext bc,List<Lead> leadBatch){
        Integration_Handler__mdt intHandlerInst = Integration_Handler__mdt.getInstance(ConstantUtilities.ADOBE_LEAD_SYNC);
		List<AdobeLeadSync.LeadWrapper> leadWrapperList = AdobeLeadSync.getLeadData(leadBatch);
		String requestBody = JSON.serialize(leadWrapperList);
		HttpRequest req = new HttpRequest();
		req.setEndpoint(intHandlerInst.URL__c);
		req.setMethod(intHandlerInst.Http_Method__c);
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('Authorization', 'Bearer '+ intHandlerInst.Static_Token_Value__c);
		req.setBody(requestBody);

		Http http = new Http();
        HttpResponse res;
        String responseBody = '';
		try{
			res = http.send(req);
			if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                insert Utilities.getInfoLog('AdobeLeadSyncBatch' , 'executeInfo', requestBody,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody());
                responseBody = res.getBody();
            } else {
                throw new CalloutException('Error in response: ' + res.getStatus());
            }
		}catch (Exception e) {
            insert Utilities.getInfoLog('AdobeLeadSyncBatch' , 'ErrorInfo', requestBody,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody());
            //insert Utilities.getExceptionErrorLog('AdobeLeadSyncBatch', 'execute', e);
        }
        
        Map<String,Lead> leadMap = new Map<String,Lead>();
        for(Lead l:leadBatch){
            leadMap.put(l.Id,l);
        }
        AdobeLeadSyncResponse responseObj = new AdobeLeadSyncResponse();
        try{
            responseObj = AdobeLeadSyncResponse.parseResponse(responseBody);
            List<Lead> leadsToUpdateList = new List<Lead>();
            for(AdobeLeadSyncResponse.LeadResponse leadRes:responseObj.data){
                if(leadMap.containsKey(leadRes.leadId) && leadRes.status==ConstantUtilities.RES_STATUS_SUCCESS){
                    Lead leadToUpdate = leadMap.get(leadRes.leadId);
                    leadToUpdate.Adobe_Sync__c = True;
                    leadToUpdate.Adobe_Sync_Time__c  = system.now();
                    leadToUpdate.validationBypassDate__c =system.now();
                    leadsToUpdateList.add(leadToUpdate);
                }
            }
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            if (!leadsToUpdateList.isEmpty()) {
                srList = Database.update(leadsToUpdateList,false);
                /*for(Database.SaveResult sr:srList){
                    if(sr.isSuccess()){
                        insert Utilities.getInfoLog('AdobeLeadSyncBatch' , 'UpdateInfoLog', 'True','Status Code-'+res.getStatusCode()+' \n Body-'+sr.getId());

                    }else{
                        insert Utilities.getInfoLog('AdobeLeadSyncBatch' , 'UpdateErrorInfoLog', 'True','Status Code-'+res.getStatusCode()+' \n Body-'+sr.getErrors());
                    }

                }*/
        }
        }catch(exception e){
            insert Utilities.getInfoLog('AdobeLeadSyncBatch' , 'UpdateErrorInfo', requestBody,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody());
            //insert Utilities.getExceptionErrorLog('AdobeLeadSyncBatch', 'execute', e);
        }
        
        
	}
	global void finish(Database.BatchableContext bc){
        
	}
     global void execute(SchedulableContext sc) {
        Database.executeBatch(new AdobeLeadSyncBatch(), 100);
    }
    
}