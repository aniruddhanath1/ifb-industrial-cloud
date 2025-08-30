@isTest
private class IntegrationDataUpdateHandlerTest {

    @isTest
    static void testUpdateRecordsBasedOnResponse_Lead() {
        Lead leadRecord = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company',PostalCode='827117');
        insert leadRecord;
        
        String jsonResponse = '[{"id":"' + leadRecord.Id + '","success":true}]';

        Test.startTest();
        IntegrationDataUpdateHandler.updateRecordsBasedOnResponse('Lead', jsonResponse);
        Test.stopTest();
        
        Lead updatedLead = [SELECT Id, is_Send_To_OMS__c FROM Lead WHERE Id = :leadRecord.Id];
        System.assertEquals(true, updatedLead.is_Send_To_OMS__c, 'Lead should be marked as sent to OMS');
    }

    @isTest
    static void testUpdateRecordsBasedOnResponse_Account() {
        
        Account accRecord = new Account(Name = 'Test Account',BillingPostalCode='627116');
        insert accRecord;
        
        String jsonResponse = '[{"id":"' + accRecord.Id + '","success":true}]';

        Test.startTest();
        IntegrationDataUpdateHandler.updateRecordsBasedOnResponse('Account', jsonResponse);
        Test.stopTest();
        
        Account updatedAccount = [SELECT Id, is_Send_To_OMS__c FROM Account WHERE Id = :accRecord.Id];
        System.assertEquals(true, updatedAccount.is_Send_To_OMS__c, 'Account should be marked as sent to OMS');
    }

    @isTest
    static void testUpdateRecordsBasedOnResponse_Contact() {
        
        Contact conRecord = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert conRecord;
        
        String jsonResponse = '[{"id":"' + conRecord.Id + '","success":true}]';

        Test.startTest();
        IntegrationDataUpdateHandler.updateRecordsBasedOnResponse('Contact', jsonResponse);
        Test.stopTest();
        
        Contact updatedContact = [SELECT Id, is_Send_To_OMS__c FROM Contact WHERE Id = :conRecord.Id];
        System.assertEquals(true, updatedContact.is_Send_To_OMS__c, 'Contact should be marked as sent to OMS');
    }

    @isTest
    static void testUpdateRecordsBasedOnResponse_UnsupportedObject() {
        
        String jsonResponse = '[{"id":"001000000000001","success":true}]';

        Test.startTest();
        try {
            IntegrationDataUpdateHandler.updateRecordsBasedOnResponse('Opportunity', jsonResponse);
            
        } catch (IllegalArgumentException e) {
            
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateRecordsBasedOnResponse_FailureResponse() {
        
        Lead leadRecord = new Lead(FirstName = 'Test', LastName = 'Failure', Company = 'Test Company',PostalCode='827117');
        insert leadRecord;

        String jsonResponse = '[{"id":"' + leadRecord.Id + '","success":false}]';

        Test.startTest();
        IntegrationDataUpdateHandler.updateRecordsBasedOnResponse('Lead', jsonResponse);
        Test.stopTest();

        Lead updatedLead = [SELECT Id, is_Send_To_OMS__c FROM Lead WHERE Id = :leadRecord.Id];
    }
}