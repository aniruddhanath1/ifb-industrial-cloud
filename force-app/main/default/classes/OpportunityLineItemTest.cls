@isTest
public class OpportunityLineItemTest {
    @isTest
    static void setupTestData() {
        Id pricebookId = Test.getStandardPricebookId();
        
        Pricebook2 ilmPricebook = new Pricebook2(Name = 'Industrial Washing Machine', IsActive = true);
        Pricebook2 idwPricebook = new Pricebook2(Name = 'Industrial Dishwasher', IsActive = true);
        
        insert new List<Pricebook2>{ilmPricebook, idwPricebook};
            
            // Create Products and related Pricebook Entries
            Product2 product1 = new Product2(Name = 'Washer', Wash_Load_capacity__c = 10, Iron_Load_capacity__c = 60, Dry_load_capacity__c = 60, IsActive = true, Family = 'ILM Products', Heating_Type__c = 'Electric', Shelf_Life_in_Days__c = 20);
        Product2 product2 = new Product2(Name = 'Dryer', Wash_Load_capacity__c = 8, Iron_Load_capacity__c = 120, Dry_load_capacity__c = 120, IsActive = true, Family = 'ILM Products', Heating_Type__c = 'Gas', Shelf_Life_in_Days__c = 30);
        
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
        update oli3;
        delete oli3;
    }
    
}