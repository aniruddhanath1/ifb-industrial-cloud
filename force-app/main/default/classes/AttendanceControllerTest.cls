@isTest 
public class AttendanceControllerTest {
	@testSetup
    public static void dataSetupForTest(){
        User currentUser = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        TestDataFactory.createAttendanceRecord(currentUser);
    }
    
    @isTest
    public static void testGetPunchCategories(){
        List<AttendanceController.PunchCategoryOption> wrapperList = AttendanceController.getPunchCategories();
        System.assertEquals(2, wrapperList.size(), 'List Should not empty. ');
    }
    
    @isTest
    public static void testcheckPunchStatus(){
        Map<String, Object> returnMap = AttendanceController.checkPunchStatus();
        System.assertEquals(3, returnMap.size(), 'Map Should not empty. ');
    }
    
    @isTest
    public static void testPunchIn(){
        try{
            AttendanceController.punchIn(Double.valueOf(21.23),Double.valueOf(45.56),'Traveling to Site');
        }catch(AuraHandledException exp){
            Delete [SELECT Id From Attendance__c];
            AttendanceController.punchIn(Double.valueOf(21.23),Double.valueOf(45.56),'Traveling to Site');
        }
        
    }
    
    @isTest
    public static void testPunchOut(){
        try{
            AttendanceController.punchOut(Double.valueOf(21.23),Double.valueOf(45.56));
            
        }catch(AuraHandledException exp){
          //  Delete [SELECT Id From Attendance__c];
          //  AttendanceController.punchOut(Double.valueOf(21.23),Double.valueOf(45.56));
        }
        
    }
    
    @isTest
    public static void testPunchOut1(){
        try{
            Delete [SELECT Id From Attendance__c];
            User currentUser = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
            Test.startTest();
            Attendance__c attObj = TestDataFactory.createAttendanceRecord(currentUser);
            attObj.Punch_Out_Time__c = null;
            Update attObj;	
            Test.stopTest();
            AttendanceController.punchOut(Double.valueOf(21.23),Double.valueOf(45.56));
        }catch(AuraHandledException exp){
          //  Delete [SELECT Id From Attendance__c];
          //  AttendanceController.punchOut(Double.valueOf(21.23),Double.valueOf(45.56));
        }
        
        Delete [SELECT Id From Attendance__c];
        try{
              AttendanceController.punchOut(Double.valueOf(21.23),Double.valueOf(45.56));
        }catch(AuraHandledException exp){
          //  Delete [SELECT Id From Attendance__c];
          //  AttendanceController.punchOut(Double.valueOf(21.23),Double.valueOf(45.56));
        }
    }
    
    @isTest
    public static void testPrintLatLog(){
        try{
            AttendanceController.printLatLog('test');
        }catch(AuraHandledException exp){
          //  Delete [SELECT Id From Attendance__c];
          //  AttendanceController.endLoginFlow(Double.valueOf(21.23),Double.valueOf(45.56));
        }
        
    }
    
    @isTest
    public static void testEndLoginFlow(){
        try{
            AttendanceController.endLoginFlow();
        }catch(AuraHandledException exp){
        }
        
    }
}