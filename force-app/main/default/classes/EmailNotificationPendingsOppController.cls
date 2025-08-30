public class EmailNotificationPendingsOppController {
    @InvocableMethod(label='OpportunityNotification')
    public static void opportunityStageReport(){
        try{
            DateTime currentTime = DateTime.now();
            Integer currentHour = (Integer)currentTime.hour();
            List<Opportunity> listOfOpportunities  = new List<Opportunity>();
            Set<Id> oppOwnerIds = new Set<Id>();
            if(currentHour == ConstantUtilities.DAILY_HOUR  || Test.isRunningTest() ){
                for(Opportunity oppObject : [SELECT ID, Name,StageName,LastStageChangeInDays,owner.Name ,owner.Manager.Name,CloseDate FROM opportunity where LastStageChangeInDays > 10]){
                    listOfOpportunities.add(oppObject);
                    oppOwnerIds.add(oppObject.ownerId);
                } 	
            }
            if(!listOfOpportunities.isempty() && !oppOwnerIds.isempty()){
                mapping(listOfOpportunities ,oppOwnerIds);
            }
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailNotificationPendingsOppController', 'opportunityStageReport', e);
        } 
    }  
    public static void mapping(List<Opportunity> listOfOpportunities, Set<Id> oppOwnerIds){
        try{
            Map<Id, List<Opportunity>> userOppMap = new Map<Id, List<Opportunity>>();
            if(!oppOwnerIds.isEmpty() && !listOfOpportunities.isEmpty()   ){
                List<User> userList = [SELECT Id, Email, Name, ManagerId,Manager.Email FROM User WHERE Id IN : oppOwnerIds AND ManagerId != null];
                for (Opportunity oppObject : listOfOpportunities) {
                    if (userOppMap.containsKey(oppObject.OwnerId)) {
                        userOppMap.get(oppObject.OwnerId).add(oppObject);
                    } else {
                        userOppMap.put(oppObject.OwnerId, new List<Opportunity>{oppObject});
                    }
                }
                for (User user : userList) {
                    List<Opportunity> userOpps = userOppMap.get(user.Id);
                    if ((userOpps != null && !userOpps.isEmpty())) {
                        sendEmail(user, userOpps);
                    }
                } 
            }
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailNotificationPendingsOppController', 'mapping', e);
        } 
    }
    
    private static void sendEmail(User user, List<Opportunity> opportunityList) {
        try{
            String subject = ConstantUtilities.OPPORTUNITY_EMAIL_SUBJECT;
            String baseUrl = URL.getOrgDomainUrl().toExternalForm();
            String body = '<html><body>';
            body += '<p>Hello ' + user.Name + ',</p>';
            
            if (opportunityList != null && !opportunityList.isEmpty()) {
                body += '<p>Here are your Opportunity:</p>';
                body += '<table border="1" cellpadding="5" cellspacing="0">';
                body += '<tr><th>Opportunity Name</th><th>Opportunity StageName</th><th>Opportunity CloseDate</th><th>Link</th></tr>';
                for (opportunity oppObject : opportunityList) {
                    String oppoLink = baseUrl + '/' + oppObject.Id;
                    body += '<tr>';
                    body += '<td>' + oppObject.Name + '</td>';
                    body += '<td>' + oppObject.StageName + '</td>';
                    body += '<td>' + oppObject.CloseDate + '</td>';
                    body += '<td><a href="' + oppoLink + '">View  Opportunity</a></td>';
                    body += '</tr>';
                }
                body += '</table>';
            }
            body += '<p>Best regards,<br/>Your Company</p>';
            body += '</body></html>';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> addressList = new  List<String>();
            addressList.add(user.Email);
            addressList.add(user.Manager.Email);
            mail.setToAddresses(addressList);
            mail.setSubject(subject);
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailNotificationPendingsOppController', 'sendEmail', e);
        } 
    }    
}