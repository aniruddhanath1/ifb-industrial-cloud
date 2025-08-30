@isTest
public class ExceptionHandlerTest {

   
    @isTest
    public static void testLogInformation() {

        Test.startTest();
        ExceptionHandler.logInformation('TestClass', 'testLogInformation', 'This is an info message');
        Test.stopTest();
        Log__c log = [SELECT Id, ClassName__c, MethodName__c, Exception_Message__c, Exception_Type__c 
                      FROM Log__c WHERE Exception_Type__c = 'Information' LIMIT 1];

        System.assertNotEquals(null, log);
        System.assertEquals('TestClass', log.ClassName__c);
        System.assertEquals('testLogInformation', log.MethodName__c);
        System.assertEquals('This is an info message', log.Exception_Message__c);
        System.assertEquals('Information', log.Exception_Type__c);
    }

    @isTest
    public static void testLogExceptionWithMessageAndLineNumber() {

        Test.startTest();
        Integer lineNumber = 100;
        ExceptionHandler.logException('TestClass', 'testLogExceptionWithMessageAndLineNumber', 'Test error message', lineNumber);
        Test.stopTest();
        Log__c log = [SELECT Id, ClassName__c, MethodName__c, Exception_Message__c, Exception_Type__c, Line_Number__c 
                      FROM Log__c WHERE Exception_Type__c = 'Error' LIMIT 1];

        System.assertNotEquals(null, log);
        System.assertEquals('TestClass', log.ClassName__c);
        System.assertEquals('testLogExceptionWithMessageAndLineNumber', log.MethodName__c);
        System.assertEquals('Test error message', log.Exception_Message__c);
        System.assertEquals('Error', log.Exception_Type__c);
        System.assertEquals(lineNumber, log.Line_Number__c);
    }

    @isTest
    public static void testLogExceptionWithExceptionObject() {

        Test.startTest();
        try {
            throw new CustomException('Custom exception occurred');
        } catch (CustomException e) {
            ExceptionHandler.logException('TestClass', 'testLogExceptionWithExceptionObject', e);
        }
        Test.stopTest();

        Log__c log = [SELECT Id, ClassName__c, MethodName__c, Exception_Message__c, Exception_Type__c, Line_Number__c, Stack_Trace__c 
                      FROM Log__c WHERE Exception_Type__c = 'Error' LIMIT 1];

        System.assertNotEquals(null, log);
        System.assertEquals('TestClass', log.ClassName__c);
        System.assertEquals('testLogExceptionWithExceptionObject', log.MethodName__c);
        System.assert(log.Exception_Message__c.contains('Custom exception occurred'));
        System.assertEquals('Error', log.Exception_Type__c);
        System.assertNotEquals(null, log.Stack_Trace__c);
    }

    @isTest
    public static void testStackTrace() {
        Log__c logRecord = new Log__c(ClassName__c = 'TestClass', MethodName__c = 'testStackTrace', 
                                      Exception_Message__c = 'Error message', Exception_Type__c = 'Error');
        insert logRecord;
        Test.startTest();
        String stackTraceMessage = 'Stack trace message for testing';
        ExceptionHandler.StackTrace(stackTraceMessage, logRecord.Id);
        Test.stopTest();

        logRecord = [SELECT Id, Stack_Trace__c FROM Log__c WHERE Id = :logRecord.Id LIMIT 1];

        System.assertNotEquals(null, logRecord.Stack_Trace__c);
        System.assertEquals(stackTraceMessage, logRecord.Stack_Trace__c);
    }

    public class CustomException extends Exception {}
}