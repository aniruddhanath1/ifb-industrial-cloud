public without sharing class CheckStockAvailabilityController {
    @AuraEnabled
    public static string getStockAvailability(String plant, String material, String materialGroup, String materialSubGroup){
        String stockJsonString;
         try{
            Integration_Handler__mdt intHandlerInst = Integration_Handler__mdt.getInstance(ConstantUtilities.LabelStockAvailabilityRequest);
            if(intHandlerInst!= null){
                String tokenStr = IntegrationHandler.generateToken(intHandlerInst);
                material = addPrefixIfNeeded(material);
                HttpResponse response = IntegrationHandler.makeHttpCallout(intHandlerInst.URL__c+'?PlantCode='+plant+'&MaterialCode='+material+'&MaterialGroup='+materialGroup+'&MaterialSubGroup='+materialSubGroup, intHandlerInst.Http_Method__c, tokenStr, null );
                return response.getBody();
            }else{
                insert Utilities.getErrorLog('CheckStockAvailabilityController' , 'getStockAvailability', 'Integration Handler record not found with Name-'+ConstantUtilities.LabelStockAvailabilityRequest, 'plant:'+plant+', material:'+material+', materialGroup'+materialGroup+', materialSubGroup'+materialSubGroup);
                throw new AuraHandledException('Integration Handler record not found.'); 
            }
            
        }catch(Exception e){
            ExceptionHandler.logException('CheckStockAvailabilityController' , 'getStockAvailability', e);
            throw new AuraHandledException(e.getMessage()); 
        }
    }
  public static String addPrefixIfNeeded(String materialCode) {
    // Check if the first character is a digit using a regular expression
    if (materialCode != null && materialCode.length() > 0 && materialCode.isNumeric()) {
        return '00000' + materialCode;
    }
    return materialCode;
}



    
    @AuraEnabled(cacheable=true)
    public static OptionWrapper getOptionWrapper() {
        OptionWrapper optionWrp = new OptionWrapper();
        List<Options> productOptions = new List<Options>();
        List<Options> plantOptions = new List<Options>();
        List<Options> ilmSubGroupOptions = new List<Options>();
        List<Options> idwSubGroupOptions = new List<Options>();
        productOptions.add(new Options('ALL', 'All'));
        for (Product2 product : [SELECT Id, Name, Material_Code__c FROM Product2 where Material_Code__c != null order by Name asc ]) {
            productOptions.add(new Options(product.Material_Code__c, product.Name));
        }
        plantOptions.add(new Options('ALL', 'All'));
        for (Facility__c facility : [SELECT Id, Name, Branch_Factory_Code__c FROM Facility__c]) {
            plantOptions.add(new Options(facility.Branch_Factory_Code__c, facility.Name));
        }
        
        for (String subGroupStr : ConstantUtilities.IDW_MATERIALSUBGROUP) {
            idwSubGroupOptions.add(new Options(subGroupStr, subGroupStr));
        }
        for (String subGroupStr : ConstantUtilities.ILM_MATERIALSUBGROUP) {
            ilmSubGroupOptions.add(new Options(subGroupStr, subGroupStr));
        }
        
        optionWrp.productOptions = productOptions;
        optionWrp.plantOptions = plantOptions;
        optionWrp.ilmSubGroupOptions = ilmSubGroupOptions;
        optionWrp.idwSubGroupOptions = idwSubGroupOptions;
        return optionWrp;
    }
    public class OptionWrapper{
		@AuraEnabled public List<Options> productOptions { get; set; }
        @AuraEnabled public List<Options> plantOptions { get; set; }
        @AuraEnabled public List<Options> idwSubGroupOptions { get; set; }
        @AuraEnabled public List<Options> ilmSubGroupOptions { get; set; }
    }
    public class Options {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String label { get; set; }

        public Options(String id, String name) {
            this.id = id;
            this.label = name;
        }
    }
    

}