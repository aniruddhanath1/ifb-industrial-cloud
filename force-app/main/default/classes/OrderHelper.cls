public without sharing class OrderHelper {
    @InvocableMethod(label='UpdateOrderLineItemWithParent')
    public static void executeScheduledOrderLineUpdate(List<List<OrderItem>> listRecords) {
        List<OrderItem> orderLineItemListForUpdate = new List<OrderItem>();
         List<OrderItem> orderLineList = new List<OrderItem>();
        Set<id> orderLineIdSet = new set<id>();
        Map<String,id> parentSAPcodeVsIdMap = new Map<String,id>();
        try{
            
            System.debug('**recordIds'+listRecords);
            //System.debug('**recordIds Query -'+[Select id, Parent_SAP_Product_ID__c, Material_Code__c,OrderId from OrderItem where id in :recordIds]);
            if(listRecords != null){
                for(List<OrderItem> orderItemListinst : listRecords){
                    orderLineList.addAll(orderItemListinst);
                }
                for(OrderItem orderItenInst : orderLineList){
                    orderLineIdSet.add(orderItenInst.id);
                }
                for(OrderItem ordeLine : [Select id, Parent_SAP_Product_ID__c, Material_Code__c,OrderId from OrderItem where id in :orderLineIdSet]){
                    
                    if(ordeLine.Parent_SAP_Product_ID__c == null && ordeLine.Material_Code__c != null){
                        parentSAPcodeVsIdMap.put(ordeLine.Material_Code__c,ordeLine.id );
                        
                    }
                }
                System.debug('**parentSAPcodeVsIdMap'+parentSAPcodeVsIdMap);
                for(OrderItem ordeLine : [Select id, Parent_SAP_Product_ID__c, Material_Code__c,OrderId from OrderItem where id in :orderLineIdSet]){
                    if(parentSAPcodeVsIdMap.containsKey(ordeLine.Parent_SAP_Product_ID__c) && ordeLine.Parent_SAP_Product_ID__c != null ){
                        OrderItem orderItemInstance = new OrderItem();
                        orderItemInstance.id = ordeLine.id;
                        orderItemInstance.Parent_Order_Product__c = parentSAPcodeVsIdMap.get(ordeLine.Parent_SAP_Product_ID__c);
                        orderLineItemListForUpdate.add(orderItemInstance);
                    }
                }
                System.debug('**orderLineItemListForUpdate'+orderLineItemListForUpdate);
                if(!orderLineItemListForUpdate.isEmpty()){
                    update orderLineItemListForUpdate;
                }
            }
        }catch(exception e){
            ExceptionHandler.logException('OrderHelper', 'executeScheduledOrderLineUpdate', e);
        }
    }
    
}