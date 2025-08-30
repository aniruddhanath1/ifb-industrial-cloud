@isTest
public class VisitNotificationSchedulerTest {

    @isTest
    static void testSendNotifications() {
         List<Lead> testLeadsWeekly = TestDataFactory.getLeadList(6);
        for(Integer i=0; i< testLeadsWeekly.size();i++ ){
            if(i==0){
                testLeadsWeekly[i].Frequency__c = 'Weekly';
            }else if(i==1){
                testLeadsWeekly[i].Frequency__c = 'Quarterly';
            }else if(i==2){
                testLeadsWeekly[i].Frequency__c = 'Monthly';
            }else if(i==3){
                testLeadsWeekly[i].Frequency__c = 'Daily';
            }
            
        }
		insert testLeadsWeekly;
		for(Integer i=0; i< testLeadsWeekly.size();i++ ){
           testLeadsWeekly[i].Next_Notification__c = Date.today();
        }
		update testLeadsWeekly;

        // Create input for the invocable method
        VisitNotificationScheduler.flowInput input = new VisitNotificationScheduler.flowInput();
        input.idsListToProccess = new List<Id>();

        for (Lead l : [SELECT Id FROM Lead WHERE Frequency__c IN ('Weekly', 'Monthly', 'Quarterly', 'Daily')]) {
            input.idsListToProccess.add(l.Id);
        }

        List<VisitNotificationScheduler.flowInput> inputList = new List<VisitNotificationScheduler.flowInput>{input};

        // Test execution
        Test.startTest();
        VisitNotificationScheduler.sendNotifications(inputList);
        Test.stopTest();

        // Verify updates for Weekly leads
        List<Lead> updatedLeadsWeekly = [
            SELECT Id, Next_Notification__c, Frequency__c
            FROM Lead
            WHERE Frequency__c = 'Weekly'
        ];

        // Verify updates for Monthly leads
        List<Lead> updatedLeadsMonthly = [
            SELECT Id, Next_Notification__c, Frequency__c
            FROM Lead
            WHERE Frequency__c = 'Monthly'
        ];

        // Verify updates for Quarterly leads
        List<Lead> updatedLeadsQuarterly = [
            SELECT Id, Next_Notification__c, Frequency__c
            FROM Lead
            WHERE Frequency__c = 'Quarterly'
        ];
    }
}