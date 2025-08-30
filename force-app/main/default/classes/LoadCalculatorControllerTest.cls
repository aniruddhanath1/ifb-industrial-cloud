@isTest
public class LoadCalculatorControllerTest {

    @testSetup
    static void setupTestData() {
        Opportunity opp = new Opportunity(Name = 'Test Opp 1', StageName = 'Qualification', Heating_Type__c='Electric',LeadSource='Direct Lead', 
                                           CloseDate = Date.today().addDays(10), Product_category__c = 'ILM', Max_height_of_washable_Glasses__c = 15, Max_height_of_washable_Plate__c = 12,
                                           Out_Put_Capacity_Max_Racks__c = 10,  No_of_Plate_wash_up_to_12__c = 6, No_of_Plate_wash_up_to_18_Pocket_type_p__c = 4,
                                           Total_Load_per_Cycle_for_Dry_Load__c = 36,Size__c=1.7, Total_Load_per_Cycle_for__c = 70,Capacity_Practical_Basket__c=900, Total_Load_per_cycle__c = 300,No_of_Double_bed_Sheets_hr__c= 180,No_of_Single_sheets_hr__c=90,
                                           Total_Power_Req_Connected_Load__c = 'NO', CurrencyIsoCode = 'INR');
        insert opp;
    }

    @isTest
    static void testGetCustomMetadata() {
        Test.startTest();
        // Test with valid inputs
        List<Linen_Mapping__mdt> metadataList = LoadCalculatorController.getCustomMetadata('Vertical', new List<String>{'Linen1', 'Linen2'});
        System.assertNotEquals(null, metadataList, 'Expected non-null list for valid input');

        // Test with invalid input
        metadataList = LoadCalculatorController.getCustomMetadata('', null);
        System.assertEquals(0, metadataList.size(), 'Expected empty list for invalid input');
        Test.stopTest();
    }

    @isTest
    static void testLoadCalculatedTrue() {
        Opportunity opp = [SELECT Id, LoadCalculated__c FROM Opportunity LIMIT 1];
        System.assertEquals(false, opp.LoadCalculated__c, 'Initial LoadCalculated__c should be false');

        Test.startTest();
        LoadCalculatorController.loadCalculatedTrue(opp.Id);
        Test.stopTest();

        Opportunity updatedOpp = [SELECT LoadCalculated__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(true, updatedOpp.LoadCalculated__c, 'LoadCalculated__c should be updated to true');
    }

    @isTest
    static void testSetOpportunityValues() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        List<String> lininList = new List<String>{'Engineering Coat'};
        Test.startTest();
        LoadCalculatorController.getCustomMetadata('Hotel Laundry',lininList);
        LoadCalculatorController.setOpportunityValues(opp.id, 1, 1, 1, 'Hotel Laundry', 'Engineering Coat', 1,2,2,2,2,2,1,1,2,3,4
                                           ,5,4,3,6,1,2,5,3,1);
        Test.stopTest();

        Opportunity updatedOpp = [SELECT 
            Total_Load_per_cycle__c, Total_Load_per_Cycle_for_Dry_Load__c, Total_Load_per_Cycle_for__c, Vertical__c, 
            Linen__c, Total_Guest_laundry_load_for_Washing__c, LoadCalculated__c 
        FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(true, updatedOpp.LoadCalculated__c, 'LoadCalculated__c should be updated to true');
    }

    @isTest
    static void testGetProductCategory() {
        Opportunity opp = [SELECT Id, Product_Category__c FROM Opportunity LIMIT 1];

        Test.startTest();
        String result = LoadCalculatorController.getProductCategory(opp.Id);
        Test.stopTest();

        System.assertEquals('ILM', result, 'Product Category should match the setup value');
    }

    @isTest
    static void testUpdatingOpportunityForIDW() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        LoadCalculatorController.loadCalculatedTrue(opp.Id);
        LoadCalculatorController.UpdatingOpportunityForIDW(
            opp.Id, 12.0, 3.5, 200.0, 50.0, 6.0, 8.0, 25.0, 25.0, 300.0, 'Yes', 'Both',
            35.0, 40.0, 50.0, 60.0, 5.0, 6.0, 7.0, 8.0, 100.0, 120.0, 140.0, 160.0, 'Ok', 'Not Ok', 'Not Ok', 'Ok', 
            '9', '18', 80.0
        );
        Test.stopTest();

        Opportunity updatedOpp = [SELECT Max_height_of_washable_Glasses__c, Capacity_Practical_Basket__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(12.0, updatedOpp.Max_height_of_washable_Glasses__c, 'Max height of glasses should match');
    }

    @isTest
    static void testGetVerticalandLinen() {
        Test.startTest();
        List<String> result = LoadCalculatorController.getVerticalandLinen('SomeId');
        Test.stopTest();

        System.assert(result.isEmpty(), 'Result should be empty as the method returns an empty list');
    }
    
}