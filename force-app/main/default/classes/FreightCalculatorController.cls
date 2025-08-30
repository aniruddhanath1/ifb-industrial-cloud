/*
@Author : Aman Sagar
@CreatedDate : 28th Aug 2024
@Description : This class is calculating Freight charges.
*/
public class FreightCalculatorController {
    @AuraEnabled
    public static List<ProductLineWrapper> getProductsfromQuoteLine(String recordId){
        List<ProductLineWrapper> productLineWrapperList = new List<ProductLineWrapper>();
        try{
            for(SBQQ__QuoteLine__c quoteline : [select Id,SBQQ__Product__r.Name, SBQQ__Product__r.cgcloud__Size__c,
                                                 SBQQ__Quantity__c,SBQQ__Product__r.ProductCode,SBQQ__Quote__c 
                                                 from SBQQ__QuoteLine__c
                                                 where SBQQ__Quote__c =: recordId
                                                ]){
                                                  ProductLineWrapper productLineWrapper = new ProductLineWrapper();  
                                                    productLineWrapper.quantity = quoteline.SBQQ__Quantity__c;
                                                    productLineWrapper.Model = quoteline.SBQQ__Product__r.ProductCode;
                                                    productLineWrapper.productName = quoteline.SBQQ__Product__r.Name;
                                                    productLineWrapper.areaFeet = quoteline.SBQQ__Product__r.cgcloud__Size__c;
                                                    productLineWrapperList.add(productLineWrapper);
                                                }
            
            return productLineWrapperList;
        }
        catch(Exception e){
            ExceptionHandler.logException('FreightCalculatorController' , 'getProductsfromQuoteLine', e);
        }
        
        return null;
    }
    
    @AuraEnabled
    public static Freight_Price_Mapping__mdt getFreightPrice(String state, String city){
        try{
            Freight_Price_Mapping__mdt price = [select Id,State__c,City__c,Tata_Ace__c,X22__c,X19__c,X17__c,X14__c 
                                                from Freight_Price_Mapping__mdt 
                                                where State__C =: state and City__c =: city
                                               ]; 
            return price;
        }
        catch(Exception e){
            ExceptionHandler.logException('FreightCalculatorController' , 'getFreightPrice', e);
        }
        
        return null;
    }
    @AuraEnabled
    public static void updatingQuote(String quoteId,String vehicle1, String vehicle2, String vehicle3, String vehicle4, Decimal capacity, Decimal freightPrice, Decimal TotalArea, String freightCity,String freightState) {
        try {
            SBQQ__Quote__c quote = new SBQQ__Quote__c();
            quote.id = quoteId;
                quote.Vehicle_1__c = vehicle1;
                quote.Vehicle_2__c = vehicle2;
                quote.Vehicle_3__c = vehicle3;
                quote.Vehicle_4__c = vehicle4;
                quote.Capacity_Utilization__c = capacity;
                quote.Fright_Charges__c = freightPrice;
                quote.Total_Area_Feet__c = TotalArea;
                quote.Freight_Calculated_On_State__c = freightState;
				quote.Freight_Calculated_On_City__c = freightCity;
            update quote;
            
        } catch (Exception e) {
            ExceptionHandler.logException('FreightCalculatorController' , 'updatingQuote', e);
        }
    }
    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getVehicleCapacities() {
        Map<String, Integer> vehicleCapacities = new Map<String, Integer>{
            ConstantUtilities.TATA => ConstantUtilities.TATA_ACE,
                ConstantUtilities.FOUR => ConstantUtilities.VEHICLE14,
                ConstantUtilities.SEVEN => ConstantUtilities.VEHICLE17,
                ConstantUtilities.NINE => ConstantUtilities.VEHICLE19,
                ConstantUtilities.TWO => ConstantUtilities.VEHICLE22,
                ConstantUtilities.NONE => ConstantUtilities.VEHICLE_NONE
                };
                    return vehicleCapacities;
    }
      @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getPicklistValues(String stateValue) {
        Map<String, List<String>> picklistValues = new Map<String, List<String>>();
        
        // Retrieve state picklist values
        Schema.DescribeFieldResult stateFieldDescribe = SBQQ__Quote__c.Freight_Calculated_On_State__c.getDescribe();
        List<Schema.PicklistEntry> statePicklistEntries = stateFieldDescribe.getPicklistValues();
        List<String> stateValues = new List<String>();
        for (Schema.PicklistEntry entry : statePicklistEntries) {
            stateValues.add(entry.getLabel());
        }
        picklistValues.put('stateValues', stateValues);
        
        // Retrieve city picklist values
        List<String> cityValues = new List<String>();
        if (stateValue != null) {
            Schema.DescribeFieldResult cityFieldDescribe = SBQQ__Quote__c.Freight_Calculated_On_City__c.getDescribe();
            List<Schema.PicklistEntry> cityPicklistEntries = cityFieldDescribe.getPicklistValues();
            
            // Get field dependencies
            Schema.PicklistEntry[] statePicklistEntriesArray = stateFieldDescribe.getPicklistValues();
            Map<String, List<String>> dependentValues = new Map<String, List<String>>();
            for (Schema.PicklistEntry stateEntry : statePicklistEntriesArray) {
                dependentValues.put(stateEntry.getValue(), new List<String>());
            }
            
            // Fetch dependent picklist values
            for (Schema.PicklistEntry cityEntry : cityPicklistEntries) {
                Schema.DescribeFieldResult cityFieldResult = SBQQ__Quote__c.Freight_Calculated_On_City__c.getDescribe();
                Map<String, Schema.PicklistEntry> picklistEntryMap = new Map<String, Schema.PicklistEntry>();
                for (Schema.PicklistEntry entry : cityFieldResult.getPicklistValues()) {
                    picklistEntryMap.put(entry.getValue(), entry);
                }
                
                // Check if the city value is valid for the selected state
                if (picklistEntryMap.containsKey(stateValue)) {
                    dependentValues.get(stateValue).add(cityEntry.getLabel());
                    
                }
                system.debug('**dependentValues'+dependentValues);
            }
            cityValues = dependentValues.containsKey(stateValue) ? dependentValues.get(stateValue): new List<String>();
        }
        system.debug('cityValues'+cityValues);
        picklistValues.put('cityValues', cityValues);
        return picklistValues;
    }
    class ProductLineWrapper{
        @AuraEnabled
        public String productName {get;set;}
        @AuraEnabled
        public String Model {get;set;}
        @AuraEnabled
        public String areaFeet {get;set;}
        @AuraEnabled
        public decimal quantity {get;set;}
        
    }    
}