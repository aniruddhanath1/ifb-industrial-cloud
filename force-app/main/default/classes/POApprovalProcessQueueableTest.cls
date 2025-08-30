@isTest
public class POApprovalProcessQueueableTest {
    @isTest
    public static void testMethodOne(){
        Test.startTest();
        Account insertedAcc = TestDataFactory.createAccount();
        order insertedOrder = TestDataFactory.createTestOrder(insertedAcc.Id);     
        System.enqueueJob(new POApprovalProcessQueueable(insertedOrder.Id));
        order orderObj = [SELECT Id, Status From order WHERE Id =: insertedOrder.Id];
        Test.stopTest();
        System.assertEquals('PO Draft', orderObj.Status);
        System.enqueueJob(new POApprovalProcessQueueable(null));
    }
}