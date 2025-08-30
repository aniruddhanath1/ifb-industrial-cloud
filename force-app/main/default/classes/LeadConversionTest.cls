@isTest
public class LeadConversionTest {

    @isTest
    static void testLeadConversionWithOpportunity() {
        Account testAccount = new Account(Name = 'Test Account',BillingPostalCode='125001');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Status = 'Nurturing',
            Product_Category__c = 'Industrial Laundry Machine',
            LeadSource = 'IndiaMart',
            Purchase_Timeline__c = '0-30 days',
            Budget_Availablility_Budget_Source__c = 'Yes, Own Source',
            Site_Suitability__c = 'Yes',
            Space_Availability__c = 'Yes',
            Infrastructure_completed_in_30_days__c = 'Yes',
            Rating = 'Hot',
            Shipping__PostalCode__s='560029',
                PostalCode='560029',
            Type_of_Setup__c ='New Setup',
             Customer_Department__c='Abcd',            
            Is_our_contact_a_Key_Decision_Maker__c='YES',
            Type__c='Greenfield',
            Customer_Designation__c='ABCD'
        );
        insert testLead;
        
        LeadConversion.LeadConversionInput input = new LeadConversion.LeadConversionInput();
        input.leadId = testLead.Id;
        input.accountId = testAccount.Id;
        input.contactId = testContact.Id;
        input.doNotCreateOpportunity = false;
        
        Test.startTest();
        List<LeadConversion.LeadConversionOutput> outputs = LeadConversion.convertLeads(new List<LeadConversion.LeadConversionInput>{ input });
        Test.stopTest();
    }

    @isTest
    static void testLeadConversionWithoutOpportunity() {
        Account testAccount = new Account(Name = 'Test Account Without Opportunity',BillingPostalCode='125001');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact Without Opportunity', AccountId = testAccount.Id);
        insert testContact;

        Lead testLead = new Lead(
            FirstName = 'Test Without Opportunity',
            LastName = 'Lead',
            Company = 'Test Company Without Opportunity',
            Status = 'Nurturing',
            Product_Category__c = 'Industrial Laundry Machine',
            LeadSource = 'IndiaMart',
            Purchase_Timeline__c = '0-30 days',
            Budget_Availablility_Budget_Source__c = 'Yes, Own Source',
            Site_Suitability__c = 'Yes',
            Space_Availability__c = 'Yes',
            Infrastructure_completed_in_30_days__c = 'Yes',
            Rating = 'Warm',
            
           Shipping__PostalCode__s='560029',
                PostalCode='560029',
            Type_of_Setup__c ='New Setup',
             Customer_Department__c='Abcd',            
            Is_our_contact_a_Key_Decision_Maker__c='YES',
            Type__c='Greenfield',
            Customer_Designation__c='ABCD'
        );
        insert testLead;

        LeadConversion.LeadConversionInput input = new LeadConversion.LeadConversionInput();
        input.leadId = testLead.Id;
        input.accountId = testAccount.Id;
        input.contactId = testContact.Id;
        input.doNotCreateOpportunity = true;

        Test.startTest();
        List<LeadConversion.LeadConversionOutput> outputs = LeadConversion.convertLeads(new List<LeadConversion.LeadConversionInput>{ input });
        Test.stopTest();
    }

    @isTest
    static void testLeadConversionFailure() {
        Lead testLead = new Lead(
            FirstName = 'Test Failure',
            LastName = 'Lead',
            Company = 'Test Company Failure',
            Status = 'Nurturing',
            Product_Category__c = 'Industrial Laundry Machine',
            Shipping__PostalCode__s='560029',
                PostalCode='560029',
            Type_of_Setup__c ='New Setup',
             Customer_Department__c='Abcd',            
            Is_our_contact_a_Key_Decision_Maker__c='YES',
            Type__c='Greenfield',
            Customer_Designation__c='ABCD'
        );
        insert testLead;
        
        LeadConversion.LeadConversionInput input = new LeadConversion.LeadConversionInput();
        input.leadId = testLead.Id;
        input.accountId = null;
        
        Test.startTest();
        List<LeadConversion.LeadConversionOutput> outputs = LeadConversion.convertLeads(new List<LeadConversion.LeadConversionInput>{ input });
        Test.stopTest();
    }
}