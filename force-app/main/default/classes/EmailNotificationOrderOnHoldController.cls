public class EmailNotificationOrderOnHoldController {
    @InvocableMethod(label='OnholdOrderNotification')
    public static void onHoldOrderReport() {
        try{
            DateTime currentTime = DateTime.now();
            Integer currentHour = (Integer)currentTime.hour();
            Set<Id> orderOwnerIds = new Set<Id>();
            List<Order> listOfOrder  = new List<Order>();
            if(currentHour == ConstantUtilities.DAILY_HOUR  || Test.isRunningTest()){
                for(Order OrderObject : [SELECT ID,OrderNumber, Status, Pending_Amount__c,ownerId,Account.Name FROM Order where
                                          status =: ConstantUtilities.ORDER_STATUS AND Pending_Amount__c >0]){
                    listOfOrder.add(OrderObject);
                    orderOwnerIds.add(OrderObject.ownerId);
                } 	
            }
            if(!listOfOrder.isempty() && !orderOwnerIds.isempty()){
                orderDetailsMapping(listOfOrder ,orderOwnerIds);
            }
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailNotificationOrderOnHoldController', 'onHoldOrderReport', e);
        }
    }
    public static void orderDetailsMapping(List<Order> listOfOrder, Set<Id> orderOwnerIds){
        try{
            Map<Id, List<Order>> userOppMap = new Map<Id, List<Order>>();
            if(!orderOwnerIds.isEmpty() && !listOfOrder.isEmpty()   ){
                List<User> userList = [SELECT Id, Email, Name, ManagerId,Manager.Email FROM User WHERE Id IN : orderOwnerIds];
                for (Order orderObj : listOfOrder) {
                    if (userOppMap.containsKey(orderObj.OwnerId)) {
                        userOppMap.get(orderObj.OwnerId).add(orderObj);
                    } else {
                        userOppMap.put(orderObj.OwnerId, new List<Order>{orderObj});
                    }
                }
                
                for (User user : userList) {
                    List<Order> userOpps = userOppMap.get(user.Id);
                    if ((userOpps != null && !userOpps.isEmpty())) {
                        sendEmail(user, userOpps);
                    }
                } 
            }
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailNotificationOrderOnHoldController', 'orderDetailsMapping', e);
        }
    }    
    private static void sendEmail(User user, List<Order> listOfOrder) {
        try{
            String subject = ConstantUtilities.ORDER_EMAIL_SUBJECT;
            String baseUrl = URL.getOrgDomainUrl().toExternalForm();
            String body = '<html><body>';
            body += '<p>Hello ' + user.Name + ',</p>';
            
            if (listOfOrder != null && !listOfOrder.isEmpty()) {
                body += '<p>Here are the details of the orders that are pending:</p>';
                body += '<table border="1" cellpadding="5" cellspacing="0">';
                body += '<tr><th>Order Number</th><th>Pending Amount</th><th>Customer Name</th><th>Link</th></tr>';
                for (Order OrderObj : listOfOrder) {
                    String orderLink = baseUrl + '/' + OrderObj.Id;
                    body += '<tr>';
                    body += '<td>' + OrderObj.OrderNumber + '</td>';
                    body += '<td>' + OrderObj.Pending_Amount__c + '</td>';
                    body += '<td>' + OrderObj.Account.Name + '</td>';
                    body += '<td><a href="' + orderLink + '">View Order</a></td>';
                    body += '</tr>';
                }
                body += '</table>';
            }
            body += '<p>Best regards,<br/>IFB</p>';
            body += '</body></html>';
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> addressList = new  List<String>();
            addressList.add(user.Email);
            mail.setToAddresses(addressList);
            mail.setSubject(subject);
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailNotificationOrderOnHoldController', 'sendEmail', e);
        }
    }
    
}