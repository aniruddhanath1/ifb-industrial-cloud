@isTest
public class EmailForTaskReportsControllerTest {
    
    @isTest
    public static void testMethodOne(){
        User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];
        System.runAs(userObj){
            Account accObj = TestDataFactory.createAccount();
            Task taskObj = TestDataFactory.createTask(accObj);
            taskObj.ownerId = userObj.Id;
            Update taskObj;
            Visit visitObj = TestDataFactory.createVisit(accObj);
            visitObj.ownerId = userObj.Id;
            Update visitObj;
            EmailForTaskReportsController.dailyReport();
            EmailForTaskReportsController.mapping(new List<Task>{taskObj}, new List<Visit>{visitObj});
            Integer invocations = Limits.getEmailInvocations();
            system.assertEquals(1, invocations, 'An email should be sent');
        }
    }
}