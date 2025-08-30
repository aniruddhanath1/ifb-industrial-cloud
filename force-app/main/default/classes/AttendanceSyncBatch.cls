global class AttendanceSyncBatch implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {
    public Integer batchSize;
    public String actionType= Label.AttendanceSync;
    List<Id> attendanceIds = new List<Id>();

    global AttendanceSyncBatch(Integer batchSize) {
        if (this.actionType != null && batchSize != NULL && batchSize < 2000) {
            this.batchSize = batchSize;
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Attendance__c WHERE CreatedDate = TODAY AND User__c != null AND (Punch_Out_Time__c != null OR Punch_In_Time__c != null)';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Attendance__c> attendanceList) {
        List<Id> attendanceIds2 = new List<Id>();
        if (!attendanceList.isEmpty()) {
            for (Attendance__c punchRecord : attendanceList) {
                attendanceIds2.add(punchRecord.Id);
            }
            CalloutHandlerQueue queueData = new CalloutHandlerQueue(attendanceIds2, this.actionType);
        	System.enqueueJob(queueData);
        }
    }

    global void finish(Database.BatchableContext BC) {
        
    }

    global void execute(SchedulableContext SC) {
        try{
            AttendanceSyncBatch myBatch = new AttendanceSyncBatch(batchSize);
        	Database.executeBatch(myBatch, batchSize);
        }catch(Exception e){
            ExceptionHandler.logException('AttendanceSyncBatch', 'execute', e);
        }
    }
}