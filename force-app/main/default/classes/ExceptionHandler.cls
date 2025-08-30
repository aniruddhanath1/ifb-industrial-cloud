/*
@Author : Neethu Karayil
@CreatedDate : 13th May 2024
@Description : Class to create Exception Handling.
*/


public with sharing class ExceptionHandler {
    
    
        
        public static void logInformation(String className, String methodName, String message){
            Log__c log = new Log__c();
            log.ClassName__c = className;
            log.MethodName__c = methodName;
            log.Exception_Message__c = message;
            log.Exception_Type__c = 'Information';
            Insert log;
        }
        
        
        public static void logException(String className, String methodName, String message, Integer lineNumber){
            Log__c log = new Log__c();
            log.ClassName__c = className;
            log.MethodName__c = methodName;
            log.Exception_Message__c = message;
            log.Exception_Type__c = 'Error';
            log.Line_Number__c = lineNumber;
            Insert log;
        }
       public static void logException(String className, String methodName, Exception e){
            Log__c log = new Log__c();
            log.ClassName__c = className;
            log.MethodName__c = methodName;
            log.Exception_Message__c = e.getMessage();
            log.Exception_Type__c = 'Error';
            log.Line_Number__c = e.getLineNumber();
            log.Stack_Trace__c = e.getStackTraceString();
            Insert log;
            System.debug('log'+log.Id);
        }
     public static void  StackTrace (String message,Id logId){
            Log__c log = new Log__c();
         	log.Id=logId ;
            log.Stack_Trace__c = message;
            Update log;
        }
    }