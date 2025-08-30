@isTest
public class ConfigureQuoteTest {
    
    @testSetup
    public static void dataSetup(){
        Account insertedAcc = TestDataFactory.createAccount();
        Product2 prodObj = TestDataFactory.createProduct2();
        User objUser = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        Opportunity opp = TestDataFactory.createOpportunity(' test 1 ','Qualification',System.today().addDays(5),'ILM','Electric');
        Id priceBookEntityIdNew = TestDataFactory.createPricebookEntry(prodObj.Id);
        TestDataFactory.createOppLineItem(opp.Id,priceBookEntityIdNew,opp.StageName);
        SBQQ__Quote__c quote = TestDataFactory.createQuote(opp);
        TestDataFactory.createQuoteLine(quote.Id,false,1,prodObj.Id);
        Bank_Detail__c bankDetail = new Bank_Detail__c();
        bankDetail.Name= 'Test Bank';
        bankDetail.Branch__c = 'test Branch';
        bankDetail.Address__c = '3b/3c, Ifb Industries Ltd, Bommasandra Industrial Area, Anekal Taluk,';
        insert bankDetail;
    }
    
    @isTest
    public static void quoteEditLinesTest(){
        
        //Opportunity opp1 = TestDataFactory.createOpportunityForAccount(insertedAcc.Id,'Qualification',objUser);
        Opportunity opp = [SELECT Id, StageName From Opportunity Limit 1];
        SBQQ__Quote__c quote = [SELECT Id From SBQQ__Quote__c Limit 1];
        
        
        ConfigureQuote.FlowInputs flowInputClassObj = new ConfigureQuote.FlowInputs();
        flowInputClassObj.opportunityId = opp.Id;
        flowInputClassObj.CostEditable = true;
        flowInputClassObj.quoteId = quote.Id;
        flowInputClassObj.DeveloperName = 'BOQ_specified';
        try{
        List<ConfigureQuote.FlowOutputs> getDataList = ConfigureQuote.quoteEditLines(new List<ConfigureQuote.FlowInputs>{flowInputClassObj});
            System.assertEquals(1 , getDataList.size(), 'List Should Be Not Empty...');
            
            
        }catch(AuraHandledException exp){
            
        }
        
        try{
        ConfigureQuote.quoteEditLines(new List<ConfigureQuote.FlowInputs>());
        }catch(AuraHandledException exp){
            
        }
                
        ConfigureQuote.FlowInputs flowInputClassObj1 = new ConfigureQuote.FlowInputs();
        flowInputClassObj1.quoteId = quote.Id;
        flowInputClassObj1.PriceEditable = true;
        flowInputClassObj1.CostEditable = false;
        flowInputClassObj1.CurrencyISO = 'test';
        
        ConfigureQuote.FlowOutputs flowOutputObjNew = new ConfigureQuote.FlowOutputs();
		flowOutputObjNew.quoteId = quote.Id;     
    }
    
}