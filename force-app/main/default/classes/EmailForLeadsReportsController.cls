/*
@Author : Yadram
@CreatedDate : 14th June 2024
@Description : i) Sending Email to User lead if the created date is today lead.  
ii) Sending Email to User every weekly if leads  Next_Follow_up_Date_Time__c is Null.
*/
public class EmailForLeadsReportsController {
    public static Integer testClassTime;
    @InvocableMethod(label='BusinessDay Reports')
    public static void businessDayReport() {
        try{
            DateTime currentTime = DateTime.now();
            DateTime currentTime1 = system.now();
            Integer currentHour = currentTime.hour();
            List<Lead> listOfLeads  = new List<Lead>();
            Set<Id> leadOwnerIds = new Set<Id>();
            if(Test.isRunningTest()){
                currentHour = testClassTime;
            }
            if((currentHour == ConstantUtilities.DAILY_HOUR)  ){
                for(Lead leadObj : [SELECT Id,Name,Lead_Score__c, Status,Phone,ownerId,Company,Address,CreatedDate,LastModifiedDate FROM lead WHERE CreatedDate = Today]){
                    listOfLeads.add(leadObj);
                    leadOwnerIds.add(leadObj.ownerId);
                }
            }else if(currentHour == ConstantUtilities.WEEKLY_HOUR){
                for(Lead leadObj : [SELECT Id,Name,Lead_Score__c, Status,Phone,Company,ownerId,Address,CreatedDate,
                                    Street ,City,PostalCode, StateCode,  CountryCode FROM lead WHERE  Next_Follow_up_Date_Time__c = null]){
                                        listOfLeads.add(leadObj);
                                        leadOwnerIds.add(leadObj.ownerId);
                                    }
            }
            if(!listOfLeads.isempty() && !leadOwnerIds.isempty()){
                leadDetailMapping(listOfLeads,leadOwnerIds,currentHour );
            }
        }
        catch(Exception e){
            ExceptionHandler.logException('EmailForLeadsReportsController', 'businessDayReport', e);
        }  
    }
    
    
    public static void leadDetailMapping(List<Lead> listOfLeads, Set<Id> ownerIds, Integer currentHour) {
        Map<Id, List<Lead>> userLeadsMap = new Map<Id, List<Lead>>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        try {
            if (!ownerIds.isEmpty() && !listOfLeads.isEmpty()) {
                List<User> userList = [SELECT Id, Email, Name FROM User WHERE Id IN : ownerIds];
                for (Lead lead : listOfLeads) {
                    if (userLeadsMap.containsKey(lead.OwnerId)) {
                        userLeadsMap.get(lead.OwnerId).add(lead);
                    } else {
                        userLeadsMap.put(lead.OwnerId, new List<Lead>{lead});
                    }
                }
                for (User user : userList) {
                    List<Lead> userLeads = userLeadsMap.get(user.Id);
                    if (userLeads != null && !userLeads.isEmpty()) {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        if (currentHour == ConstantUtilities.DAILY_HOUR) {
                            email = createEmail(user, userLeads); 
                        } else if (currentHour == ConstantUtilities.WEEKLY_HOUR) {
                            email = createEmailFor7Days(user, userLeads); 
                        } 
                        if (email != null) {
                            emails.add(email);
                        }
                    }
                }
                if (!emails.isEmpty()) {
                    Messaging.sendEmail(emails);
                }
            }
        } catch (Exception e) {
            ExceptionHandler.logException('EmailForLeadsReportsController', 'leadDetailMapping', e);
        }
    }
    @TestVisible
    private static Messaging.SingleEmailMessage createEmail(User user, List<Lead> leads) {
        String subject = ConstantUtilities.LEAD_EMAIL_SUBJECTEVERYDAY;
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        String body = '<html><body>';
        body += '<p>Hello ' + user.Name + ',</p>';
        if (leads != null && !leads.isEmpty()) {
            body += '<p>A lead has been assigned to you:</p>';
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
        mail.setToAddresses(new String[] { user.Email });
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        return mail;
    }
    @TestVisible
    private static Messaging.SingleEmailMessage createEmailFor7Days(User user, List<Lead> leads) {
        String subject = ConstantUtilities.LEAD_EMIAL_SUBJECT_FOR7DAYS;
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        String body = '<html><body>';
        body += '<p>Hello ' + user.Name + ',</p>';
        if (leads != null && !leads.isEmpty()) {
            body += '<p>Your Leads are in the New status for 7 days. Please reach out to the lead:</p>';
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
        mail.setToAddresses(new String[] { user.Email });
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        return mail;
    }
}