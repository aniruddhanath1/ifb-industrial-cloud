public without sharing class LeadInactiveNotification implements Schedulable, Database.Batchable<SObject>, Database.AllowsCallouts {

    private Integer BATCH_SIZE = ConstantUtilities.DEFAULT_BATCH_SIZE;

    public void execute(SchedulableContext sc) {
        Database.executeBatch(this, BATCH_SIZE);
    }
    public LeadInactiveNotification(Integer BATCH_SIZE){
        if(BATCH_SIZE<2000){
            this.BATCH_SIZE = BATCH_SIZE;
        }
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        Date today = Date.today();
        Date thirtyDays = today.addDays(ConstantUtilities.NUMBER_NEGATIVE_30+1);
        Date fortySixDays = today.addDays((ConstantUtilities.NUMBER_NEGATIVE_45));

        String query = 'SELECT Id, OwnerId, Owner.Email, ModifyDateToStage2__c, Status, CreatedDate ' +
                       'FROM Lead ' +
                       'WHERE Status = \'Nurturing\' ' +
                       'AND ModifyDateToStage2__c <= :thirtyDays AND ModifyDateToStage2__c >= :fortySixDays';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        sendEmailAndNotifications(scope);
    }

    private void sendEmailAndNotifications(List<Lead> scope){
        
        try{
            Map<String, IFB_Notification__mdt> notificationMetadata = IFB_Notification__mdt.getAll();
			IFB_Notification__mdt userNotification = notificationMetadata.get(ConstantUtilities.LEAD_INACTIVE_30_DAYS_USER);
            IFB_Notification__mdt managerNotification = notificationMetadata.get(ConstantUtilities.LEAD_INACTIVE_30_DAYS_MANAGER);
            
            OrgWideEmailAddress orgWideEmail = null;
            Date today = Date.today();
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    
            Id notificationTypeId = [
                SELECT Id FROM CustomNotificationType 
                WHERE DeveloperName = :ConstantUtilities.FREQUENTLY_NOTIFICATION 
                LIMIT 1
            ].Id;
    
            List<EmailTemplate> templateList = [SELECT DeveloperName, Id FROM EmailTemplate 
                                WHERE DeveloperName = :ConstantUtilities.REMINDER_30_DAYS 
                                OR DeveloperName = :ConstantUtilities.REMINDER_30_DAYS_MANAGER];
            
            Map<String,EmailTemplate> templateMap = new Map<String, EmailTemplate>();
            for (EmailTemplate temp : templateList) {
                templateMap.put(temp.DeveloperName,temp);
            }
            
            Map<Id, User> userMap = new Map<Id, User>();
            Set<Id> ownerIds = new Set<Id>();
    
            for (Lead lead : scope) {
                ownerIds.add(lead.OwnerId);
            }
    
            userMap.putAll([SELECT Id, Email, ManagerId, Manager.Email FROM User WHERE Id IN :ownerIds]);
            
            for (Lead lead : scope) {
                
                Integer daysSinceModified = today.daysBetween(lead.ModifyDateToStage2__c.date());
                String leadUrl = System.URL.getOrgDomainUrl().toExternalForm() + '/' + lead.Id;
                    
                if (daysSinceModified == ConstantUtilities.NUMBER_NEGATIVE_30) {
                    
                    sendNotification(lead.OwnerId, userNotification.Notification_Title__c, userNotification.Notification_Body__c, notificationTypeId, lead.Id);
                    emails.add(createEmail(lead.Id, templateMap.get(ConstantUtilities.REMINDER_30_DAYS).Id, orgWideEmail, lead.Owner.Email));
                    
                 } else if (daysSinceModified == ConstantUtilities.NUMBER_NEGATIVE_45) {
                     
                    Id managerId = userMap.get(lead.OwnerId).ManagerId;
                    if (managerId != null) {
                       	sendNotification(managerId, managerNotification.Notification_Title__c, managerNotification.Notification_Body__c, notificationTypeId, lead.Id);
                       	emails.add(createEmail(lead.Id, templateMap.get(ConstantUtilities.REMINDER_30_DAYS_MANAGER).Id, orgWideEmail, userMap.get(lead.OwnerId).Manager.Email));
                    	}
                    }
            }
    
            if (!emails.isEmpty()) {
                Messaging.sendEmail(emails);
            }
        }catch (Exception e) {  
                ExceptionHandler.logException('LeadInactiveNotification', 'execute', e);
        }
        
    }
    public void finish(Database.BatchableContext bc) {
        // Optional: Add any logic to be executed after the batch completes
    }

    private void sendNotification(Id userId, String title, String body, Id notificationTypeId, Id leadId) {
        
        try {
            if( userId != null && title != null && body != null && notificationTypeId != null && leadId != null ){
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setTitle(title);
                notification.setBody(body);
                notification.setNotificationTypeId(notificationTypeId);
                notification.setTargetId(leadId);
                notification.send(new Set<String>{userId});
            }
            
        } catch (Exception e) {
            ExceptionHandler.logException('LeadInactiveNotification', 'sendNotification', e);
        }
    }

    private Messaging.SingleEmailMessage createEmail(Id leadId, Id templateId, OrgWideEmailAddress orgWideEmail, String email) {
        if( leadId != null && templateId != null && email != null ){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(leadId);
            message.setTemplateId(templateId);
            message.setToAddresses(new String[] { email });
            if (orgWideEmail != null) {
                message.setOrgWideEmailAddressId(orgWideEmail.Id);
            }
            message.setSaveAsActivity(false);
            message.setTreatTargetObjectAsRecipient(false);
            return message;
        }else{
            throw new EmailException('Valid data to Create Email not found');
        }
    }
}