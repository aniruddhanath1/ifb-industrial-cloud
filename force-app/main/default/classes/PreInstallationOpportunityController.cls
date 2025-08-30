/*
@Author : Yadram
@CreatedDate : 14th June 2024
@Description : This controller used to fetch the opportunity Id for Pre Installtion Checklist  

*/

public class PreInstallationOpportunityController {
    @AuraEnabled(cacheable=true)
    public static String getProductCategory(String oppRecordId){
        try{
            Opportunity oppRecord = [SELECT Id, Product_category__c  From Opportunity WHERE Id =: oppRecordId Limit 1];
            return oppRecord.Product_category__c;
        }
        catch(Exception e){
            ExceptionHandler.logException('PreInstallationParentComponentController', 'getProductCategory', e);
        } 
        return  null;
    }
}