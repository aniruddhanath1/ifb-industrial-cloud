public class LoadCalculatorController {
    @auraEnabled 
    public static List<Linen_Mapping__mdt> getCustomMetadata(String vertical, List<String> linens) {
        List<Linen_Mapping__mdt> metadataList = new List<Linen_Mapping__mdt>();
        try{
            if (String.isBlank(vertical) || linens == null || linens.isEmpty()) {
                return new List<Linen_Mapping__mdt>();
            }
            Set<String> linensRecords = new Set<String>();
            for(String s : linens){
                linensRecords.add(s);
            }
            List<Linen_Mapping__mdt> customMetadataList = [
                SELECT Linen_Weight_in_Kg__c, Vertical__c, Linen__c,Washing__c,Drying__c,Flat_Ironer__c,Ironing_Load_Unshaped_Garments_in_Nos__c
                FROM Linen_Mapping__mdt
                WHERE Vertical__c =: vertical
                AND Linen__c IN :linensRecords
            ];
            metadataList = customMetadataList;
        }
        catch(Exception e){
            ExceptionHandler.logException('LoadCalculatorController' , 'GettingCustomMetaDataWithVerticalAndLinen', e);
        }
        return metadataList; 
        
    }
    @AuraEnabled
    public static void loadCalculatedTrue(Id recordIds){
        try {
            Opportunity opp = [select Id, LoadCalculated__c from Opportunity where Id =: recordIds];
            opp.LoadCalculated__c = true;
            update opp;
        } catch (Exception e) {
            ExceptionHandler.logException('LoadCalculatorController' , 'loadCalculatedTrue', e);
        }
    }
    @AuraEnabled
    public static void setOpportunityValues(String Record, double washing, double drying, double Ironing, String vertical, String selectedLinen, Decimal totalguestWash,Decimal totalguestDry,Decimal totalguestIron,Decimal totalUnshapedGarments,Decimal washingMachineCapacity,Decimal dryingMachineCapacity,Decimal IroningMachineCapacity,Decimal UnshapedGarmentsMachineCapacity,Decimal drycleaning, Decimal tableRequired,Decimal MachineRequired
                                           ,Decimal SingleBedSheet,Decimal doubleBedSheet,Decimal IroningSheetDay,Decimal IroningDoubleSheetDay,Decimal IronHour,Decimal SheetPerHour,Decimal DoubleSheetPerHour,Decimal GuestMachineCapacity,Decimal size) {
        try{
            
            Opportunity opp = [SELECT Id, Total_Load_per_cycle__c, Total_Load_per_Cycle_for_Dry_Load__c, Total_Load_per_Cycle_for__c,
                               Product_category__c, Vertical__c, Linen__c,StageName,Total_Guest_laundry_load_for_Washing__c,
                               Total_Guest_laundry_load_for_drying__c,Total_Guest_laundry_load_for_Ironing__c,
                               Total_No_Of_Unshaped_Garments_Load_Per__c,CurrentValidationTime__c,Washing_Machine_Capacity__c,Unshaped_Garments_Machine_Capacity__c,Ironing_Machine_Capacity__c,Drying_Machine_Capacity__c,Dry_cleaning_Load__c,Vit_Table_Efficiency_hour__c,
                               No_of_Tables_required__c,IFBP_Efficiency_hour__c,No_of_Machines_required__c,No_of_Single_Bed_sheets__c,No_of_Double_bed_Sheets__c,Ironing_single_sheets_day__c,Ironing_Double_bed_sheets_day__c,No_of_Ironing_hours__c,No_of_Single_sheets_hr__c,No_of_Double_bed_Sheets_hr__c,Machine_Capacity_for_Guest_Laundary__c,Size__c,LoadCalculated__c FROM Opportunity WHERE Id = :Record LIMIT 1];
            
            opp.Total_Load_per_cycle__c = washing;
            opp.Total_Load_per_Cycle_for_Dry_Load__c = drying;
            opp.Total_Load_per_Cycle_for__c = ironing;
            opp.Vertical__c = vertical;
            opp.Linen__c = selectedLinen;
            opp.LoadCalculated__c = true;
            opp.StageName = ConstantUtilities.OPPORTUNITY_lOAD_STAGE;
            opp.Total_Guest_laundry_load_for_Washing__c = totalguestWash;
            opp.Total_Guest_laundry_load_for_drying__c = totalguestDry;
            opp.Total_Guest_laundry_load_for_Ironing__c = totalguestIron;
            opp.Total_No_Of_Unshaped_Garments_Load_Per__c = totalUnshapedGarments;
            opp.Washing_Machine_Capacity__c = washingMachineCapacity;
            opp.Unshaped_Garments_Machine_Capacity__c = UnshapedGarmentsMachineCapacity;
            opp.Ironing_Machine_Capacity__c = IroningMachineCapacity;
            opp.Drying_Machine_Capacity__c = dryingMachineCapacity;
            opp.Dry_cleaning_Load__c = drycleaning;
            opp.No_of_Tables_required__c = tableRequired;
            opp.No_of_Machines_required__c = MachineRequired;
            opp.No_of_Double_bed_Sheets__c = doubleBedSheet;
            opp.Ironing_single_sheets_day__c = IroningSheetDay;
            opp.No_of_Single_sheets_hr__c = SheetPerHour;
            opp.No_of_Double_bed_Sheets_hr__c = DoubleSheetPerHour;
            opp.Machine_Capacity_for_Guest_Laundary__c = GuestMachineCapacity;
            opp.Size__c = size;
            opp.LoadCalculated__c = true;
            opp.CurrentValidationTime__c = System.now();
            opp.No_of_Single_Bed_sheets__c = SingleBedSheet;
            opp.Ironing_Double_bed_sheets_day__c = IroningDoubleSheetDay;
            opp.No_of_Ironing_hours__c = IronHour;
            update opp;
        }
        catch(Exception e){
            ExceptionHandler.logException('LoadCalculatorController' , 'UpdatingOpportunityRecordWithLoadCalculationData', e);
        }
    }
    
    @AuraEnabled
    public static List<String> getVerticalandLinen(String recordIds){
        return new List<String>();
    }
    @AuraEnabled
    public static string getProductCategory(String recordIds){
        String pc = '';
        try {
            Opportunity opp = [Select Id,Product_category__c from Opportunity where Id =: recordIds];
            pc = opp.Product_category__c;
        } catch (Exception e) {
            ExceptionHandler.logException('LoadCalculatorController' , 'GettingProductCategory', e);
        }
        return pc;
    }
    
    @AuraEnabled
    public static void UpdatingOpportunityForIDW(String recordIds,Decimal maxHeightGlasses,Decimal glassDiameter,Decimal glassDay,Decimal glassPerHour,
        Decimal HoursWashing,
        Decimal NohoursWashing,
        Decimal glassPeakLoad,
        Decimal maxHeightPlates,
        Decimal platePeakLoad,
        String continousLoad,
        String IWDProducts,
        Decimal glassLine35,
        Decimal glassLine40,
        Decimal glassLine50,
        Decimal glassLine60,
        Decimal glassBasket35,
        Decimal glassBasket40,
        Decimal glassBasket50,
        Decimal glassBasket60,
        Decimal glassHour35,
        Decimal glassHour40,
        Decimal glassHour50,
        Decimal glassHour60,
        String choice35,
        String choice40,
        String choice50,
        String choice60,
        String NoOfPlates,
        String platePerBasket,
        Decimal capacity
    ) {
        try {
            // Fetch the Opportunity record using the provided record ID
            Opportunity opp = [SELECT 
                               Id,
                               Max_height_of_washable_Glasses__c,
                               Diameter_of_glass_in_cm__c,
                               No_of_glass_in_a_day__c,
                               Hours_washing_in_a_day__c,
                               No_of_glasses_per_hour__c,
                               Peak_load_Glasses_hour__c,
                               Peak_load_Plates_hour__c,
                               Continuous_load__c,
                               Industrial_Dishwasher_Product_Type__c,
                               Glasses_in_line_35__c,
                               Glasses_in_line_40__c,
                               Glasses_in_line_50__c,
                               Glasses_in_line_60__c,
                               Glasses_per_basket_35__c,
                               Glasses_per_basket_40__c,
                               Glasses_per_basket_50__c,
                               Glasses_per_basket_60__c,
                               Glasses_per_hour_35__c,
                               Glasses_per_hour_40__c,
                               Glasses_per_hour_50__c,
                               Glasses_per_hour_60__c,
                               Choice_35__c,
                               Choice_40__c,
                               Choice_50__c,
                               Choice_60__c,
                               No_of_plates_per_basket__c,
                               Capacity_Practical_Basket__c,
                               CurrentValidationTime__c,
                               Plate_Diameter_Width_of_plate_in_cm__c,
                               LoadCalculated__c
                               FROM Opportunity WHERE Id = :recordIds];
            
            // Update fields with the provided values
            opp.Max_height_of_washable_Glasses__c = maxHeightGlasses;
            opp.Diameter_of_glass_in_cm__c = glassDiameter;
            opp.No_of_glass_in_a_day__c = glassDay;
            opp.Hours_washing_in_a_day__c = HoursWashing;
            opp.No_of_glasses_per_hour__c = NohoursWashing;
            opp.Peak_load_Glasses_hour__c = glassPeakLoad;
            opp.Plate_Diameter_Width_of_plate_in_cm__c = maxHeightPlates;
            opp.Peak_load_Plates_hour__c = platePeakLoad;
            opp.Continuous_load__c = continousLoad;
            opp.Industrial_Dishwasher_Product_Type__c = IWDProducts;
            opp.Glasses_in_line_35__c = glassLine35;
            opp.Glasses_in_line_40__c = glassLine40;
            opp.Glasses_in_line_50__c = glassLine50;
            opp.Glasses_in_line_60__c = glassLine60;
            opp.Glasses_per_basket_35__c = glassBasket35;
            opp.Glasses_per_basket_40__c = glassBasket40;
            opp.Glasses_per_basket_50__c = glassBasket50;
            opp.Glasses_per_basket_60__c = glassBasket60;
            opp.Glasses_per_hour_35__c = glassHour35;
            opp.Glasses_per_hour_40__c = glassHour40;
            opp.Glasses_per_hour_50__c = glassHour50;
            opp.Glasses_per_hour_60__c = glassHour60;
            opp.Choice_35__c = choice35;
            opp.Choice_40__c = choice40;
            opp.Choice_50__c = choice50;
            opp.choice_60__c = choice60;
            opp.No_of_plates_per_basket__c = NoOfPlates;
            opp.Capacity_Practical_Basket__c = capacity;
            opp.No_of_glasses_per_hour__c = glassPerHour;
            opp.No_of_plates_per_basket__c = platePerBasket;
            opp.LoadCalculated__c = true;
            opp.CurrentValidationTime__c = System.now();
            // Save the updated Opportunity record
            update opp;
            
        } catch (Exception e) {
            ExceptionHandler.logException('LoadCalculatorController', 'UpdatingOpportunityForIDW', e);
            throw new AuraHandledException('An error occurred while updating the Opportunity: ' + e.getMessage());
        }
    }
    
}