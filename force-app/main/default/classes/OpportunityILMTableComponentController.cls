/*
@Author : Yadram
@CreatedDate : 14th June 2024
@Description : This controller is use to fetch the  Opportunity of ILM Product for Pre Installtion Checklist  

*/
public class OpportunityILMTableComponentController {
    
    public static Map<String,Integer> sequenceMap;
    public static Map<String,String> remarkMap;
    public Static Map<String,wrapperClassChildTable> dataManipulatMap{get;set;}
    public static Map<String,String> defaultRemarksMap;
    public static String currentOppName{get;set;}
    
    @AuraEnabled(cacheable=true)
    public static mainWrapper getOppRecord(String oppRecordId){
        try{
            sequenceMap = ConstantUtilities.ILM_SEQUENCE_MAP;
            remarkMap = ConstantUtilities.ILM_REMARKS_MAP;
            defaultRemarksMap = ConstantUtilities.ILM_DEFAULT_REMARKSMAP;
            mainWrapper mainWrapperObj = new mainWrapper();
            getFieldInfo(ConstantUtilities.SOBJECT_NAME_OPPORTUNITY,oppRecordId);
            
            List<wrapperClassChildTable> childWrapperList = new List<wrapperClassChildTable>();
            for(String key : dataManipulatMap.keySet()){
                if(remarkMap.containsKey(key)){
                    wrapperClassChildTable childWrapperObj = dataManipulatMap.get(key);
                    wrapperClassChildTable childWrapperObjForRemarks = dataManipulatMap.get(remarkMap.get(key));
                    childWrapperObj.remarkValue = (childWrapperObjForRemarks.fieldCurrentValue == Null ? '' : childWrapperObjForRemarks.fieldCurrentValue);
                    childWrapperObj.remarkFieldApiName = (childWrapperObjForRemarks.fieldApiName == Null ? '' : childWrapperObjForRemarks.fieldApiName);
                    if(defaultRemarksMap.containsKey(key)){
                        childWrapperObj.defaultValue = defaultRemarksMap.get(key);
                    }
                    childWrapperList.add(childWrapperObj);
                }
            }
            mainWrapperObj.childWrapperList = childWrapperList;
            mainWrapperObj.currentOppNameWrapper = currentOppName;
            return mainWrapperObj;
        }
        catch(Exception e){
            ExceptionHandler.logException('OpportunityILMTableComponentController', 'getOppRecord', e);
        }   
        return null;
    }
    public static void getFieldInfo(String objectName, Id recordId) {
        try{
            
            dataManipulatMap = new Map<String,wrapperClassChildTable>();
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
            Schema.DescribeSObjectResult describeSObjectResult = sObjectType.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = describeSObjectResult.fields.getMap();
            SObject record = Database.query('SELECT ' + String.join(new List<String>(fieldsMap.keySet()), ',') + ' FROM ' + objectName + ' WHERE Id = :recordId');
            
            for (String fieldName : fieldsMap.keySet()) { 
                wrapperClassChildTable wrapperOpportunityObj = new wrapperClassChildTable();
                Schema.SObjectField field = fieldsMap.get(fieldName);
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                if(fieldDescribe.getName() ==  ConstantUtilities.OPPORTUNITY_FIELD_APINAME){
                    currentOppName = String.valueOf(record.get(fieldName));
                }
                if(sequenceMap.containsKey(fieldDescribe.getName())){
                    wrapperOpportunityObj.fieldApiName = fieldDescribe.getName();
                    wrapperOpportunityObj.fieldLable = fieldDescribe.getLabel();
                    wrapperOpportunityObj.fieldCurrentValue = (String.valueOf(record.get(fieldName)) == Null ? '' : String.valueOf(record.get(fieldName))); 
                    wrapperOpportunityObj.isPicklist = false; 
                    wrapperOpportunityObj.sequenceNumber = sequenceMap.get(fieldDescribe.getName());
                    List<wrapperPicklistValues> picklistWrapperList = new List<wrapperPicklistValues>();
                    if (fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                        List<Schema.PicklistEntry> picklistValues = fieldDescribe.getPicklistValues();
                        for (Schema.PicklistEntry picklistEntry : picklistValues) {
                            System.debug(picklistEntry.getLabel() + ' (' + picklistEntry.getValue() + ')');
                            wrapperPicklistValues pickListWrapperObj = new wrapperPicklistValues();
                            pickListWrapperObj.label = picklistEntry.getLabel();
                            pickListWrapperObj.value = picklistEntry.getValue();
                            picklistWrapperList.add(pickListWrapperObj);   
                        }
                        wrapperOpportunityObj.isPicklist = True;
                        wrapperOpportunityObj.fieldPicklistValues = picklistWrapperList;
                    } 
                    dataManipulatMap.put(wrapperOpportunityObj.fieldApiName,wrapperOpportunityObj);
                }
            } 
        }
        catch(Exception e){
            ExceptionHandler.logException('OpportunityILMTableComponentController', 'getFieldInfo', e);
        }    
    } 
    @AuraEnabled
    public static string saveRecord(List<wrapperClassChildTable> childListForSave, String opportunityId){
        try{
            Opportunity opportunityObj = new Opportunity();
            List<Account> accountUpdate = new List<Account>();
            
            opportunityObj.Id = opportunityId;
            for(wrapperClassChildTable wrapperOpportunityObj : childListForSave){
                if(wrapperOpportunityObj.fieldApiName != '' && wrapperOpportunityObj.fieldApiName != Null){
                    opportunityObj.put(wrapperOpportunityObj.fieldApiName,wrapperOpportunityObj.fieldCurrentValue);
                }
                if(wrapperOpportunityObj.remarkFieldApiName != '' && wrapperOpportunityObj.remarkFieldApiName != Null){
                    opportunityObj.put(wrapperOpportunityObj.remarkFieldApiName,wrapperOpportunityObj.remarkValue);
                }
            }
            
            if(opportunityObj.Id != Null){
                Account acccount = new Account();
                Opportunity opp = [ SELECT Account.Id  FROM Opportunity WHERE Id = :opportunityObj.Id LIMIT 1 ];
                    if (opp.AccountId != null) {
                        acccount = new Account(
                            Id = opp.Account.Id,  
                            PreInstallationUpdateAllow__c = True
                        );
                        update acccount;
                    }
                if(String.isNotBlank(opportunityObj.BOQ_Machine_List__c) &&  String.isNotBlank(opportunityObj.Heating_Type__c)  && String.isNotBlank(opportunityObj.Laundry_Set_up__c)  && String.isNotBlank(opportunityObj.Site_Details__c) &&
                   String.isNotBlank(opportunityObj.If_To_be_built_please_share_details__c) &&  String.isNotBlank(opportunityObj.Clear_Passage_for_Vehicle__c)  && String.isNotBlank(opportunityObj.Space_for_Machine_movement__c)  && String.isNotBlank(opportunityObj.Check_Room_Height__c) &&  
                   String.isNotBlank(opportunityObj.Installation_Except_GF_LB__c) &&  String.isNotBlank(opportunityObj.Machine_Installation_Floor_Level__c)  && String.isNotBlank(opportunityObj.Check_Utility_Connection_Availability__c)  && String.isNotBlank(opportunityObj.Water__c) &&
                   String.isNotBlank(opportunityObj.Electrical_Provision__c) &&  String.isNotBlank(opportunityObj.Steam_Provision__c)  && String.isNotBlank(opportunityObj.Drainage__c)  && String.isNotBlank(opportunityObj.Air_Line_Provision__c) &&
                   String.isNotBlank(opportunityObj.Check_Water_Pressure__c) &&  String.isNotBlank(opportunityObj.Check_Water_Hardness__c)  && String.isNotBlank(opportunityObj.Check_Hot_Air_Exhaust_Provision__c)  && String.isNotBlank(opportunityObj.Check_Provision_for_Ventilation_in_Room__c)){
                       
                       opportunityObj.PreInstallationRequired__c = True;
                   }
                Update opportunityObj;
                
                if (opp.AccountId != null) {
                    acccount = new Account(
                        Id = opp.Account.Id,  
                        PreInstallationUpdateAllow__c = false
                    );
                    update acccount;
                } 
            }
            
            return 'Success';
        }
        catch(Exception e){
            ExceptionHandler.logException('OpportunityILMTableComponentController', 'saveRecord', e);
            return e.getMessage();
        }     
    }
    public class mainWrapper{
        @AuraEnabled public List<wrapperClassChildTable> childWrapperList{get;set;}
        @AuraEnabled public String currentOppNameWrapper{get;set;}
        @AuraEnabled public String loginUserName{get;set;}
        public mainWrapper(){
            this.loginUserName = UserInfo.getName();
        }
    }
    public class wrapperClassChildTable{
        @AuraEnabled public String fieldApiName{get;set;}
        @AuraEnabled public String fieldLable{get;set;}
        @AuraEnabled public List<wrapperPicklistValues> fieldPicklistValues{get;set;}
        @AuraEnabled public String fieldCurrentValue{get;set;}
        @AuraEnabled public String remarkValue{get;set;}
        @AuraEnabled public String remarkFieldApiName{get;set;}
        @AuraEnabled public Boolean isPicklist{get;set;}
        @AuraEnabled public Integer sequenceNumber{get;set;}
        @AuraEnabled public String defaultValue{get;set;}
        public wrapperClassChildTable(){
            this.fieldCurrentValue = '';
            this.remarkValue = '';
        }
    }
    public class wrapperPicklistValues{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
    }
    @AuraEnabled
    public static String getOpportunityId(Id orderId) {
        try{
            Order order = [SELECT OpportunityId FROM Order WHERE Id = :orderId LIMIT 1];
            return order.OpportunityId;
        }
        catch(Exception e){
            ExceptionHandler.logException('OpportunityILMTableComponentController', 'getOpportunityId', e);
        } 
        return null;
        
    }
    
}