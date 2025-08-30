/*
@Author : Yadram
@CreatedDate : 14th June 2024
@Description : i) Sending Email to User lead every business day sla if next follow up date is null.  

*/
public class EmailForLeadsBusinessDaySLAController {
    @InvocableMethod(label='BusinessDay SLA')
    public static void businessDayReport() {
        try{
            DateTime currentTime = DateTime.now();
            Integer currentHour = (Integer)currentTime.hour();
            List<Lead> listOfLeads  = new List<Lead>();
            Set<Id> leadOwnerIds = new Set<Id>();            
            if((currentHour == ConstantUtilities.DAILY_HOUR) || Test.isRunningTest()){
                for(Lead leadObj : [SELECT Id,Name,Lead_Score__c, Status,CreatedDate,Company,Phone,Next_Follow_up_Date_Time__c, ownerId FROM lead WHERE 
                                    CreatedDate = YESTERDAY AND Next_Follow_up_Date_Time__c = null AND Status =: ConstantUtilities.LEADSTATUS_VALIDATED]){
                                        listOfLeads.add(leadObj);
                                        leadOwnerIds.add(leadObj.ownerId);
                                    }
            }
            if(!listOfLeads.isempty() && !leadOwnerIds.isempty()){
                leadDetailMapping(listOfLeads ,leadOwnerIds);
            }
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailForLeadsBusinessDaySLAController', 'businessDayReport', e);
        }    
    }
    public static void sendEmail(User user, List<Lead> leads) {
        try{
            String subject = ConstantUtilities.LEAD_EMAIL_SUBJECT;
            String baseUrl = URL.getOrgDomainUrl().toExternalForm();
            String body = '<html><body>';
            body += '<p>Hello ' + user.Name + ',</p>';
            
            if (leads != null && !leads.isEmpty()) {
                body += '<p>Here are your Lead for Everyday:</p>';
                body += '<table border="1" cellpadding="5" cellspacing="0">';
                body += '<tr><th>Lead Name</th><th>Account Name</th><th>Phone</th><th>Link</th></tr>';
                for (Lead lead : leads) {
                    String leadLink = baseUrl + '/' + lead.Id;
                    body += '<tr>';
                    body += '<td>' + lead.Name + '</td>';
                    body += '<td>' + lead.Company + '</td>';
                    body += '<td>' + (lead.Phone != null ? lead.Phone : '') + '</td>';
                    body += '<td><a href="' + leadLink + '">View Lead</a></td>';
                    body += '</tr>';
                }
                body += '</table>';
            }
            body += '<p>Best regards,<br/>IFB</p>';
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
            ExceptionHandler.logException('EmailForLeadsBusinessDaySLAController', 'sendEmail', e);
        }     
    }
    public static void leadDetailMapping(List<Lead> listOfLeads, Set<Id> ownerIds){
        try{
            
            Map<Id, List<Lead>> userLeadsMap = new Map<Id, List<Lead>>();
            system.debug(ownerIds);
            system.debug(listOfLeads);
            if(!ownerIds.isEmpty() && !listOfLeads.isEmpty()   ){
                List<User> userList = [SELECT Id, Email, Name, ManagerId,Manager.Email FROM User WHERE Id IN : ownerIds AND ManagerId != null];
                
                for (Lead lead : listOfLeads) {
                    if (userLeadsMap.containsKey(lead.OwnerId)) {
                        userLeadsMap.get(lead.OwnerId).add(lead);
                    } else {
                        userLeadsMap.put(lead.OwnerId, new List<Lead>{lead});
                    }
                }   
                for (User user : userList) {
                    List<Lead> userLeads = userLeadsMap.get(user.Id);
                    if ((userLeads != null && !userLeads.isEmpty())) {
                        sendEmail(user, userLeads);
                    }
                } 
            }
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailForLeadsBusinessDaySLAController', 'leadDetailMapping', e);
        }
    }
}