/*
@Author : Pooja Ahuja
@CreatedDate : 13th May 2024
@Description : Class to create test data.
@last modified on  : 13th May 2024
@last modified by  : 
*/
@isTest
public without sharing class TestDataFactory {
    public static List<API_Configuration__c> createAPIConfigRecord() {
        return  new List<API_Configuration__c>{
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Id', JSON_Key__c='LeadId'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Type_of_Customer__c', JSON_Key__c='TypeOfCustomer'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Customer_Category__c', JSON_Key__c='CustomerCategory'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Name', JSON_Key__c='Name'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Email', JSON_Key__c='Email'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Phone', JSON_Key__c='Phone'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Company', JSON_Key__c='AccountName'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Product_Category__c', JSON_Key__c='ProductCategory'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Street', JSON_Key__c='BillingStreet'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='City', JSON_Key__c='BillingCity'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Country', JSON_Key__c='BillingCountry'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='State', JSON_Key__c='BillingState'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='PostalCode', JSON_Key__c='BillingPincode'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Shipping__Street__s', JSON_Key__c='ShippingStreet'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Shipping__City__s', JSON_Key__c='ShippingCity'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Shipping__CountryCode__s', JSON_Key__c='ShippingCountry'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Shipping__StateCode__s', JSON_Key__c='ShippingState'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Shipping__PostalCode__s', JSON_Key__c='ShippingPincode'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='LeadSource', JSON_Key__c='LeadSource'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Lead_Sub_Source__c', JSON_Key__c='LeadSubSource'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Sector__c', JSON_Key__c='Sector'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Customer_Segment_Vertical__c', JSON_Key__c='CustomerSegmentVertical'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Customer_Sub_segment_Sub_Vertical__c', JSON_Key__c='CustomerSubSegmentSubVertical'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Status', JSON_Key__c='LeadStatus'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Next_Follow_up_Date_Time__c', JSON_Key__c='NextFollowupDateTime'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Call_Centre_Remarks__c', JSON_Key__c='CallCentreRemarks'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Description', JSON_Key__c='Description'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='EmployeeName__c', JSON_Key__c='EmployeeName'),
                new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='EmployeeID__c', JSON_Key__c='EmployeeID'),
                new API_Configuration__c(API_Type__c='Lead Status Sync Request', Object_Name__c='Lead', Field_API_Name__c='Id', JSON_Key__c='LeadId'),
                new API_Configuration__c(API_Type__c='Lead Status Sync Request', Object_Name__c='Lead', Field_API_Name__c='Status', JSON_Key__c='LeadStatus')
                };
    }

    public static List<Lead> createLeadsForTesting(Integer count) {
        List<Lead> leads = new List<Lead>();
        Date today = Date.today();

        for (Integer i = 0; i < count; i++) {
            Lead lead = new Lead();
            lead.FirstName = 'Test';
            lead.LastName = 'Lead ';
            lead.Email = 'testlead' + i + '@example.com';
            lead.Company = 'Test Company';
            lead.Status = 'Nurturing';
            lead.ModifyDateToStage2__c = today.addDays(-30 - i); // Staggering dates to ensure some are >=30 and some >=45
            lead.Phone = '999999999' + i; // Unique phone numbers
            lead.PostalCode='680030';
            lead.Product_Category__c = 'Industrial Dishwasher';
            leads.add(lead);
        }

        insert leads;
        return leads;
    }

    public static lead createLead(){
        Lead lead = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Company',
                Status = ConstantUtilities.LEAD_STATUS_UNVALIDATED,PostalCode='726117',Product_Category__c='ILM');
        INSERT lead;
        return lead;
    }

    public static lead createTestLead(String companyName, String postalCode, String ladSource, String category, String productCategory, String requerment, String shipingPostalCode, Boolean isInsert){
        Lead lead = new Lead(
                FirstName = 'Test',
                LastName = 'Lead',
                Company = companyName,
                PostalCode = postalCode,
                Email = 'test@test.com',
                Status = 'Open - Not Contacted',
                LeadSource = ladSource,
                Customer_Category__c = category,
                Product_Category__c = productCategory,
                Requirement__c = requerment,
                Shipping__PostalCode__s = shipingPostalCode
        );
        if(isInsert){
            Insert lead;
        }
        return lead;
    }

    public static Account createAccount(){
        Account testAcc = new Account(
                /*Name = 'Test Account',
                BillingPostalCode = '565685',
                Type = 'Site'*/
            Name = 'Test Account',BillingPostalCode='303303',BillingCity='jaipur',BillingCountryCode = 'IN',BillingStateCode = 'RJ',BillingStreet = 'BTM',ShippingPostalCode='302029',ShippingCity = 'Jaipur',ShippingCountryCode = 'IN',ShippingStateCode = 'RJ',ShippingStreet = 'BTM'
        );
        insert testAcc;
        return testAcc;
    }

    public static Contact createContractForAccount(Id accId, String emailId){
        Contact con = new Contact();
        con.FirstName = 'First Test';
        con.LastName = 'Last Test';
        con.Email = emailId;
        con.Phone = '999-999-9999';
        con.AccountId = accId;
        con.MailingStreet = '123 Test Avenue';
        con.MailingCity = 'Test';
        con.MailingState = 'Florida';
        con.MailingPostalCode = '30010';
        con.MailingCountry = 'United States';
        insert con;

        return con;
    }

    public static Contact createContactWithoutAccount(String firstName,String lastName, String Phone,String Email, String MailinCountryCode,String lead, Boolean isInsert){
        Contact contact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Phone = Phone,
                Email = Email,
                MailingCountryCode = MailinCountryCode,
                Lead__c = lead
        );
        if(isInsert){
            Insert contact;
        }
        return contact;
    }
    public static Contact createContactForAccount(Id accId, String emailId){
        Contact con = new Contact();
        con.FirstName = 'First Test';
        con.LastName = 'Last Test';
        con.Email = emailId;
        con.Phone = '999-999-9999';
        con.AccountId = accId;
        con.MailingStreet = '123 Test Avenue';
        con.MailingCity = 'Test';
        con.MailingState = 'Florida';
        con.MailingPostalCode = '30010';
        con.MailingCountry = 'United States';
        con.Primary_Contact__c = true;
        insert con;

        return con;
    }

    public static List<Lead> createLeadList() {
        List<Lead> leads = new List<Lead>{
                new Lead(
                        LastName = 'TestLeadOne',
                        Company = 'Test-Class Company',
                        Status = 'Nurturing',
                        ModifyDateToStage2__c = Date.today().addDays(-45),
                        PostalCode = '680030',
                        Product_Category__c = 'ILM',
                         Adobe_sync__c = false
                ),
                new Lead(
                        LastName = 'TestLeadTwo',
                        Company = 'Test-Class Company',
                        Status = 'Nurturing',
                        ModifyDateToStage2__c = Date.today().addDays(-30),
                        PostalCode = '680031',
                        Product_Category__c = 'ILM',
                        Adobe_sync__c = false
                )
                };
        insert leads;
        return leads;
    }



    public static EmailTemplate createEmailTemplate(String name, String developerName, String subject, String body, String htmlValue) {
        EmailTemplate template = new EmailTemplate(
                Name = name,
                DeveloperName = developerName,
                Subject = subject,
                Body = body,
                HtmlValue = htmlValue,
                TemplateType = 'text',
                FolderId = UserInfo.getUserId()
        );
        insert template;
        return template;
    }
    public static Opportunity createOpportunity(String name, String stage, Date closeDate, String ProductCategory, String HeatingType  ) {
        Opportunity opp = new Opportunity(
                Name = name,
                StageName = stage,
                CloseDate = closeDate,
                Product_category__c = ProductCategory,
                LeadSource = 'Direct Lead',
                Heating_Type__c=HeatingType
        );
        insert opp;
        return opp;
    }

    public static void setupCustomMetadata() {

        List<Load_Calculator_IDW__mdt> customMetadataRecords = new List<Load_Calculator_IDW__mdt>();

        customMetadataRecords.add(new Load_Calculator_IDW__mdt(
                MasterLabel = 'Test IDW',
                Model__c = 'Test Model',
                ProTech_311_Plus__c = 'Test ProTech 311 Plus'
        ));

    }

    public static Opportunity createOpportunityForAccount(Id accId, String Stagename, User user){
        Opportunity opp = new Opportunity();
        opp.Name ='Test';
        opp.AccountID = accId;
        opp.Type = 'New';
        opp.CloseDate = System.today().addDays(20);
        opp.StageName = Stagename;
        opp.ownerId = user.Id;
        opp.CurrentValidationTime__c = System.now();
        insert opp;
        return opp;
    }
    public static Opportunity createOpportunityAccount(Id accId, String Stagename){
        Opportunity opp = new Opportunity();
        opp.Name ='Test';
        opp.AccountID = accId;
        opp.Type = 'New';
        opp.CloseDate = System.today().addDays(20);
        opp.StageName = Stagename;
        //opp.ownerId = user.Id;
        insert opp;
        return opp;
    }

    public static Opportunity createOpportunityConditionaly(Id accId, String Stagename, Boolean isInsert){
        Opportunity opp = new Opportunity();
        opp.Name ='Test';
        opp.AccountID = accId;
        opp.Type = 'New';
        opp.Product_category__c = 'ILM';
        opp.CloseDate = System.today().addDays(20);
        opp.StageName = Stagename;
        opp.LeadSource = 'Direct Lead';
        opp.Heating_Type__c = 'Electric';
        if(isInsert){
            insert opp;
        }
        return opp;
    }

    public static List<Lead> getLeadList(Integer num){
        List<Lead> testLeadsWeekly=new List<Lead>();
        for (Integer i = 0; i < num; i++) {
            testLeadsWeekly.add(new Lead(
                    FirstName = 'Test',
                    LastName = 'Lead',
                    Company = 'TestCompany' + i,
                    Next_Notification__c = Date.today(),
                    Frequency__c = 'Weekly',
                    Status = 'Open - Not Contacted',
                    PostalCode='56002'+i
            ));
        }
        return testLeadsWeekly;
    }
    /*  public static SBQQ__Quote__c CreateCustomQuote(){
          SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c= TestDataFactory.createOpportunityForAccount.opp.Id, SBQQ__Primary__c=true ,Payment_Term__c=40,
                                                  WarrantyTerm_In_Year__c=1, Freight_Terms__c='Borne by Customer', Total_Amount__c = 10);
        insert quote;
        return quote;
      }
    */

    public static Product2 createProduct2(){
        Product2 prod = new Product2(
                Name = 'WASHER EXTRACTOR IWE 108 – ELECTRIC.',
                ProductCode = 'Test ',
                isActive = true,
                Shelf_Life_in_Days__c = 30,
                Material_Code__c='Test Code'
        );

        insert prod;
        return prod;
    }
    public static Product2 createProduct(String materialCode, String name, String description) {
        Product2 prod = new Product2();
        prod.Material_Code__c = materialCode;
        prod.Name = name;
        prod.Description = description;
        insert prod;
        return prod;
    }
    public static Proforma_Invoice__c createProformaInvoice(Decimal advanceAmount) {
        Proforma_Invoice__c pi = new Proforma_Invoice__c();
        pi.Advance_Amount_to_be_collected__c = advanceAmount;
        insert pi;
        return pi;
    }
    public static Proforma_Invoice_Line_Item__c createLineItem(String productSapId, Id proformaInvoiceId) {
        Proforma_Invoice_Line_Item__c pilineItem = new Proforma_Invoice_Line_Item__c();
        pilineItem.Product_Sap_Id__c = productSapId;
        pilineItem.Proforma_Invoice__c = proformaInvoiceId;
        insert pilineItem;
        return pilineItem;
    }
    public static Invoice__c createInvoice(String invoiceNumber) {
        Invoice__c inv = new Invoice__c();
        inv.Invoice_NO__c = invoiceNumber;
        insert inv;
        return inv;
    }

    public static Invoice_Line_Item__c createLineItemInvoice(String materialCode, Id invoiceId) {
        Invoice_Line_Item__c ilineItem = new Invoice_Line_Item__c();
        ilineItem.Material_Code__c = materialCode;
        ilineItem.Invoice__c = invoiceId;
        insert ilineItem;
        return ilineItem;
    }
    public static Pricebook2 createPriceBook2(String nameVar){
        Pricebook2 standardPricebook = new Pricebook2(
                Name = nameVar,
                IsActive = true
        );
        insert standardPricebook;
        return standardPricebook;
    }

    public static Id createPricebookEntry(Id productId){
        PricebookEntry standardPriceEntry = new PricebookEntry();
        standardPriceEntry.IsActive = true;
        standardPriceEntry.Product2Id = productId;
        standardPriceEntry.Pricebook2Id = Test.getStandardPricebookId();
        standardPriceEntry.UnitPrice = 10;
        standardPriceEntry.UseStandardPrice = false;
        insert standardPriceEntry;

        return standardPriceEntry.Id;
    }

    public static Id createOppLineItem(Id oppId, Id priceBookEntryId, String oppStatus){
        OpportunityLineItem  oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppId;
        oppLineItem.Quantity = 1;
        oppLineItem.PricebookEntryId = priceBookEntryId;
        oppLineItem.TotalPrice = 100.00;
        insert oppLineItem;

        return oppLineItem.Id;
    }


    public static order createTestOrder(ID accId){
        Order order = new Order(
                AccountId = accId,
                EffectiveDate = System.today(),
            //    TotalAmount = 1000,
                Advance_Received_Amount__c = 500,
                Status = 'PO Draft',
                PriceBook2Id = Test.getStandardPricebookId()
        );
        insert order;
        return order;
    }

    public static order createTestOrderConditionaly(ID accId, Boolean isInsert){
        Order order = new Order(
                AccountId = accId,
                EffectiveDate = System.today(),
            //    TotalAmount = 1000,
                Advance_Received_Amount__c = 500,
                Status = 'PO Draft',
                PriceBook2Id = Test.getStandardPricebookId()
        );
        if(isInsert){
            insert order;
        }
        return order;
    }

    public static void createTestOrderLine(ID orderId, Id product2Id, Id pricebookEntryId){
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = orderId;
        lineItem.Quantity = 10;
        lineItem.UnitPrice = 240;
        lineItem.Product2id = product2Id;
        lineItem.PricebookEntryId = pricebookEntryId;
        insert lineItem;

        // Now update & Activate the Order
        Order order = new Order();
        order.Id = orderId;
        order.Status = 'Activated';
        update order;
    }

    public static SBQQ__Quote__c createQuote(Opportunity opp){
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity2__c=opp.Id, SBQQ__Primary__c=true ,Payment_Term__c=40,
                WarrantyTerm_In_Year__c=1, Total_Amount__c = 10,Payment_Split_ratio__c='40:30:20:10');
        insert quote;
        return quote;
    }

    public static SBQQ__QuoteLine__c createQuoteLine(String quoteId, Boolean isBundeld, Integer quantity, String productId){
        SBQQ__QuoteLine__c quoteLineObj = new SBQQ__QuoteLine__c();
        quoteLineObj.SBQQ__Quote__c = quoteId;
        quoteLineObj.SBQQ__Bundle__c = isBundeld;
        quoteLineObj.SBQQ__Quantity__c= quantity;
        quoteLineObj.SBQQ__Product__c = productId;
        Insert quoteLineObj;
        return quoteLineObj;
    }

    public static UserRole createUserRoleNotInserted() {
        UserRole ur = new UserRole(Name = 'State / Regional Head');
        return ur;
    }

    public static User createUserNotInserted(String profileId, String roleId){
        User testUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                Alias = 'tuser',
                Email = 'testuser@example.com',
                Username = 'testuser@example123.com.test',
                EmailEncodingKey = 'UTF-8',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = profileId,
                UserRoleId = roleId
        );

        return testUser;
    }

    public static User createUserNotInsertedForBulk(String profileId, Integer name){
        User testUser = new User(
                FirstName = 'Test'+name,
                LastName = 'User'+name,
                Alias = 'tuser',
                Email = 'testuser@example.com',
                Username = 'testuse'+name+'r@example123.com.test',
                EmailEncodingKey = 'UTF-8',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US',
                ProfileId = profileId
        );

        return testUser;
    }



    public static Blue_Sheet__c createBlueSheetRecord(Opportunity opp){
        Blue_Sheet__c blueSheetObj = new Blue_Sheet__c();
        blueSheetObj.OpportunityId__c = opp.Id;
        //blueSheetObj.Buying_Influences_Involved__c = 'skdjfgsukfs';
        blueSheetObj.Role__c = 'Economic Buying Influence';
        blueSheetObj.Degree_Of_Influence__c = 'High';
        Insert blueSheetObj;
        return blueSheetObj;
    }

    public static Task createTask(Account testAccount){
        Task newTask = new Task(
                Subject = 'Follow up on proposal',
                Status = 'Not Started',
                Priority = 'High',
                WhatId = testAccount.Id, // Associate with the Account record
                ActivityDate = Date.today().addDays(2), // Due date two days from today
                Description = 'Need to follow up with the client on the proposal.'
        );
        insert newTask;
        return newTask;
    }

    public static Visit createVisit(Account testAccount){
        Schema.Location loc = new Schema.Location(
                Name = 'Test Location',
                LocationType = 'Site',
                Longitude = 28.635308,
                Latitude = 28.635308
        );
        insert loc;
        Visit newVisit = new Visit(
                AccountId = testAccount.Id,
                PlannedVisitStartTime = System.now().addDays(5),
                Visit_Type__c='Pre-site inspection',
                Visit_From__c='Lead'

        );
        newVisit.PlaceId = loc.Id;

        insert newVisit;
        return newVisit;
    }

    public static Order_Installment__c orderInstallmentRecordCreation(String orderId){
        Order_Installment__c orderInstallmentObj = new Order_Installment__c();
        orderInstallmentObj.Order__c = orderId;
        orderInstallmentObj.Amount__c = -10.0;
        Insert orderInstallmentObj;
        return orderInstallmentObj;
    }

    public static Invoice__c invoiceRecordCreation(){
        Invoice__c invoiceObj = new Invoice__c();
        invoiceObj.Invoice_NO__c = '123';
        invoiceObj.SO_No__c = '1';
        invoiceObj.PO_NO__c = '1';
        Insert invoiceObj;
        return invoiceObj;
    }

    public static Invoice_Line_Item__c invoiceLineIteamCreation(String productId, String invoiceId){
        Invoice_Line_Item__c invoiceLineIteamObj = new Invoice_Line_Item__c();
        invoiceLineIteamObj.Product__c = productId;
        invoiceLineIteamObj.Material_Code__c = '123';
        invoiceLineIteamObj.Invoice__c = invoiceId;
        Insert invoiceLineIteamObj;
        return invoiceLineIteamObj;
    }

    public static ContentVersion CreateContentVersion(){
        ContentVersion testContent = new ContentVersion(
                Title = 'Initial File',
                PathOnClient = 'InitialFile.txt',
                VersionData = Blob.valueOf('Initial content')
        );
        insert testContent;
        return testContent;
    }

    public static Facility__c createFacilityRecord(){
        Facility__c facilityObj = new Facility__c();
        facilityObj.GST_No__c = 'Test';
        Insert facilityObj;
        return facilityObj;
    }

    public static API_Configuration__c createAPIConfigRecordSingal(Boolean isInsert){

        API_Configuration__c apiConfigObj = new API_Configuration__c(API_Type__c='Lead Sync Request', Object_Name__c='Lead', Field_API_Name__c='Id', JSON_Key__c='LeadId');

        if(isInsert){

            Insert apiConfigObj;

        }

        return apiConfigObj;

    }



    public static Expense__c createExpenseRecord(){

        Expense__c expenseObj = new Expense__c();

        expenseObj.Advance_Amount__c = 10;

        Insert expenseObj;

        return expenseObj;

    }



    public static void contentDocumentLinkInsert(String perantObjId){

        // Create a ContentVersion record (this represents a file)

        ContentVersion contentVersion = new ContentVersion(

                Title = 'Test File',

                PathOnClient = 'TestFile.txt',

                VersionData = Blob.valueOf('Test file content')

        );

        insert contentVersion;



        // Get the ContentDocumentId from the created ContentVersion

        ContentVersion  contentDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];



        // Create a ContentDocumentLink record to associate the file with a Product2 record

        ContentDocumentLink contentDocumentLink = new ContentDocumentLink(

                ContentDocumentId = contentDocument.ContentDocumentId,

                LinkedEntityId = perantObjId, // Link the file to the first Product2 record

                ShareType = 'V',  // Viewer access

                Visibility = 'AllUsers'

        );

        insert contentDocumentLink;

    }



    public static Expense_Line_Item__c expenseLineIteamRecord(String parentId){

        Expense_Line_Item__c expLITObj = new Expense_Line_Item__c();

        expLITObj.Expense__c = parentId;

        Insert expLITObj;

        return expLITObj;

    }

    public static Attendance__c createAttendanceRecord(User userObj){
        Attendance__c atteObjNew = new Attendance__c();
        atteObjNew.User__c = userObj.Id;
        atteObjNew.Punch_In_Time__c = System.now();
        atteObjNew.Punch_Out_Time__c = System.now();
        Insert atteObjNew;
        return atteObjNew;
    }

    public static Event createEventRecord(){
        Event eventObj = new Event(StartDateTime = System.now().addMinutes(10), DurationInMinutes = 5, ActivityDateTime = System.now().addMinutes(10), Employee_Code__c = 'E123', Type = ConstantUtilities.LEAVE, ActivityDate = Date.today(), Leave_Status__c = 'Approved');
        Insert eventObj;
        return eventObj;
    }

    public static Event createEventRecordConditionaly(Boolean isInsert){
        DateTime stsrtTime = system.now();
        Event eventObj = new Event(StartDateTime = stsrtTime, DurationInMinutes = 5, ActivityDateTime = stsrtTime, Employee_Code__c = 'E123', Type = ConstantUtilities.LEAVE, ActivityDate = Date.today().addDays(1), Leave_Status__c = 'Approved');
        if(isInsert){
            Insert eventObj;
        }
        return eventObj;
    }

    public static pricebookEntry createPriceBookEntity(String standardPricebookId, String productId){
        PricebookEntry pricebookEntry = new PricebookEntry(
                Pricebook2Id = standardPricebookId,
                Product2Id = productId,
                UnitPrice = 100.00,
                IsActive = true,
                UseStandardPrice = false
        );
        insert pricebookEntry;
        return pricebookEntry;
    }

    public static OrderItem createOrderLineItemRecord(String orderId, String product2Id, String pricebookEntryId){
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = orderId;
        lineItem.Quantity = 10;
        lineItem.UnitPrice = 240;
        lineItem.Product2id = product2Id;
        lineItem.PricebookEntryId = pricebookEntryId;
        insert lineItem;
        return lineItem;
    }
}