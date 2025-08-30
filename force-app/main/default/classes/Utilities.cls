public with sharing class Utilities {
    //Added by Atul : June 5,2024 : To capture all the integrtaion error.
    public static Log__c getIntegrationErrorLog(String className,String methodName, String httpMethod,string jsonRequest,string jsonResponse){
        Log__c log = new Log__c();
        log.Type__c = 'Integration Error';
        log.ClassName__c = className;
        log.MethodName__c = methodName;
        log.Http_Method__c = httpMethod;
        log.Json_Request__c=limitLength(jsonRequest,131000);
        log.Json_Response__c=limitLength(jsonResponse,131000);
        return log;      
    }
     //Added by Atul : June 5,2024 : To capture all the exception .
     public static Log__c getExceptionErrorLog(String className,String methodName, Exception e){
        Log__c log = new Log__c();
        log.Type__c = 'Exception';
        log.ClassName__c = className;
        log.MethodName__c = methodName;
        String msg = 'Error Message: ' + e.getMessage() + '\n LineNumber: ' + e.getLineNumber() + '\n Exception Type: ' + e.getTypeName() + '\n Cause: ' + e.getCause() + '\nStack Trace ' + e.getStackTraceString();
        log.Exception_Message__c = msg;
        return log;      
    }
     //Added by Atul : June 5,2024 : To capture all the exception .
     public static Log__c getExceptionErrorLog(String className,String methodName, Exception e, String Ids ){
        Log__c log = new Log__c();
        log.Type__c = 'Exception';
        log.ClassName__c = className;
        log.MethodName__c = methodName;
        String msg = 'Error Message: ' + e.getMessage() + '\n LineNumber: ' + e.getLineNumber() + '\n Exception Type: ' + e.getTypeName() + '\n Cause: ' + e.getCause() + '\nStack Trace ' + e.getStackTraceString() +'\nRecords ' + Ids;
        log.Exception_Message__c = msg;
        return log;      
    }
    //Added by Atul : June 5,2024 : To capture all the integrtaion error.
    public static Log__c getInfoLog(String className,String methodName, string jsonRequest,string jsonResponse){
        Log__c log = new Log__c();
        log.Type__c = 'Info';
        log.ClassName__c = className;
        log.MethodName__c = methodName;
        log.Json_Request__c=limitLength(jsonRequest,131000);
        log.Json_Response__c=limitLength(jsonResponse,131000);
        return log;      
    }
    //Added by Atul : June 5,2024 : To capture all the exception .
    public static Log__c getErrorLog(String className,String methodName, String msg, String Ids ){
        Log__c log = new Log__c();
        log.Type__c = 'Error';
        log.ClassName__c = className;
        log.MethodName__c = methodName;
        log.Exception_Message__c = 'Record Id : '+ Ids +'  Error Message: '+msg;
        return log;      
    }
    //Added by Atul : June 5,2024 : to tirm the longer text.
    public static String limitLength(String str, Integer permittedLength){
        
        String returnString;
        
        if(str != null && str.length() > permittedLength){
            returnString = str.subString(0, permittedLength);
        } else if(str != null && str.length() < permittedLength){
            returnString = str;
        } else if (str == null){
            returnString = '';
        }
        
        return returnString;
    }  
     //Added by yadram : Sept 17,2024 : To Validate phone or landline number of Account/Contact/Lead.
    public static void checkPhoneOrSTDcodeForSObjects(List<SObject> newRecordList) {
        try {
            Set<String> stdCodeSet = new Set<String>();
            Map<String, STD_Codes_MDT__mdt> stdCodeMetadata = STD_Codes_MDT__mdt.getAll();
            for (STD_Codes_MDT__mdt stdMDT : stdCodeMetadata.values()) {
                stdCodeSet.add(stdMDT.MasterLabel);
            }
            for (SObject record : newRecordList) {
                String phoneNumber = getPhoneNumberFromSObject(record);
                if (phoneNumber != null) {
                    Boolean isValid = validatePhoneNumberOrLandLineNO(phoneNumber, stdCodeSet, record);
                    if (!isValid) {
                        record.addError(ConstantUtilities.PHONE_ERROR_MSG);
                    }
                }
            }
        } catch (Exception e) {
            ExceptionHandler.logException('Utilities', 'checkPhoneOrSTDcodeForSObjects', e);
        }
    }
    private static String getPhoneNumberFromSObject(SObject record) {
        String phoneField = null;
        if (record instanceof Lead) {
            phoneField = (String)record.get(ConstantUtilities.PHONE);
        } else if (record instanceof Account) {
            phoneField = (String)record.get(ConstantUtilities.PHONE);
        } else if (record instanceof Contact) {
            phoneField = (String)record.get(ConstantUtilities.PHONE);
        }
        return phoneField;
    }
    // Method to validate a phone number or landline for any SObject (Lead, Account, Contact)
    private static Boolean validatePhoneNumberOrLandLineNO(String phoneNumber, Set<String> stdCodeSet, SObject record) {
        try {
            String leadSource = null;
            String accountSource = null;
            String contactSource = null;
            if (record instanceof Lead) {
                leadSource = (String)record.get(ConstantUtilities.LEADSOURCE);
            }else if(record instanceof Account){
                accountSource = (String)record.get(ConstantUtilities.ACCOUNT_SOURCE);
            }else if(record instanceof Contact){
                contactSource = (String)record.get(ConstantUtilities.LEADSOURCE);
            } 
            if(phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGIT_PLUS)){
                phoneNumber = phoneNumber.substring(3, phoneNumber.length());
                if (phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITZERO) && phoneNumber.length() == 10 &&
                    Pattern.matches(ConstantUtilities.PHONE_REGEX, phoneNumber)) {
                        String twoDigit = phoneNumber.substring(1, 3);
                        String threeDigit = phoneNumber.substring(1, 4);
                        String fourDigit = phoneNumber.substring(1, 5);
                        if (stdCodeSet.contains(twoDigit) || stdCodeSet.contains(threeDigit) || stdCodeSet.contains(fourDigit)) {
                            return true;
                        }
                    } else if ((phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITFIVE) ||
                                phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITSIX) ||
                                phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITSEVEN) ||
                                phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITEIGHT) ||
                                phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITNINE)) &&
                               (phoneNumber.length() == 10 &&
                                Pattern.matches(ConstantUtilities.PHONE_REGEX, phoneNumber))) {
                                    return true;
                                }
            }else if (phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITZERO) && phoneNumber.length() == 10 &&
                      Pattern.matches(ConstantUtilities.PHONE_REGEX, phoneNumber)) {
                          String twoDigit = phoneNumber.substring(1, 3);
                          String threeDigit = phoneNumber.substring(1, 4);
                          String fourDigit = phoneNumber.substring(1, 5);
                          if (stdCodeSet.contains(twoDigit) || stdCodeSet.contains(threeDigit) || stdCodeSet.contains(fourDigit)) {
                              return true;
                          }
                      } else if ((phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITFIVE) ||
                                  phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITSIX) ||
                                  phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITSEVEN) ||
                                  phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITEIGHT) ||
                                  phoneNumber.startsWith(ConstantUtilities.PHONE_FIRSTDIGITNINE)) &&
                                 (phoneNumber.length() == 10 &&
                                  Pattern.matches(ConstantUtilities.PHONE_REGEX, phoneNumber))) {
                                      return true;
                                  } else if (leadSource != null && leadSource == ConstantUtilities.SOURCE_EXPORT_AGENCY &&
                                             Pattern.matches(ConstantUtilities.PHONE_NUMBER_ONLY_REGEX, phoneNumber)) {
                                                 return true;
                                             } else if (accountSource != null && accountSource == ConstantUtilities.SOURCE_EXPORT_AGENCY &&
                                                        Pattern.matches(ConstantUtilities.PHONE_NUMBER_ONLY_REGEX, phoneNumber)) {
                                                            return true;
                                                        } else if (contactSource != null && contactSource == ConstantUtilities.SOURCE_EXPORT_AGENCY &&
                                                                   Pattern.matches(ConstantUtilities.PHONE_NUMBER_ONLY_REGEX, phoneNumber)) {
                                                                       return true;
                                                                   }
        } catch (Exception e) {
            ExceptionHandler.logException('Utilities', 'validatePhoneNumberOrLandLineNO', e);
        }
        return false;
    }
}