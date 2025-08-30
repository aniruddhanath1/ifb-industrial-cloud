public without sharing class AttendanceController {

    public class PunchCategoryOption {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }
        
        public PunchCategoryOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    @AuraEnabled
    public static List<PunchCategoryOption> getPunchCategories() {
        List<PunchCategoryOption> options = new List<PunchCategoryOption>();

        try {
            Schema.DescribeFieldResult fieldResult = Attendance__c.Punch_Category__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            for (Schema.PicklistEntry entry : picklistEntries) {
                options.add(new PunchCategoryOption(entry.getLabel(), entry.getValue()));
            }
        } catch (Exception e) {
            ExceptionHandler.logException('AttendanceController', 'getPunchCategories', e);
            throw new AuraHandledException('Error fetching Punch Categories: ' + e.getMessage());
        }

        return options;
    }

    @AuraEnabled
    public static void printLatLog(String location) {
        // Implementation for this method can be added as needed
    }

    @AuraEnabled
    public static Map<String, Object> checkPunchStatus() {
        Map<String, Object> statusMap = new Map<String, Object>();
        Boolean isPunchedInToday = false;
        Boolean isPunchOutDoneToday = false;
		List<Attendance__c> todayAttendances;
        try {
            todayAttendances = [
                SELECT Id, Punch_In_Time__c, Punch_Out_Time__c
                FROM Attendance__c 
                WHERE User__c = :UserInfo.getUserId()
                AND Punch_In_Time__c = TODAY
                LIMIT 1
            ];

            if (!todayAttendances.isEmpty()) {
                Attendance__c todayAttendanceRecord = todayAttendances[0];
                if (todayAttendanceRecord.Punch_Out_Time__c != null) {
                    isPunchOutDoneToday = true;
                }
                if (todayAttendanceRecord.Punch_In_Time__c != null) {
                    statusMap.put('punchInDate',todayAttendances[0].Punch_In_Time__c );
                    isPunchedInToday = true;
                }
            }

        } catch (Exception e) {
            ExceptionHandler.logException('AttendanceController', 'checkPunchStatus', e);
            throw new AuraHandledException('Error checking punch status: ' + e.getMessage());
        }

        statusMap.put('isPunchedInToday', isPunchedInToday);
        statusMap.put('isPunchOutDoneToday', isPunchOutDoneToday);
        return statusMap;
    }

    @AuraEnabled
    public static void punchIn(Double latitude, Double longitude, String punchCategory) {
        try {
            List<Attendance__c> todayAttendances = [
                SELECT Id
                FROM Attendance__c 
                WHERE User__c = :UserInfo.getUserId()
                AND Punch_In_Time__c = TODAY
                LIMIT 1
            ];

            if (!todayAttendances.isEmpty()) {
                throw new AuraHandledException('You have already punched in today.');
            }

            Attendance__c attendanceRecord = new Attendance__c();
            attendanceRecord.User__c = UserInfo.getUserId();
            attendanceRecord.Punch_In_Time__c = System.now();
            attendanceRecord.Punch_In_Latitude__c = latitude;
            attendanceRecord.Punch_In_Longitude__c = longitude;
            attendanceRecord.Punch_Category__c = punchCategory;

            insert attendanceRecord;

        } catch (Exception e) {
            ExceptionHandler.logException('AttendanceController', 'punchIn', e);
            throw new AuraHandledException('Error during Punch In: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void punchOut(Double latitude, Double longitude) {
        try {
            List<Attendance__c> todayAttendances = [
                SELECT Id, Punch_Out_Time__c
                FROM Attendance__c 
                WHERE User__c = :UserInfo.getUserId()
                AND Punch_In_Time__c = TODAY
                LIMIT 1
            ];

            if (todayAttendances.isEmpty()) {
                throw new AuraHandledException('You need to punch in first.');
            }

            Attendance__c todayAttendanceRecord = todayAttendances[0];
            if (todayAttendanceRecord.Punch_Out_Time__c != null) {
                throw new AuraHandledException('You have already punched out today.');
            }

            todayAttendanceRecord.Punch_Out_Time__c = System.now();
            todayAttendanceRecord.Punch_Out_Latitude__c = latitude;
            todayAttendanceRecord.Punch_Out_Longitude__c = longitude;

            update todayAttendanceRecord;

        } catch (Exception e) {
            ExceptionHandler.logException('AttendanceController', 'punchOut', e);
            throw new AuraHandledException('Error during Punch Out: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void endLoginFlow() {
        try {
            Auth.SessionManagement.finishLoginFlow();
        } catch (Exception e) {
            ExceptionHandler.logException('AttendanceController', 'endLoginFlow', e);
            throw new AuraHandledException('Error ending login flow: ' + e.getMessage());
        }
    }
}