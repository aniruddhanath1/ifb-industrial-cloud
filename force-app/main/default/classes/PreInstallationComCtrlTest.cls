@isTest 
public class PreInstallationComCtrlTest {
    
    @testSetup
    public static void insertOppData(){
        Account acc = TestDataFactory.createAccount();
        acc.Type = 'Upgrade';
        acc.Type_of_Account__c='Key Account';
        acc.Sub_type_of_Account__c='PAN India Presence';
        Update acc;
        
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        Opportunity testOpp = TestDataFactory.createOpportunityForAccount(acc.Id,'Prospecting',userObj);
    }
    
    @isTest 
    public static void testParentComponent(){
        Opportunity oppObj = [SELECT Id, Product_category__c From Opportunity Limit 1];
        
        PreInstallationOpportunityController.getProductCategory(oppObj.Id);
        PreInstallationOpportunityController.getProductCategory(null);
    }
    
    @isTest 
    public static void testILMChildComponent(){
        Opportunity oppObj = [SELECT Id, Product_category__c From Opportunity Limit 1];
        oppObj.BOQ_Machine_List__c = 'Yes';
        oppObj.Heating_Type__c = 'Electric';
        oppObj.Laundry_Set_up__c = 'New';
        oppObj.Site_Details__c = 'To be Built';
        oppObj.If_To_be_built_please_share_details__c = 'Construction started';
        oppObj.Clear_Passage_for_Vehicle__c = 'Ok';
        oppObj.Space_for_Machine_movement__c = 'Ok';
        oppObj.Check_Room_Height__c = 'Yes';
        oppObj.Installation_Except_GF_LB__c = 'Yes';
        oppObj.Machine_Installation_Floor_Level__c = 'Lower Basement';
        oppObj.Check_Utility_Connection_Availability__c = 'Yes';
        oppObj.Water__c = 'Yes';
        oppObj.Electrical_Provision__c = 'Yes';
        oppObj.Steam_Provision__c = 'Yes';
        oppObj.Drainage__c = 'Yes';
        oppObj.Air_Line_Provision__c = 'Yes';
        oppObj.Check_Water_Pressure__c = 'Yes';
        oppObj.Check_Water_Hardness__c = 'Yes';
        oppObj.Check_Hot_Air_Exhaust_Provision__c = 'Yes';
        oppObj.Check_Provision_for_Ventilation_in_Room__c = 'Yes';
        System.assertEquals('Electric', oppObj.Heating_Type__c = 'Electric');
        Test.startTest();
        Update oppObj;
        Test.stopTest();
        
        OpportunityILMTableComponentController.getOppRecord(oppObj.Id);
        List<OpportunityILMTableComponentController.wrapperClassChildTable> wrapperObjList = new List<OpportunityILMTableComponentController.wrapperClassChildTable>();
        OpportunityILMTableComponentController.wrapperClassChildTable wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'BOQ_Machine_List__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Heating_Type__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Laundry_Set_up__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Site_Details__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'If_To_be_built_please_share_details__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Clear_Passage_for_Vehicle__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Space_for_Machine_movement__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Check_Room_Height__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Installation_Except_GF_LB__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Machine_Installation_Floor_Level__c';
        wrapperObj.fieldCurrentValue = 'Lower Basement';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Check_Utility_Connection_Availability__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Water__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Electrical_Provision__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Steam_Provision__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Drainage__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Air_Line_Provision__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Check_Water_Pressure__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Check_Water_Hardness__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Check_Hot_Air_Exhaust_Provision__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        wrapperObj = new OpportunityILMTableComponentController.wrapperClassChildTable();
        wrapperObj.fieldApiName = 'Check_Provision_for_Ventilation_in_Room__c';
        wrapperObj.fieldCurrentValue = 'Yes';
        wrapperObjList.add(wrapperObj);
        OpportunityILMTableComponentController.saveRecord(wrapperObjList,oppObj.Id);
        OpportunityILMTableComponentController.getOpportunityId(oppObj.Id);
        OpportunityILMTableComponentController.getOpportunityId(null);
        
    }
    
    @isTest 
    public static void testIDWChildComponent(){
        OpportunityIDWTableComponentController.saveRecord(new Opportunity());
        OpportunityIDWTableComponentController.getOppRecord(null);
        Opportunity oppObj = [SELECT Id, Product_category__c From Opportunity Limit 1];
        oppObj.Machine_Dimensions_w_d_h_Space_Req__c = 'Yes';
        oppObj.Total_Power_Req_Connected_Load__c = 'Yes';
        oppObj.Electric_Connection_Incoming_Supp_Vol__c = 'Yes';
        oppObj.MCB_Rating__c = 'Yes';
        oppObj.Required_Power_Cable_Size_Rating__c = 'Yes';
        oppObj.Water_Hardness__c = 'Yes';
        oppObj.Required_Intel_Water_Pressure__c = 'Yes';
        oppObj.Water_Intel_Size_With_Ball_Value_M_T_S__c = 'Yes';
        oppObj.Drain_Outlet_Size_Gravity_Drain_Req__c = 'Yes';
        oppObj.Model__c = 'Yes';
        Test.startTest();
        Update oppObj;
        Test.stopTest();
        System.assertEquals('Yes', oppObj.MCB_Rating__c, 'Yes');
        OpportunityIDWTableComponentController.getOppRecord(oppObj.Id);
        OpportunityIDWTableComponentController.saveRecord(oppObj);
    }
}