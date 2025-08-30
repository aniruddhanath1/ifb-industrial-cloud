@isTest
public class OpportunityTriggerTest {
    
    @testSetup
    public static void dataSetup(){
        Account account = TestDataFactory.createAccount();
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        TestDataFactory.createPriceBook2('Industrial Washing Machine');
        Opportunity opp = TestDataFactory.createOpportunityConditionaly(account.Id,'Prospecting', false);
        opp.BOQ_URS_Approved__c = true;
        opp.Product_Category__c = 'IDW';
        Insert opp;
        Opportunity oppupdate = new Opportunity();
        oppupdate.id = opp.id;
        oppupdate.StageName = 'Closed Won';
        oppupdate.Blue_Sheet_Created_Date__c = system.now();
        oppupdate.Reasons_for_Closed_Won__c ='Influencer';
        
        try{
          Update oppupdate;  
          
        }catch(DmlException e){
            
        }
        
        List<Opportunity> oppList = [SELECT Id From Opportunity];
        System.assertEquals(1, oppList.size(), 'List Should Not Empty...');
        Delete opp;
        oppList = [SELECT Id From Opportunity];
        System.assertEquals(0, oppList.size(), 'List Should Be Empty...');
    }
    
    @isTest
    public static void testOppTrigger(){
        
        OpportunityTriggerHandler oppTriggerHandClassObj = new OpportunityTriggerHandler();
        Test.startTest();
        //oppTriggerHandClassObj.beforeUpdate();
        oppTriggerHandClassObj.beforeDelete();
        oppTriggerHandClassObj.afterInsert();
        Test.stopTest();
    }
    @isTest
    static void testHasValidReason() {
        // Define test data
        Set<String> validReasons = new Set<String>{'Reason1', 'Reason2', 'Reason3'};
        Set<String> reasonsSetWithValidReason = new Set<String>{'Reason2', 'OtherReason'};
        Set<String> reasonsSetWithoutValidReason = new Set<String>{'OtherReason1', 'OtherReason2'};
        Set<String> emptyReasonSet = new Set<String>();

        // Positive Test: A valid reason exists in reasonsSet
        Boolean result1 = OpportunityTriggerHelper.hasValidReason(reasonsSetWithValidReason, validReasons);
        System.assertEquals(true, result1, 'Expected true when a valid reason is present.');

        // Negative Test: No valid reason in reasonsSet
        Boolean result2 = OpportunityTriggerHelper.hasValidReason(reasonsSetWithoutValidReason, validReasons);
        System.assertEquals(false, result2, 'Expected false when no valid reason is present.');

        // Edge Case: Empty reasonsSet
        Boolean result3 = OpportunityTriggerHelper.hasValidReason(emptyReasonSet, validReasons);
        System.assertEquals(false, result3, 'Expected false when reasonsSet is empty.');

        // Edge Case: Empty validReasons set
        Boolean result4 = OpportunityTriggerHelper.hasValidReason(reasonsSetWithValidReason, new Set<String>());
        System.assertEquals(false, result4, 'Expected false when validReasons set is empty.');

        // Edge Case: Both sets are empty
        Boolean result5 = OpportunityTriggerHelper.hasValidReason(new Set<String>(), new Set<String>());
        System.assertEquals(false, result5, 'Expected false when both sets are empty.');
    }
}