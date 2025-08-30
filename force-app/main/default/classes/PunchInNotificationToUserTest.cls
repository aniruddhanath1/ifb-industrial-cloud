@isTest
public class PunchInNotificationToUserTest {
    @testSetup
    public static void testDataSetup(){
        Event evObjNew = TestDataFactory.createEventRecord();
        evObjNew.Leave_Status__c = 'Approved';
        evObjNew.Type = 'Holiday';
        Update evObjNew;
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()]; 
        TestDataFactory.createAttendanceRecord(userObj);
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        userObj = TestDataFactory.createUserNotInsertedForBulk(profileId.Id, 1);
        Insert userObj; 
       
    }
    
    @isTest
    public static void testClassMethods(){ 
        String sch ='0 48 * * * ?'; 
        String jobId = System.schedule('Schedule to update Account Name', sch,new PunchInNotificationToUser());
        CronTrigger ct = [SELECT Id, CronExpression, State FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('WAITING', ct.State, 'The scheduled job should be in WAITING state.');
       
    }
    
    @isTest
    public static void testClassMethods1(){
        
        User userObj = [SELECT Id From User WHERE Email = 'testuser@example.com'];
        Test.startTest();
        PunchInNotificationToUser.notifyUsersWithoutHoliday();
        PunchInNotificationToUser.getUsersWithHolidayOrLeave();
        PunchInNotificationToUser.handleAttendanceForUsers(new Set<Id>{UserInfo.getUserId(), userObj.Id});
        PunchInNotificationToUser.sendNotifications(new Set<Id>{UserInfo.getUserId(), userObj.Id});
        Test.stopTest();
    }
}