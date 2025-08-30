public class ProformaInvoiceLineItemTriggerHelper {
    public static void beforeInsert(List<Proforma_Invoice_Line_Item__c> newProformaLineItemsList) {
        Set<String> setOfMaterialCodes = new Set<String>();
        List<Product2> listOfProducts = new List<Product2>();
        Map<String, Product2> productMap = new Map<String, Product2>();
        try{
            for (Proforma_Invoice_Line_Item__c lineItem : newProformaLineItemsList) {
                if (lineItem.Product_Sap_Id__c != null) {
                    setOfMaterialCodes.add(lineItem.Product_Sap_Id__c);
                }
            }
            if(!setOfMaterialCodes.isEmpty()){
                listOfProducts = [SELECT Id, Material_Code__c FROM Product2 WHERE Material_Code__c IN :setOfMaterialCodes];
            }
            if(!listOfProducts.isEmpty()){
                for(Product2 prodRecord : listOfProducts){
                    productMap.put(prodRecord.Material_Code__c,prodRecord);
                }
                
            }
            for (Proforma_Invoice_Line_Item__c lineItem : newProformaLineItemsList) {
                if (lineItem.Product_Sap_Id__c != null) {
                    Product2 matchedProduct = productMap.get(lineItem.Product_Sap_Id__c);
                    if (matchedProduct != null) {
                        lineItem.Product__c = matchedProduct.Id;
                    } else {
                        throw new TriggerException('No matching product found for Material Code in Salesforce: ' + lineItem.Product_Sap_Id__c);
                    }
                }
            } 
        }
        catch(Exception e){
            ExceptionHandler.logException('ProformaInvoiceLineItemTriggerHelper', 'beforeInsert', e);
        }
    }
}