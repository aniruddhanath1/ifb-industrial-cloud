public class APIHelper {

    static final String SysProfile = 'System Administrator';
    static final String IntegUserProfile = 'Sales Insights Integration User';
    static final String UserProfile = 'CGCloud_User_Profile';
    
    public class ResponseStatus {
        public String status;
    }
    
    @AuraEnabled
    public static Boolean installDemoData(String endPoint) {
        try {
	        String sessionId = UserInfo.getSessionId();
            Http client = new Http();
	        HttpRequest request = new HttpRequest();
            request.setHeader('Authorization', 'OAuth ' + sessionId);
	        request.setHeader('Authorization', 'Bearer ' + sessionId);
            request.setEndPoint(URL.getOrgDomainUrl().toExternalForm() + endPoint);
            request.setMethod('GET');
            HttpResponse response = client.send(request);
            String string_res = response.getBody();
            
            if (response.getStatusCode() == 200) {
            	// {"status":"SUCCESS","message":"7078D00001P17GP"}
                APIHelper.ResponseStatus APIStatus = (APIHelper.ResponseStatus)JSON.deserialize(string_res, APIHelper.ResponseStatus.class);
                System.debug('CG Cloud Retail Execution demo data loaded successfully with response "' + APIStatus.status + '" !!!');
            } else {
                System.debug('Error loading ' + endPoint + ' demo data with status code ' + response.getStatusCode());
                return False;
            }
            
        } catch(System.Exception e) {
            System.debug('Error loading' + endPoint + ' demo data, please try again later!!!');
            System.debug(e.getMessage());
            return False;
        }
        return True;
    }
    
    // getUserIdOfProfile will fetch User Ids of a specific profile
    @AuraEnabled(cacheable=true)
    public static List<User> getUserIdOfProfile(String profile_name) {
        System.debug('SysProfile: ' + SysProfile);
        return [SELECT Id, Username, Alias FROM User WHERE ProfileId IN (SELECT Id FROM Profile WHERE Name=:profile_name)];
    }
    
    // updateSalesorgForAdmin method will update all System Administrator
    @AuraEnabled(cacheable=true)
    public static Boolean updateSalesorgForAdmin() {
        List<User> AdminIds = APIHelper.getUserIdOfProfile(SysProfile);
        try {
            for (User aid : AdminIds) {
                aid.cgcloud__Sales_Org__c = '0001';
                aid.cgcloud__Mobility_Sales_Org__c = '0001';
                update aid;
            }
        } catch (DmlException e) {
    		System.debug('A DML exception has occurred: ' +
            e.getMessage());
            return False;
		}
        
        return True;
    }    
    
    // getSalesOrgs method will fetch all the Sales Organization Ids
    @AuraEnabled(cacheable=true)
    public static List<cgcloud__Sales_Organization__c> getSalesOrgs() {
        return [SELECT Id FROM cgcloud__Sales_Organization__c];
    }

    // updateSalesorgRelatedUsers method will update Admin user and Sales org to all Sales Organizations
    @AuraEnabled(cacheable=true)
	public static Boolean updateSalesorgRelatedUsers() {
        List<User> AdminIds = APIHelper.getUserIdOfProfile(SysProfile);
        List<cgcloud__Sales_Organization__c> SalesOrgs = APIHelper.getSalesOrgs();
        List<cgcloud__Sales_Organization_User__c> SalesUsers = new List<cgcloud__Sales_Organization_User__c>();

        try {
            for (cgcloud__Sales_Organization__c sos : SalesOrgs) {
                SalesUsers.add(new cgcloud__Sales_Organization_User__c(cgcloud__User__c=AdminIds[0].Id,
                                                                       cgcloud__Sales_Organization__c=sos.Id));
            }
            
            insert SalesUsers;
        } catch (DmlException e) {
            System.debug('A DML exception has occurred: ' +
            e.getMessage());
            return False;
        }
    
        return True;
    }

    // picklistBatch
    @AuraEnabled(cacheable=true)
    public static Boolean picklistBatch() {
        try {
            cgc_sync.PicklistAttributesMappingBatch picklistbatch = new cgc_sync.PicklistAttributesMappingBatch();
            Id picklistBatchJobId = Database.executeBatch(picklistbatch, 100);
        } catch (DmlException e) {
            System.debug('Exception occurred executing picklistBatch: ' +
            e.getMessage());
            return False;
        }
        return True;
    }
    
    // effAccountMgrbatch
    @AuraEnabled(cacheable=true)
    public static Boolean effAccountMgrbatch() {
        try {
            cgcloud.EffectiveAccountManagerSyncBatch effAccMgrbatch = new cgcloud.EffectiveAccountManagerSyncBatch(); 
            Id effAccMgrbatchJobId = Database.executeBatch(effAccMgrbatch, 100);
        } catch (DmlException e) {
            System.debug('Exception occurred executing picklistBatch: ' +
            e.getMessage());
            return False;
        }
        return True;
    }
    
    // aggPrmotionBatch
    @AuraEnabled(cacheable=true)
    public static Boolean aggPrmotionBatch() {
        try {
            cgcloud.AggregatePromotionBatch aggPrmoBatch = new cgcloud.AggregatePromotionBatch(); 
            Id aggPrmoBatchJobId = Database.executeBatch(aggPrmoBatch, 100);
        } catch (DmlException e) {
            System.debug('Exception occurred executing picklistBatch: ' +
            e.getMessage());
            return False;
        }
        return True;
    }

    // accManagerOrgUnit
    @AuraEnabled(cacheable=true)
    public static Boolean accManagerOrgUnit() {
        try {
            cgcloud.AggregatePromotionBatch aggPrmoBatch = new cgcloud.AggregatePromotionBatch(); 
            Id aggPrmoBatchJobId = Database.executeBatch(aggPrmoBatch, 100);
        } catch (DmlException e) {
            System.debug('Exception occurred executing picklistBatch: ' +
            e.getMessage());
            return False;
        }
        return True;
    }

    // authorizationListSetupBatch
    @AuraEnabled(cacheable=true)
    public static Boolean authorizationListSetupBatch() {
        try {
            cgcloud.AuthorizationListSetupBatch authListSetupBatch = new cgcloud.AuthorizationListSetupBatch(); 
            Id authListSetupBatchJobId = Database.executeBatch(authListSetupBatch, 100);
        } catch (DmlException e) {
            System.debug('Exception occurred executing picklistBatch: ' +
            e.getMessage());
            return False;
        }
        return True;
    }

}