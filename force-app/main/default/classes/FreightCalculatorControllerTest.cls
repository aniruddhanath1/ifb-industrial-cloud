@isTest
public class FreightCalculatorControllerTest {
    
    @isTest
    public static void getProductsfromQuoteLineTest(){
        Test.startTest();
        Account insertedAcc = TestDataFactory.createAccount();
        Product2 prodObj = TestDataFactory.createProduct2();
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        Opportunity opp = TestDataFactory.createOpportunityForAccount(insertedAcc.Id,'Prospecting',userObj);
        SBQQ__Quote__c quote = TestDataFactory.createQuote(opp);
        SBQQ__QuoteLine__c quoteLineObj = TestDataFactory.createQuoteLine(quote.Id,false,1,prodObj.Id);
        FreightCalculatorController.getProductsfromQuoteLine(quote.Id);
        Map<String, Integer> capMapOfVehicle = FreightCalculatorController.getVehicleCapacities();
        System.assertEquals(6, capMapOfVehicle.keySet().size(), 'Map Should not empty. ');
        Map<String, List<String>> picklistMap = FreightCalculatorController.getPicklistValues('Test');
        System.assertEquals(2, picklistMap.keySet().size(), 'Map Should not empty. ');
        FreightCalculatorController.getFreightPrice('ASSAM','KOKRAJHAR');
        FreightCalculatorController.updatingQuote(quote.Id,'fsd','fsdf','fgdfgd','egerged',1,10,10,'ertert','gdgdgd');
        Test.stopTest();   
        
    }
}