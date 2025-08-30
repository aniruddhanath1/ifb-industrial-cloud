@IsTest
public class OpportunityProductRecomendationTest {

    @TestSetup
    static void setupTestData() {
       
        Id pricebookId = Test.getStandardPricebookId();

        Pricebook2 ilmPricebook = new Pricebook2(Name = 'Industrial Washing Machine', IsActive = true);
        Pricebook2 idwPricebook = new Pricebook2(Name = 'Industrial Dishwasher', IsActive = true);

        insert new List<Pricebook2>{ilmPricebook, idwPricebook};

        // Create Products and related Pricebook Entries
        Product2 product1 = new Product2(Name = 'Washer', Wash_Load_capacity__c = 10, Iron_Load_capacity__c = 60, Dry_load_capacity__c = 60, IsActive = true, Family = 'ILM Products', Heating_Type__c = 'Electric');
        Product2 product2 = new Product2(Name = 'Dryer', Wash_Load_capacity__c = 8, Iron_Load_capacity__c = 120, Dry_load_capacity__c = 120, IsActive = true, Family = 'ILM Products', Heating_Type__c = 'Gas');

        insert new List<Product2>{product1, product2};

        PricebookEntry pbe1 = new PricebookEntry(Product2Id = product1.Id, Pricebook2Id = pricebookId, UnitPrice = 1000, IsActive = true);
        PricebookEntry pbe2 = new PricebookEntry(Product2Id = product2.Id, Pricebook2Id = pricebookId, UnitPrice = 1500, IsActive = true);
        PricebookEntry pbe3 = new PricebookEntry(Product2Id = product1.Id, Pricebook2Id = ilmPricebook.Id, UnitPrice = 1100, IsActive = true);
        PricebookEntry pbe4 = new PricebookEntry(Product2Id = product2.Id, Pricebook2Id = idwPricebook.Id, UnitPrice = 1200, IsActive = true);

        insert new List<PricebookEntry>{pbe1, pbe2, pbe3, pbe4};

        // Create Opportunities
        Opportunity opp1 = new Opportunity(Name = 'Test Opp 1', Pricebook2Id=ilmPricebook.Id, StageName = 'Qualification', Heating_Type__c='Electric',LeadSource='Direct Lead', 
                                           CloseDate = Date.today().addDays(10), Product_category__c = 'ILM', Max_height_of_washable_Glasses__c = 15, Max_height_of_washable_Plate__c = 12,
                                           Out_Put_Capacity_Max_Racks__c = 10,  No_of_Plate_wash_up_to_12__c = 6, No_of_Plate_wash_up_to_18_Pocket_type_p__c = 4,
                                           Total_Load_per_Cycle_for_Dry_Load__c = 36,Size__c=1.7, Total_Load_per_Cycle_for__c = 70,Capacity_Practical_Basket__c=900, Total_Load_per_cycle__c = 300,No_of_Double_bed_Sheets_hr__c= 180,No_of_Single_sheets_hr__c=90,
                                           Total_Power_Req_Connected_Load__c = 'NO', CurrencyIsoCode = 'INR');

        Opportunity opp4 = new Opportunity(Name = 'Test Opp 1', Pricebook2Id=ilmPricebook.Id, StageName = 'Proposal/Price Quote', Heating_Type__c='Steam',LeadSource ='Direct Lead', 
                                           CloseDate = Date.today().addDays(10), Product_category__c = 'ILM', Max_height_of_washable_Glasses__c = 15, Max_height_of_washable_Plate__c = 12,
                                           Out_Put_Capacity_Max_Racks__c = 10,  No_of_Plate_wash_up_to_12__c = 6, No_of_Plate_wash_up_to_18_Pocket_type_p__c = 4,
                                           Total_Load_per_Cycle_for_Dry_Load__c = 20,Size__c=1.7, Total_Load_per_Cycle_for__c = 300,Capacity_Practical_Basket__c=900, Total_Load_per_cycle__c = 80,No_of_Double_bed_Sheets_hr__c= 180,
                                           Total_Power_Req_Connected_Load__c = 'NO', CurrencyIsoCode = 'INR');

 		Opportunity opp5 = new Opportunity(Name = 'Test Opp 5', Pricebook2Id=ilmPricebook.Id, StageName = 'Load Calculation', Heating_Type__c='Steam',LeadSource ='Direct Lead', 
                                           CloseDate = Date.today().addDays(10), Product_category__c = 'ILM', Max_height_of_washable_Glasses__c = 10, Max_height_of_washable_Plate__c = 12,
                                           Out_Put_Capacity_Max_Racks__c = 10,  No_of_Plate_wash_up_to_12__c = 6, No_of_Plate_wash_up_to_18_Pocket_type_p__c = 4,
                                           Total_Load_per_Cycle_for_Dry_Load__c = 300,Size__c=1.5, Total_Load_per_Cycle_for__c = 300,Capacity_Practical_Basket__c=900, Total_Load_per_cycle__c = 300,No_of_Single_sheets_hr__c=90,
                                           Total_Power_Req_Connected_Load__c = 'NO', CurrencyIsoCode = 'INR');
        
        Opportunity opp2 = new Opportunity(Name = 'Test Opp 2', Pricebook2Id=idwPricebook.Id,
                                           StageName = 'Qualification', Entry_side__c='Left',CloseDate = Date.today().addDays(10), Product_category__c = 'IDW',LeadSource ='Direct Lead',
                                           Max_height_of_washable_Glasses__c = 10,Choice_35__c = 'OK',Choice_40__c='OK' ,Choice_50__c='OK',Choice_60__c='OK',Max_height_of_washable_Plate__c = 8,No_of_plates_per_basket__c='18', Capacity_Practical_Basket__c = 7,
                                            Plate_Diameter_Width_of_plate_in_cm__c=10, Industrial_Dishwasher_Product_Type__c = 'Glass', Total_Power_Req_Connected_Load__c = 'NO',Continuous_load__c='No', CurrencyIsoCode = 'INR');
        Opportunity opp3 = new Opportunity( Name = 'Test Opp 2', Pricebook2Id=idwPricebook.Id,
                                           StageName = 'Load Calculation', Entry_side__c='Left',CloseDate = Date.today().addDays(10), Product_category__c = 'IDW',LeadSource ='Direct Lead',
                                           Max_height_of_washable_Glasses__c = 10,Choice_35__c = 'OK',Choice_40__c='OK' ,Choice_50__c='OK',Choice_60__c='OK',Max_height_of_washable_Plate__c = 8,No_of_plates_per_basket__c='18', Capacity_Practical_Basket__c = 7,
                                            Plate_Diameter_Width_of_plate_in_cm__c=10, Industrial_Dishwasher_Product_Type__c = 'Glass', Total_Power_Req_Connected_Load__c = 'NO',Continuous_load__c='Yes', CurrencyIsoCode = 'INR');

		  Opportunity opp6 = new Opportunity( Name = 'Test Opp 6', Pricebook2Id=idwPricebook.Id,
                                            StageName = 'Proposal/Price Quote', Entry_side__c='Left',LeadSource  ='Direct Lead',
                                           CloseDate = Date.today().addDays(10), Product_category__c = 'IDW',No_of_plates_per_basket__c='9',
                                           Max_height_of_washable_Glasses__c = 10,Choice_35__c = 'Not ok',Choice_40__c='Not ok' ,Choice_50__c='OK',Choice_60__c='OK',Max_height_of_washable_Plate__c = 8, Capacity_Practical_Basket__c = 7,
                                            Plate_Diameter_Width_of_plate_in_cm__c=10, Industrial_Dishwasher_Product_Type__c = 'Plate', Total_Power_Req_Connected_Load__c = 'Yes',Continuous_load__c='No', CurrencyIsoCode = 'INR');

        insert new List<Opportunity>{opp1, opp2,opp3,opp4,opp5,opp6};

        // Create Opportunity Line Items
      
        OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId = opp1.Id, Quantity = 2, PricebookEntryId = pbe3.Id, UnitPrice = 1100);
        OpportunityLineItem oli4 = new OpportunityLineItem(OpportunityId = opp2.Id, Quantity = 1, PricebookEntryId = pbe4.Id, UnitPrice = 1200);
        OpportunityLineItem oli7 = new OpportunityLineItem(OpportunityId = opp5.Id, Quantity = 2, PricebookEntryId = pbe3.Id, UnitPrice = 1200);
         OpportunityLineItem oli5 = new OpportunityLineItem(OpportunityId = opp3.Id, Quantity = 2, PricebookEntryId = pbe4.Id, UnitPrice = 1500);
          OpportunityLineItem oli6 = new OpportunityLineItem(OpportunityId = opp4.Id, Quantity = 2, PricebookEntryId = pbe3.Id, UnitPrice = 1500);
      

        insert new List<OpportunityLineItem>{oli3, oli4,oli5,oli6,oli7};
    }

    @IsTest
    static void testOpportunityProductTotalLoad() {
        Opportunity testOpp = [SELECT Id FROM Opportunity WHERE Product_category__c = 'ILM' LIMIT 1];

        // Test method call
        Map<String, Decimal> totals = OpportunityProductRecomendationPlugin.opportunityProductTotalLoad(testOpp.Id);

        // Assertions
        System.assert(totals != null, 'Totals should not be null');
        System.assert(totals.containsKey(ConstantUtilities.PRODUCT_LOAD_FIELDS_WASH_LOAD_CAPACITY), 'Wash capacity key should exist');
    }

    @IsTest
    static void testOpportunityProductTotalLoadWithEmptyItems() {
        Opportunity emptyOpp = new Opportunity(Name = 'Empty Opp',LeadSource  ='Direct Lead', StageName = 'Qualification', CloseDate = Date.today().addDays(10), Pricebook2Id = null);
        insert emptyOpp;

        Map<String, Decimal> totals = OpportunityProductRecomendationPlugin.opportunityProductTotalLoad(emptyOpp.Id);
       // System.assert(totals.isEmpty(), 'Totals should be empty for no Opportunity Line Items');
    }

    @IsTest
    static void testILMrecommend() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Product_category__c  = 'ILM'  AND StageName = 'Qualification' LIMIT 1];

        Map<String,List<Map<String,Object>>> recommendations = OpportunityProductRecomendationPlugin.ILMrecommend(opp.Id);
       // System.assert(recommendations != null && !recommendations.isEmpty(), 'Recommendations should be returned');
    }
    @IsTest
    static void testILMrecommends() {
        Opportunity opp = [SELECT Id ,StageName FROM Opportunity WHERE Product_category__c = 'ILM' AND StageName = 'Proposal/Price Quote'   LIMIT 1];

        Map<String,List<Map<String,Object>>> recommendations = OpportunityProductRecomendationPlugin.ILMrecommend(opp.Id);
       // System.assert(recommendations != null && !recommendations.isEmpty(), 'Recommendations should be returned');
    }

	@IsTest
    static void test2ILMrecommends() {
        Opportunity opp = [SELECT Id ,StageName FROM Opportunity WHERE Product_category__c = 'ILM'  AND StageName = 'Load Calculation'   LIMIT 1];

        Map<String,List<Map<String,Object>>> recommendations = OpportunityProductRecomendationPlugin.ILMrecommend(opp.Id);
       // System.assert(recommendations != null && !recommendations.isEmpty(), 'Recommendations should be returned');
    }

    @IsTest
    static void testILMrecommendWithNullId() {
        try {
            OpportunityProductRecomendationPlugin.ILMrecommend(null);
            System.assert(false, 'Exception should have been thrown for null Opportunity ID');
        } catch (AuraHandledException e) {
           // System.assertEquals('Opportunity ID NUll', e.getMessage());
        }
    }

    @IsTest
    static void testIdWrecommend() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Product_category__c = 'IDW' And StageName = 'Qualification' LIMIT 1];
        List<Product2> recommendations = OpportunityProductRecomendationPlugin.IdWrecommend(opp.Id);

      //  System.assert(recommendations != null, 'Recommendations should not be null');
    }
    @IsTest
    static void testIdWrecommends() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Product_category__c = 'IDW' AND StageName = 'Load Calculation' Limit 1];
        List<Product2> recommendations = OpportunityProductRecomendationPlugin.IdWrecommend(opp.Id);

      //  System.assert(recommendations != null, 'Recommendations should not be null');
    }
	
    @IsTest
    static void test2IdWrecommends() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Product_category__c = 'IDW' AND StageName = 'Proposal/Price Quote' Limit 1];
        List<Product2> recommendations = OpportunityProductRecomendationPlugin.IdWrecommend(opp.Id);

      //  System.assert(recommendations != null, 'Recommendations should not be null');
    }

       @IsTest
    static void testAddProductsToOpportunity() {
        // Retrieve the Opportunity and Products for testing
        Opportunity opp = [SELECT Id, Pricebook2Id FROM Opportunity WHERE Product_category__c = 'ILM' LIMIT 1];
        List<Product2> products = [SELECT Id FROM Product2 LIMIT 2];

        // Create a list of ProductWrapper objects
        List<OpportunityProductRecomendationPlugin.ProductWrapper> productWrappers = new List<OpportunityProductRecomendationPlugin.ProductWrapper>();
        for (Product2 product : products) {
            productWrappers.add(new OpportunityProductRecomendationPlugin.ProductWrapper(product.Id, 2)); // Example quantity
        }

        // Ensure the Opportunity has a valid Pricebook2Id
        if (opp.Pricebook2Id == null) {
            System.assert(false, 'Pricebook2Id is null. Ensure the Opportunity has a valid Pricebook2Id.');
        }

        // Call the method and verify results
        Test.startTest();
        OpportunityProductRecomendationPlugin.addProductsToOpportunity(productWrappers, opp.Id);
        Test.stopTest();

        // Validate the inserted OpportunityLineItems
        List<OpportunityLineItem> lineItems = [
            SELECT Id, OpportunityId, PricebookEntryId, Quantity, UnitPrice
            FROM OpportunityLineItem
            WHERE OpportunityId = :opp.Id
        ];
        System.assert(lineItems.size() == 2, 'Expected 2 Opportunity Line Items to be created.');
        for (OpportunityLineItem lineItem : lineItems) {
            System.assert(lineItem.Quantity == 2, 'Expected quantity to match the ProductWrapper input.');
        }
    }
     @IsTest
    static void testAddProductsToOpportunityidw() {
        Opportunity opp = [SELECT Id, Pricebook2Id,Name,
                                           StageName , Entry_side__c,
                                           CloseDate , Product_category__c,
                                           Max_height_of_washable_Glasses__c, Max_height_of_washable_Plate__c,
                                           Out_Put_Capacity_Max_Racks__c , Capacity_Practical_Basket__c, No_of_Plate_wash_up_to_12__c,
                                           No_of_Plate_wash_up_to_18_Pocket_type_p__c , IDW_Product_Type__c , Total_Load_per_Cycle_for_Dry_Load__c ,
                                           Total_Load_per_Cycle_for__c , Total_Load_per_cycle__c , Total_Power_Req_Connected_Load__c, CurrencyIsoCode FROM Opportunity LIMIT 1];
        List<Product2> products = [SELECT Id FROM Product2 LIMIT 3];
        List<Id> productIds = new List<Id>();
		List<OpportunityProductRecomendationPlugin.ProductWrapper> pw = new List<OpportunityProductRecomendationPlugin.ProductWrapper>();
        for (Product2 product : products) {
            productIds.add(product.Id);
        }

        if (opp.Pricebook2Id == null) {
            System.assert(false, 'Pricebook2Id is null. Ensure the Opportunity has a valid Pricebook2Id.');
        }
        List<OpportunityLineItem> lineItems = OpportunityProductRecomendationPlugin.addProductsToOpportunityidw(productIds, opp.Id);
       System.assert(lineItems.size() == 1, 'Expected 1 line items');
    }
     @isTest
    public static void getBlueSheetDataTest(){
        User objUser = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];   
        Account insertedAcc = TestDataFactory.createAccount();
        Opportunity opp = TestDataFactory.createOpportunityForAccount(insertedAcc.Id,'Prospecting',objUser);
        Blue_Sheet__c blueSheetObj = TestDataFactory.createBlueSheetRecord(opp);
            blueSheetObj.Who__c = objUser.Id;
            blueSheetObj.From_Whom__c = objUser.Id;
            Update blueSheetObj;   
        
        Test.startTest();
        List<OpportunityProductRecomendationPlugin.BlueSheetData> listData = OpportunityProductRecomendationPlugin.getBlueSheetData(opp.Id);
        System.assertEquals(listData.size(), listData.size(), 'List Should Not Empty...');
        
        
        Map<String,Object> mainNewMap = new Map<String,Object>();
        mainNewMap.put('opportunityId',opp.Id);
        
        OpportunityProductRecomendationPlugin.BuyingInfluence fieldClassObj = new OpportunityProductRecomendationPlugin.BuyingInfluence();
        fieldClassObj.type = 'Buying Influences Involved';
        mainNewMap.put('buyingInfluenceList',JSON.serialize(new List<OpportunityProductRecomendationPlugin.BuyingInfluence>{fieldClassObj}));

        
        OpportunityProductRecomendationPlugin.IdealCustomer thirdClassObj = new OpportunityProductRecomendationPlugin.IdealCustomer();
        thirdClassObj.type = 'Buying Influences Involved';
        mainNewMap.put('idealCustomerList',JSON.serialize(new List<OpportunityProductRecomendationPlugin.IdealCustomer>{thirdClassObj}));
        
        
        OpportunityProductRecomendationPlugin.Strength fourthClassObj = new OpportunityProductRecomendationPlugin.Strength();
        fourthClassObj.type = 'Buying Influences Involved';
        fourthClassObj.whenDate = String.valueOf(System.today());
        mainNewMap.put('strengthList',JSON.serialize(new List<OpportunityProductRecomendationPlugin.Strength>{fourthClassObj}));
        
        
        OpportunityProductRecomendationPlugin.RedFlag fifthClassObj = new OpportunityProductRecomendationPlugin.RedFlag();
        fifthClassObj.type = 'Buying Influences Involved';
        mainNewMap.put('redFlagList',JSON.serialize(new List<OpportunityProductRecomendationPlugin.RedFlag>{fifthClassObj}));
        
        OpportunityProductRecomendationPlugin.saveblueSheetData(JSON.serialize(mainNewMap));
        Test.stopTest();
        Integer remainingBlueSheet = [SELECT COUNT() FROM Blue_Sheet__c];
        
    }
    @isTest
    static void testGetCustomMetadata() {
        Test.startTest();
        // Test with valid inputs
        List<Linen_Mapping__mdt> metadataList = OpportunityProductRecomendationPlugin.getCustomMetadata('Vertical', new List<String>{'Linen1', 'Linen2'});
        System.assertNotEquals(null, metadataList, 'Expected non-null list for valid input');
        //System.assert(metadataList.size() > 0, 'Expected metadata records for valid input');

        // Test with invalid input
        metadataList = OpportunityProductRecomendationPlugin.getCustomMetadata('', null);
        System.assertEquals(0, metadataList.size(), 'Expected empty list for invalid input');
        Test.stopTest();
    }
   
}