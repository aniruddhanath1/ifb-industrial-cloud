/**
* @File Name : AdobeOppSyncBatch.cls
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

global class AdobeOppSyncBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable  {
	global Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator([ SELECT Id, StageName,LeadSource, Rating__c, Next_Follow_up_Date_Time__c, Purchase_timeline__c, Site__c, Space_Availability__c, 
       LeadIDText__c,Lead_Score__c,Adobe_Sync__c, Product_category__c, Type, Type_of_Customer__c, Name, Budget__c, Type_of_Setup__c, Account.Name,
       Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, 
       Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode, 
       Account.AnnualRevenue, Account.Website, Account.Other_Business__c, Account.Other_Locations_if_applicable__c, 
       Account.Sector__c, Account.Customer_Segment__c, AccountId,Account.Customer_Sub_segment__c,CreatedDate FROM 
       Opportunity Where (StageName=:ConstantUtilities.OPP_STAGE_QUALIFICATION OR StageName=:ConstantUtilities.OPP_STAGE_SITE_VISIT OR StageName=:ConstantUtilities.OPP_STAGE_LOAD_CALCULATION) AND LeadIDText__c!=null AND AccountId!=null AND Adobe_Sync__c=false AND  CreatedDate < LAST_N_DAYS:2]);
	}
	global void execute(Database.BatchableContext bc,List<Opportunity> oppBatch){
        Integration_Handler__mdt intHandlerInst = Integration_Handler__mdt.getInstance(ConstantUtilities.ADOBE_LEAD_SYNC);
         List<AdobeLeadSync.LeadWrapper> oppWrapperList = new List<AdobeLeadSync.LeadWrapper>();
        try{
            oppWrapperList = AdobeLeadSync.getOppData(oppBatch);
        }catch(exception e){
            insert Utilities.getExceptionErrorLog('AdobeOppSyncBatch', 'execute', e);
        }
		
		String requestBody = JSON.serialize(oppWrapperList);
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
            system.debug(res);
            System.debug('Response Status: ' + res.getStatus());
			System.debug('Response Body: ' + res.getBody());
			if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                insert Utilities.getInfoLog('AdobeOppSyncBatch' , 'executeInfo', requestBody,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody());
                responseBody = res.getBody();
            } else {
                throw new CalloutException('Error in response: ' + res.getStatus());
            }
		}catch (Exception e) {
            insert Utilities.getInfoLog('AdobeOppSyncBatch' , 'ErrorInfo', requestBody,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody());
        }
        
        Map<String,Opportunity> oppMap = new Map<String,Opportunity>();
        for(Opportunity opp:oppBatch){
            oppMap.put(opp.LeadIDText__c,opp);
        }
        AdobeLeadSyncResponse responseObj = new AdobeLeadSyncResponse();
        try{
            responseObj = AdobeLeadSyncResponse.parseResponse(responseBody);
            List<Opportunity> oppToUpdateList = new List<Opportunity>();
            for(AdobeLeadSyncResponse.LeadResponse leadRes:responseObj.data){
                if(oppMap.containsKey(leadRes.leadId) && leadRes.status==ConstantUtilities.RES_STATUS_SUCCESS){
                    Opportunity oppToUpdate = oppMap.get(leadRes.leadId);
                    oppToUpdate.Adobe_Sync__c = True;
                    oppToUpdate.Adobe_Sync_Time__c  = system.now();
                    oppToUpdate.CurrentValidationTime__c = system.now();
                    oppToUpdateList.add(oppToUpdate);
                }
            }
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            if (!oppToUpdateList.isEmpty()) {
              srList= Database.update(oppToUpdateList,false);
                 for(Database.SaveResult sr:srList){
                    if(sr.isSuccess()){
                        insert Utilities.getInfoLog('AdobeOppSyncBatch' , 'UpdateInfoLog', 'True','Status Code-'+res.getStatusCode()+' \n Body-'+sr.getId());

                    }else{
                        insert Utilities.getInfoLog('AdobeOppSyncBatch' , 'UpdateErrorInfoLog', 'True','Status Code-'+res.getStatusCode()+' \n Body-'+sr.getErrors());
                    }

                }
            }
        }catch(exception e){
            insert Utilities.getInfoLog('AdobeOppSyncBatch' , 'ErrorInfo', requestBody,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody());
            
        }
		
	}
	global void finish(Database.BatchableContext bc){
        
	}
     global void execute(SchedulableContext sc) {
        Database.executeBatch(new AdobeOppSyncBatch(), 100);
    }
    
}