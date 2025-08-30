@isTest 
public class AttendanceSyncBatchTest {
    
    @testSetup
    public static void dataSetupForTest(){
        User currentUser = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        TestDataFactory.createAttendanceRecord(currentUser);
    }
    
    @isTest
    public static void testClassMethods(){
       
        String sch ='0 48 * * * ?'; 
        Test.startTest();
        String jobId = System.schedule('Schedule to update Account Name', sch,new AttendanceSyncBatch(1));
        CronTrigger ct = [SELECT Id, CronExpression, State FROM CronTrigger WHERE Id = :jobId];
        Test.stopTest();
        System.assertEquals('WAITING', ct.State, 'The scheduled job should be in WAITING state.');
        
    }
    
}