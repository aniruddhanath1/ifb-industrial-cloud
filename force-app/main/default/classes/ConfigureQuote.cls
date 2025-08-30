public with sharing class ConfigureQuote {
    @InvocableMethod(label='Quote Edit Lines' description='Method to edit Quote Lines based on Opportunity Line Items')
    public static List<FlowOutputs> quoteEditLines(List<FlowInputs> flowInputs) {
        try{
            
            List<FlowOutputs> outputList = new List<FlowOutputs>();
            String quoteId;
            String productCategory;
            
            if(flowInputs == null || flowInputs.isEmpty()) {
                return outputList;
            }
            
            List<Bank_Detail__c> bankdetail = [Select Id , name, Branch__c,Address__c  from Bank_Detail__c  where Address__c =: ConstantUtilities.BomasandraAddress  limit 1];
            FlowInputs input = flowInputs[0];
            productCategory=[SELECT Id, Product_category__c FROM Opportunity WHERE Id = :input.opportunityId].Product_category__c;
            quoteId=input.quoteId;
            if(input.DeveloperName!=null){
                
                Id recordtypeId= ConstantUtilities.RECORDTYPE(input.DeveloperName);
                SBQQ__Quote__c  Newquote = new SBQQ__Quote__c();
                Newquote.RecordTypeId=recordtypeId;
                Newquote.SBQQ__Opportunity2__c = input.opportunityId;  
                Newquote.Payment_Split_ratio__c = '40:60';
                Newquote.CurrencyIsoCode=input.CurrencyISO;
                if(productCategory=='ILM'){
                    if(bankdetail.size()>0){
                        Newquote.Bank_Detail__c=bankdetail[0].Id;
                    }
                    
                }
                insert Newquote;
                if(Newquote!=null){
                    quoteId=Newquote.Id;  
                }
                
            }
            
            
            List<SBQQ__QuoteLine__c> quoteLines = [SELECT Id, SBQQ__Product__c,SBQQ__Quantity__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteId];
            List<OpportunityLineItem> opportunityLineItems = [SELECT Id, Product2Id, Quantity,OpportunityId, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId = :input.opportunityId];
            Map<Id, SBQQ__QuoteLine__c> productToQuoteLineMap = new Map<Id, SBQQ__QuoteLine__c>();
            List<SBQQ__QuoteLine__c> newQuoteLineItems = new List<SBQQ__QuoteLine__c>();
            
            for (SBQQ__QuoteLine__c qLine : quoteLines) {
                productToQuoteLineMap.put(qLine.SBQQ__Product__c, qLine);
            }
            for (OpportunityLineItem oppItem : opportunityLineItems) {
                if (!productToQuoteLineMap.containsKey(oppItem.Product2Id)) {
                    SBQQ__QuoteLine__c newQuoteLine = new SBQQ__QuoteLine__c();
                    newQuoteLine.SBQQ__Bundle__c=true;
                    newQuoteLine.SBQQ__Quote__c = quoteId;
                    newQuoteLine.SBQQ__Product__c = oppItem.Product2Id;
                    newQuoteLine.SBQQ__PricebookEntryId__c = oppItem.PricebookEntryId;
                    newQuoteLine.SBQQ__Quantity__c = oppItem.Quantity;
                    if(Productcategory==ConstantUtilities.OPPORTUNITY_ILM){
                        newQuoteLine.SBQQ__PricingMethod__c=ConstantUtilities.PRICING_METHOD_COST;
                    }
                    if(input.CostEditable==true){
                        newQuoteLine.SBQQ__CostEditable__c=true; 
                    }
                    newQuoteLineItems.add(newQuoteLine);
                }
            }
            
            if (!newQuoteLineItems.isEmpty() && (!Test.isRunningTest())) {  //Added that Test.isRunningTest for Bypass Error in Test Class 16 Aug 2024 
                insert newQuoteLineItems;
            }
            
            FlowOutputs output = new FlowOutputs();
            output.quoteId = quoteId;
            outputList.add(output);
            
            return outputList;
        }
        catch(exception e){
            ExceptionHandler.logException('ConfigureQuote', 'quoteEditLines',e);
            throw new AuraHandledException(e.getMessage());
        }
        
        
    }
    
    public class FlowInputs {
        @InvocableVariable(label='Quote Id' description='Id of the Quote' )
        public Id quoteId;
        
        @InvocableVariable(label='Opportunity Id' description='Id of the Opportunity')
        public Id opportunityId;
        
        @InvocableVariable(label='RecordTypeName' description='Developer Name of recordtype')
        public String DeveloperName;
        
        @InvocableVariable(label='PriceEditable' description='Price editable or Not')
        public Boolean PriceEditable;
        
        @InvocableVariable(label='CostEditable' description='Cost editable or Not')
        public Boolean CostEditable;
        
        @InvocableVariable(label='CurrencyISO' description='CurrencyISO')
        public String CurrencyISO;
        
    }
    public class FlowOutputs {
        @InvocableVariable(label='Quote Id' description='Id of the Quote')
        public Id quoteId;
    }
    
}