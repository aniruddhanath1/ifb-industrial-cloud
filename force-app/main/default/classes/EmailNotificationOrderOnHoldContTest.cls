@isTest 
public class EmailNotificationOrderOnHoldContTest{
    
    @testSetup
    public static void EmailNotificationOrderOnHoldClass(){
        Account account = TestDataFactory.createAccount();
        Order order = TestDataFactory.createTestOrder(account.Id);
        Order_Installment__c orderInstallmentObj = TestDataFactory.orderInstallmentRecordCreation(order.Id);
    }
    
    @isTest 
    public static void testonHoldOrderReport(){
        Test.startTest();
        Order order = [SELECT Id, status From Order Limit 1];
        order.status ='On Hold';
        Update order; 
        System.assertEquals('On Hold', order.status, 'Expected order status to be On Hold');
        EmailNotificationOrderOnHoldController.onHoldOrderReport();	
        System.assertEquals(1, Limits.getEmailInvocations(), 'An email should have been sent.');
        Test.stopTest();         
    }
    
}