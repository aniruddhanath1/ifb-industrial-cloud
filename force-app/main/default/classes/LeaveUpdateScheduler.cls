global class LeaveUpdateScheduler implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {
    public Integer batchSize;
    global LeaveUpdateScheduler(Integer batchSize) {
        if ( batchSize != NULL && batchSize < 100) {
            this.batchSize = batchSize;
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Employee_Code__c FROM User WHERE Profile.Name IN ' +
               '(\'' + 'ASM - Area Sales Manager' + '\', ' +
               '\'' + 'RSM - Regional Sales Manager' + '\', ' +
               '\'' + 'NSM - National Sales Manager' + '\')';

		return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext BC, List<User> userList) {
        List<String> empCodes = new List<String>();
        if (!userList.isEmpty()) {
            for (User user : userList) {
                empCodes.add(user.Employee_Code__c);
            }
            LeaveDataHandler.sendLeaveRequest(empCodes, 2, 2);
        }
    }

    global void finish(Database.BatchableContext BC) {
   
    }

    global void execute(SchedulableContext SC) {
        try{
            LeaveUpdateScheduler myBatch = new LeaveUpdateScheduler(batchSize);
        	Database.executeBatch(myBatch, batchSize);
        }catch(Exception e){
            ExceptionHandler.logException('LeaveUpdateScheduler', 'execute', e);
        }
    }
}