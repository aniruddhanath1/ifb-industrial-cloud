public without sharing class VisitNotificationScheduler {

    @InvocableMethod(label='Send Lead Notifications')
    public static void sendNotifications(List<flowInput> flowinp) {
        try {
            List<id> idsToProcess = new List<id>();  
            if( flowinp != null || !flowinp.isEmpty() ){
                for(flowInput finp : flowinp){
                	idsToProcess.addAll(finp.idsListToProccess);
            	}
            }else{
                return;
            }
			IFB_Notification__mdt notificationData=IFB_Notification__mdt.getInstance(ConstantUtilities.LEAD_VISIT_REMINDER_NOTIFICATION);
            Id notificationTypeId = [
                    SELECT Id FROM CustomNotificationType 
                    WHERE DeveloperName = :ConstantUtilities.FREQUENTLY_NOTIFICATION 
                    LIMIT 1].Id;

            List<Lead> leadsToUpdate = [
                SELECT Id, OwnerId, Next_Notification__c, Frequency__c, Name, Company 
                FROM Lead 
                WHERE Id IN :idsToProcess];
            
			Set<Id> users = new Set<Id>();
            if(!leadsToUpdate.isEmpty()){
            
                for (Lead lead : leadsToUpdate) {
                    users.add(lead.OwnerId);
                    if (lead.Frequency__c == ConstantUtilities.FREQUENCY_WEEKLY) {
                        lead.Next_Notification__c = lead.Next_Notification__c.addDays(7);
                    } else if (lead.Frequency__c == ConstantUtilities.FREQUENCY_MONTHLY) {
                        lead.Next_Notification__c = lead.Next_Notification__c.addMonths(1);
                    } else if (lead.Frequency__c == ConstantUtilities.FREQUENCY_QUARTERLY) {
                        lead.Next_Notification__c = lead.Next_Notification__c.addMonths(3);
                    } else if (lead.Frequency__c == ConstantUtilities.FREQUENCY_DAILY) {
                        lead.Next_Notification__c = lead.Next_Notification__c.addDays(1);
                    }
                }
            }
            
            Map<String, Object> pageReferenceMap = new Map<String, Object>{
                'type' => 'standard__objectPage',
                'attributes' => new Map<String, Object>{
                    'objectApiName' => 'Lead',
                    'actionName' => 'list'
                },
                'state' => new Map<String, Object>{
                    'filterName' => 'Pending_Visits_List_View'
                }
            };
                
			String pageReference = JSON.serialize(pageReferenceMap);

            if(!users.isEmpty()){
               for (Id userId : users) {
              	   notify(userId, notificationTypeId, pageReference,notificationData);
               }
            }

            if (!leadsToUpdate.isEmpty()) {
                 update leadsToUpdate;
             }
        } catch (Exception e) {
            ExceptionHandler.logException('VisitNotificationScheduler', 'sendNotifications', e);
        }
    }

    private static void notify(Id ownerId, Id notificationTypeId, String listViewPage,IFB_Notification__mdt notificationData) {
        try {
            if( ownerId != null && notificationTypeId != null && listViewPage != null && notificationData != null ){
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                notification.setTitle(notificationData.Notification_Title__c);
                notification.setBody(notificationData.Notification_Body__c);
                notification.setNotificationTypeId(notificationTypeId);
                notification.setTargetPageRef(listViewPage);
                notification.send(new Set<String>{ownerId});
            }
        } catch (Exception e) {
            ExceptionHandler.logException('VisitNotificationScheduler', 'notify', e);
        }
    }
    public class flowInput{
        @InvocableVariable
        public List<id> idsListToProccess;
    }
}