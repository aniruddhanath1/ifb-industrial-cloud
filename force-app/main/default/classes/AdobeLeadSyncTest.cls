@isTest
public class AdobeLeadSyncTest {
    
    @testSetup
    static void setupTestData() {
        // Create Test Leads
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            testLeads.add(new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Company = 'Test Company' + i,
                Status = 'Open',
                LeadSource = 'Web',
                Rating = 'Cold',
                Next_Follow_up_Date_Time__c = System.Today()+1,
                Requirement__c = 'Washing',
                Purchase_Timeline__c = '31-60 days',
                Site_Suitability__c = 'No',
                Space_Availability__c = 'No',
                Product_Category__c = 'ILM',
                PostalCode='127337'
            ));
        }
        insert testLeads;
        
        // Create Test Accounts and Opportunities
        Account testAccount = new Account(
           /* Name = 'Test Account',
            Type = 'Customer',
            Industry = 'Technology',
            BillingCity = 'New York',
            BillingPostalCode = '172661'*/
            Name = 'Test Account',BillingPostalCode='303303',BillingCity='jaipur',BillingCountryCode = 'IN',BillingStateCode = 'RJ',BillingStreet = 'BTM',ShippingPostalCode='302029',ShippingCity = 'Jaipur',ShippingCountryCode = 'IN',ShippingStateCode = 'RJ',ShippingStreet = 'BTM'
        );
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@example.com',
            Phone = '9234567890',
            AccountId = testAccount.Id,
            Primary_Contact__c = true
        );
        insert testContact;
        
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(30),
            Next_Follow_up_Date_Time__c = System.today()+1,
            AccountId = testAccount.Id,
            LeadSource = 'Referral',
            Rating__c = 'Warm',
            Purchase_Timeline__c = '31-60 days',
            Site__c = 'No',
            Space_Availability__c = 'Yes',
            LeadIDText__c = 'abc'
        );
        insert testOpportunity;
    }
    
    @isTest
    static void testGetLeadData() {
        List<Lead> leads = [SELECT Id, Status, Lead_Score__c, Rating, Next_Follow_up_Date_Time__c, Requirement__c ,Purchase_Timeline__c, Site_Suitability__c, Space_Availability__c,
                                    LeadSource,  Lead_Sub_Source__c,  Product_Category__c,  Type__c, 
                                    Type_of_Customer__c, 
                                    FirstName, LastName, Company, Phone,Alternative_Phone_Number__c, Email, 
                                    Is_our_contact_a_Key_Decision_Maker__c,  Customer_Department__c, Customer_Designation__c,
                                    Street, City, State, PostalCode, Country,
                                    Shipping__Street__s, Shipping__City__s,Shipping__StateCode__s, Shipping__PostalCode__s, Shipping__CountryCode__s,
                                    Name,  Sector__c, Customer_Segment_Vertical__c, Customer_Sub_segment_Sub_Vertical__c, 
                                    Other_Business__c, Other_Locations__c, Region_Name__c, 
                                    Type_of_Setup__c, AnnualRevenue,  Website from lead Where (Status=:ConstantUtilities.LEAD_VALIDATED OR Status=:ConstantUtilities.LEAD_CONTACTED OR Status=:ConstantUtilities.LEAD_NURTURING) AND Adobe_Sync__c=false];
        
        Test.startTest();
        List<AdobeLeadSync.LeadWrapper> leadData = AdobeLeadSync.getLeadData(leads);
        Test.stopTest();
    }
    
    @isTest
    static void testGetOppData() {
        List<Opportunity> opportunities = [ SELECT Id, StageName, LeadSource, Rating__c, Next_Follow_up_Date_Time__c, Purchase_timeline__c, Site__c, Space_Availability__c, 
       LeadIDText__c,Lead_Score__c,Adobe_Sync__c, Product_category__c, Type, Type_of_Customer__c, Name, Budget__c, Type_of_Setup__c, Account.Name,
       Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, 
       Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode, 
       Account.AnnualRevenue, Account.Website, Account.Other_Business__c, Account.Other_Locations_if_applicable__c, 
       Account.Sector__c, Account.Customer_Segment__c, AccountId,Account.Customer_Sub_segment__c,CreatedDate FROM 
       Opportunity Where LeadIDText__c!=null AND AccountId!=null AND Adobe_Sync__c=false];
        
        Test.startTest();
        List<AdobeLeadSync.LeadWrapper> oppData = AdobeLeadSync.getOppData(opportunities);
        Test.stopTest();
    }
    
    /////////////////////////////////////////
      @isTest
    static void testExecuteMethod() {
        //Test.setMock(HttpCalloutMock.class, new AdobeLeadSyncMock());
        List<Opportunity> oppList = [ SELECT Id, StageName, LeadSource, Rating__c, Next_Follow_up_Date_Time__c, Purchase_timeline__c, Site__c, Space_Availability__c, 
       LeadIDText__c,Lead_Score__c,Adobe_Sync__c, Product_category__c, Type, Type_of_Customer__c, Name, Budget__c, Type_of_Setup__c, Account.Name,
       Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, 
       Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode, 
       Account.AnnualRevenue, Account.Website, Account.Other_Business__c, Account.Other_Locations_if_applicable__c, 
       Account.Sector__c, Account.Customer_Segment__c, AccountId,Account.Customer_Sub_segment__c
FROM Opportunity where LeadIDText__c!=null AND AccountId!=null AND Adobe_Sync__c=false];
        
        List<Lead> testLeads = [SELECT Id, Status, Lead_Score__c, Rating, Next_Follow_up_Date_Time__c, Requirement__c ,Purchase_Timeline__c, Site_Suitability__c, Space_Availability__c,
                                    LeadSource,  Lead_Sub_Source__c,  Product_Category__c,  Type__c, 
                                    Type_of_Customer__c, 
                                    FirstName, LastName, Company, Phone,Alternative_Phone_Number__c, Email, 
                                    Is_our_contact_a_Key_Decision_Maker__c,  Customer_Department__c, Customer_Designation__c,
                                    Street, City, State, PostalCode, Country,
                                    Shipping__Street__s, Shipping__City__s,Shipping__StateCode__s, Shipping__PostalCode__s, Shipping__CountryCode__s,
                                    Name,  Sector__c, Customer_Segment_Vertical__c, Customer_Sub_segment_Sub_Vertical__c, 
                                    Other_Business__c, Other_Locations__c, Region_Name__c, 
                                    Type_of_Setup__c, AnnualRevenue,  Website,CreatedDate from lead ];
        System.debug('testLeads '+testLeads);

        Test.startTest();
        AdobeLeadSync leadBatch = new AdobeLeadSync();
        //leadBatch.execute(null, testLeads);
        AdobeLeadSync.getLeadData(testLeads);
        Test.stopTest();

        List<Lead> updatedLeads = [SELECT Id, Adobe_Sync__c FROM Lead WHERE Adobe_Sync__c = true];
    }
    
     @isTest
    static void testExecuteMethod1() {
       // Test.setMock(HttpCalloutMock.class, new AdobeOppSyncMock());
        List<Opportunity> oppList = [ SELECT Id, StageName, LeadSource, Rating__c, Next_Follow_up_Date_Time__c, Purchase_timeline__c, Site__c, Space_Availability__c, 
                                     LeadIDText__c,Lead_Score__c,Adobe_Sync__c, Product_category__c, Type, Type_of_Customer__c, Name, Budget__c, Type_of_Setup__c, Account.Name,
                                     Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, 
                                     Account.ShippingStreet, Account.ShippingCity, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode, 
                                     Account.AnnualRevenue, Account.Website, Account.Other_Business__c, Account.Other_Locations_if_applicable__c, 
                                     Account.Sector__c, Account.Customer_Segment__c, AccountId,Account.Customer_Sub_segment__c,CreatedDate
                                     FROM Opportunity where LeadIDText__c!=null AND AccountId!=null AND Adobe_Sync__c=false];
        System.debug('Opplist '+oppList);
        
        Test.startTest();
        AdobeLeadSync leadBatch = new AdobeLeadSync();
        //leadBatch.execute(null, testLeads);
        AdobeLeadSync.getoppData(oppList);
        Test.stopTest();
    }

}