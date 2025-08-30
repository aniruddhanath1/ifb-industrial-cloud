/*
@Author : Yadram
@CreatedDate : 14th June 2024
@Description : This controller is use to fetch the  Opportunity of IDW Product for Pre Installtion Checklist  

*/
public class OpportunityIDWTableComponentController {
    
    @AuraEnabled(cacheable=true)
    public static Opportunity getOppRecord(String oppRecordId){
        try{
            Opportunity oppRecord = [SELECT Id,Name,Owner.Name, Machine_Dimensions_w_d_h_Space_Req__c, Total_Power_Req_Connected_Load__c, 
                                     Electric_Connection_Incoming_Supp_Vol__c, MCB_Rating__c, Required_Power_Cable_Size_Rating__c, 
                                     Water_Hardness__c,Required_Intel_Water_Pressure__c, Water_Intel_Size_With_Ball_Value_M_T_S__c, 
                                     Drain_Outlet_Size_Gravity_Drain_Req__c , Model__c From Opportunity WHERE Id =: oppRecordId Limit 1];
            
            return oppRecord;
        }
        catch(Exception e){
            ExceptionHandler.logException('OpportunityIDWTableComponentController', 'getOppRecord', e);
        }   
        return null;
    }
    
    @AuraEnabled 
    public static string saveRecord(Opportunity oppRecordFromLwc){
        try{
            if(oppRecordFromLwc != Null){
                Account acccount = new Account();
                Opportunity opp = [ SELECT Account.Id  FROM Opportunity WHERE Id = :oppRecordFromLwc.Id LIMIT 1 ];
                if (opp.AccountId != null) {
                    acccount = new Account(
                        Id = opp.Account.Id,  
                        PreInstallationUpdateAllow__c = True
                    );
                    update acccount;
                }
                if(oppRecordFromLwc.Machine_Dimensions_w_d_h_Space_Req__c != null && oppRecordFromLwc.Total_Power_Req_Connected_Load__c != null &&
                   oppRecordFromLwc.Electric_Connection_Incoming_Supp_Vol__c != null &&oppRecordFromLwc.MCB_Rating__c != null && 
                   oppRecordFromLwc.Required_Power_Cable_Size_Rating__c != null && oppRecordFromLwc.Water_Hardness__c != null && 
                   oppRecordFromLwc.Required_Intel_Water_Pressure__c != null && oppRecordFromLwc.Water_Intel_Size_With_Ball_Value_M_T_S__c != null && 
                   oppRecordFromLwc.Drain_Outlet_Size_Gravity_Drain_Req__c != null &&  oppRecordFromLwc.Model__c != null
                  ){
                      oppRecordFromLwc.PreInstallationRequired__c = True; 
                  }
                Update oppRecordFromLwc;
                
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
        ExceptionHandler.logException('OpportunityIDWTableComponentController', 'saveRecord', e);
        return e.getMessage();
    }   
}
}