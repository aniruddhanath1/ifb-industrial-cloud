public class InvoiceLineItemTriggerHelper {
    public static void beforeInsert(List<Invoice_Line_Item__c> newInvoiceLineItemsList) {
        Set<String> setOfMaterialCodes = new Set<String>();
        List<Product2> listOfProducts = new List<Product2>();
        Map<String, Product2> productMap = new Map<String, Product2>();
        try{
            for (Invoice_Line_Item__c lineItem : newInvoiceLineItemsList) {
                if (lineItem.Material_Code__c != null) {
                    setOfMaterialCodes.add(lineItem.Material_Code__c);
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
            for (Invoice_Line_Item__c lineItem : newInvoiceLineItemsList) {
                if (lineItem.Material_Code__c != null) {
                    Product2 matchedProduct = productMap.get(lineItem.Material_Code__c);
                    if (matchedProduct != null) {
                        lineItem.Product__c = matchedProduct.Id;
                    } else {
                        throw new TriggerException('No matching product found for Material Code in Salesforce: ' + lineItem.Material_Code__c);
                    }
                } 
            }
        }
        catch(Exception e){
              ExceptionHandler.logException('InvoiceLineItemTriggerHelper', 'beforeInsert', e);
        }
    }
}