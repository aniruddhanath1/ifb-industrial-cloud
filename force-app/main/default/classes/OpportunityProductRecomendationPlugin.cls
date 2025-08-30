public class OpportunityProductRecomendationPlugin {
    
    @AuraEnabled
    public static Map<String, Decimal> opportunityProductTotalLoad(Id oppId) {
        try {
            List<OpportunityLineItem> OpportunityLineItemProduct = [SELECT Id, Product2Id, OpportunityId ,Quantity
                                                                    FROM OpportunityLineItem 
                                                                    WHERE OpportunityId = :oppId];
            
            Map<Id, Decimal> productQuantities = new Map<Id, Decimal>();
            for (OpportunityLineItem oli : OpportunityLineItemProduct) {
                if (productQuantities.containsKey(oli.Product2Id)) {
                    
                    productQuantities.put(oli.Product2Id, productQuantities.get(oli.Product2Id) + oli.Quantity);
                } else {
                    productQuantities.put(oli.Product2Id, oli.Quantity);
                } }
            
            // Initialize totals 
            
            Decimal totalWashLoadCapacity = 0;
            Decimal totalIronLoadCapacity = 0;
            Decimal totalDryLoadCapacity = 0;
            List<Product2> products = [
                SELECT Id, Wash_Load_capacity__c, Iron_Load_capacity__c, Dry_load_capacity__c
                FROM Product2
                WHERE Id IN :productQuantities.keySet()
            ];
            
            
            for (Product2 product : products) {
                Decimal quantity = productQuantities.get(product.Id);
                totalWashLoadCapacity += ((product.Wash_Load_capacity__c != null ? product.Wash_Load_capacity__c: 0))*quantity;
              
                totalDryLoadCapacity += ((product.Dry_load_capacity__c != null ? product.Dry_load_capacity__c  : 0))* quantity;
            }
            // Create a map to store the totals and return it
            Map<String, Decimal> capacityTotals = new Map<String, Decimal>();
            capacityTotals.put(ConstantUtilities.PRODUCT_LOAD_FIELDS_WASH_LOAD_CAPACITY, totalWashLoadCapacity);
           
            capacityTotals.put(ConstantUtilities.PRODUCT_LOAD_FIELDS_DRY_LOAD_CAPACITY, totalDryLoadCapacity);
            
            return capacityTotals;
            
            
            
        } catch (Exception e) {
            
            ExceptionHandler.logException('OpportunityProductRecomendationplugin', 'opportunityProductTotalLoad', e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Map<String,List<Map<String,Object>>> ILMrecommend(Id OppId) {
        try {
            Decimal WashloadIncreaseBy20percentage= 0;
            Decimal DryloadIncreaseBy20percentage= 0;
            Decimal GuestWashloadIncreaseBy20percentage=0;
            Decimal GuestDryloadIncreaseBy20percentage=0;
            // Query the Opportunity details
            if(OppId!=null){
                Opportunity opp = [SELECT Id, Name, Heating_Type__c, Electric_connection_Incoming_Supply_Vol__c, Pricebook2Id, Product_category__c,  Max_height_of_washable_Glasses__c, Max_height_of_washable_Plate__c,
                                   Out_Put_Capacity_Max_Racks__c, Capacity_Practical_Basket__c,No_of_Plate_wash_up_to_12__c, No_of_Plate_wash_up_to_18_Pocket_type_p__c,IDW_Product_Type__c, Total_Load_per_Cycle_for_Dry_Load__c,
                                   No_of_Double_bed_Sheets_hr__c,Size__c,Total_Load_per_Cycle_for__c, Total_Load_per_cycle__c,No_of_Single_sheets_hr__c,Total_Power_Req_Connected_Load__c, CurrencyIsoCode ,Total_Guest_laundry_load_for_drying__c,Total_Guest_laundry_load_for_Ironing__c,Total_Guest_laundry_load_for_Washing__c,Vertical__c
                    				FROM Opportunity WHERE Id = :OppId 
                    				LIMIT 1];
                
                Boolean doesNotContainValue=true;
                if (opp == null) {
                    throw new AuraHandledException('Opportunity not found.');
                }
                
                // Variables to store Opportunity fields
                String productCategory = opp.Product_category__c;
                
                String pricebookId;
                if (productCategory == ConstantUtilities.OPPORTUNITY_ILM) {
                    pricebookId = [Select Id,Name From Pricebook2 Where Name = :ConstantUtilities.ILM_PRICEBOOK_NAME Limit 1].Id;
                }
                
                
                // Update the Opportunity's pricebook
                if (pricebookId != null && opp.Pricebook2Id != pricebookId) {
                    opp.Pricebook2Id = pricebookId;
                    update opp;
                }
                
                // Fetch relevant pricebook entries
                List<PricebookEntry> pricebookEntries = [
                    SELECT Id, Product2Id 
                    FROM PricebookEntry 
                    WHERE Pricebook2Id = :pricebookId And CurrencyIsoCode = :opp.CurrencyIsoCode
                ];
                
                // Create a set of product IDs
                Set<Id> productIds = new Set<Id>();
                for (PricebookEntry pbe : pricebookEntries) {
                    productIds.add(pbe.Product2Id);
                }
                
                // Initialize the result list
               
                
                
                // ILM Product Recommendations
                
                List<Product2> products = [
                    SELECT Id, Name, RecordType.DeveloperName, Family,ProductCode, 
                    Dry_load_capacity__c, Iron_Load_capacity__c, Wash_Load_capacity__c, Heating_type__c
                    FROM Product2
                    WHERE Id IN :productIds
                ];
              
                
                List<Map<String, Object>> recommendations = new List<Map<String, Object>>();
                List<Map<String, Object>> guestRecommendations = new List<Map<String, Object>>();
                    
                    // Decimal totalDryLoad = Increateload20percent(opp.Total_Load_per_Cycle_for_Dry_Load__c);
                    
                    WashloadIncreaseBy20percentage = Increateload20percent(opp.Total_Load_per_cycle__c);
                    DryloadIncreaseBy20percentage =Increateload20percent(opp.Total_Load_per_Cycle_for_Dry_Load__c);
                    List<Map<String, Object>> washLoadRecommendations = getILMRecommendations(WashloadIncreaseBy20percentage, products, ConstantUtilities.PRODUCT_LOAD_FIELDS_WASH_LOAD_CAPACITY,opp.Heating_Type__c);
                    List<Map<String, Object>> ironLoadRecommendations = getILMRecommendationsIRON(opp.No_of_Single_sheets_hr__c,opp.No_of_Double_bed_Sheets_hr__c,opp.Size__c ,products, ConstantUtilities.PRODUCT_LOAD_FIELDS_IRON_LOAD_CAPACITY,opp.Heating_Type__c);
                    List<Map<String, Object>> dryLoadRecommendations = getILMRecommendations(DryloadIncreaseBy20percentage, products, ConstantUtilities.PRODUCT_LOAD_FIELDS_DRY_LOAD_CAPACITY,opp.Heating_Type__c);
                    
                    recommendations.addAll(washLoadRecommendations);
                    recommendations.addAll(ironLoadRecommendations);
                    recommendations.addAll(dryLoadRecommendations);
                
             
                    List<Map<String, Object>> guestDryLoadRecommendations = getILMRecommendations(opp.Total_Guest_laundry_load_for_drying__c, products, ConstantUtilities.PRODUCT_LOAD_FIELDS_DRY_LOAD_CAPACITY,opp.Heating_Type__c);
                    //List<Map<String, Object>> guestIronLoadRecommendations = getILMRecommendationsIRON(opp.Total_Guest_laundry_load_for_Ironing__c,opp.No_of_Double_bed_Sheets_hr__c ,products, ConstantUtilities.PRODUCT_LOAD_FIELDS_IRON_LOAD_CAPACITY,opp.Heating_Type__c);
                    List<Map<String, Object>> guestWashLoadRecommendations = getILMRecommendations(opp.Total_Guest_laundry_load_for_Washing__c, products, ConstantUtilities.PRODUCT_LOAD_FIELDS_WASH_LOAD_CAPACITY,opp.Heating_Type__c);
                    
                    guestRecommendations.addAll(guestDryLoadRecommendations);
                    //productRecommendations.addAll(guestIronLoadRecommendations);
                    guestRecommendations.addAll(guestWashLoadRecommendations);

                    Map<String, List<Map<String, Object>>> separatedRecommendations = new Map<String, List<Map<String, Object>>>();
                    separatedRecommendations.put('Recommendations', recommendations);
                    separatedRecommendations.put('GuestRecommendations', guestRecommendations);
                
            
                return separatedRecommendations;
            }
            
            
            else{
                throw new AuraHandledException('Opportunity ID NUll');
            }
            
        } catch (Exception e) {
            String errorMessage = 'Error: ' + e.getMessage() + ' - Stack Trace: ' + e.getStackTraceString();
            ExceptionHandler.logException('OpportunityProductRecommendationPlugin', 'ILMrecommend', errorMessage, e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    
    private static Integer Increateload20percent(Decimal totalload){
        try{
        Decimal increasedLoad = totalLoad + (20 *totalload) / 100;
        Integer IincreasedLoad = Math.ceil(increasedLoad).intValue();
        return IincreasedLoad;
        }
        catch (Exception e) {
            String errorMessage = 'Error: ' + e.getMessage() + ' - Stack Trace: ' + e.getStackTraceString();
            ExceptionHandler.logException('OpportunityProductRecommendationPlugin', 'Increateload20percent', errorMessage, e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
       
    }
    
    @AuraEnabled
    public static List<Product2> IdWrecommend(Id OppId) {
        try {
            // Query the Opportunity details
            Opportunity opp = [
                SELECT Id, Name, Capacity_Practical_Basket__c,Choice_35__c, Choice_40__c, Choice_50__c, Choice_60__c, Continuous_load__c,Max_height_of_washable_Glasses__c,Max_height_of_washable_Plate__c,
                Electric_connection_Incoming_Supply_Vol__c,Plate_Diameter_Width_of_plate_in_cm__c, Pricebook2Id, Product_category__c, CurrencyIsoCode,No_of_plates_per_basket__c, 
                Industrial_Dishwasher_Product_Type__c
                FROM Opportunity 
                WHERE Id = :OppId 
                LIMIT 1
            ];
            if (opp == null) {
                throw new AuraHandledException('Opportunity not found.');
            }
            
            // Variables to store Opportunity fields
            String productCategory = opp.Product_category__c;
            String pricebookId;
            
            if (productCategory == ConstantUtilities.OPPORTUNITY_IDW) {
                pricebookId = [SELECT Id FROM Pricebook2 WHERE Name = :ConstantUtilities.IDW_PRICEBOOK_NAME LIMIT 1].Id;
            }
            
            // Update the Opportunity's pricebook
            if (pricebookId != null && opp.Pricebook2Id != pricebookId) {
                opp.Pricebook2Id = pricebookId;
                update opp;
            }
            
            // Fetch relevant pricebook entries
            List<PricebookEntry> pricebookEntries = [
                SELECT Id, Product2Id 
                FROM PricebookEntry 
                WHERE Pricebook2Id = :pricebookId
            ];
            
            // Create a set of product IDs
            Set<Id> productIds = new Set<Id>();
            for (PricebookEntry pbe : pricebookEntries) {
                productIds.add(pbe.Product2Id);
            }
            
            // Initialize the product list
            List<Product2> IDWProduct = new List<Product2>();
            
            // Dynamically build the rack size filter based on choices
            Set<String> rackSizes = new Set<String>();
            if (opp.Choice_35__c == 'ok') {
                rackSizes.add(ConstantUtilities.RACK_SIZE35);
            }
            if (opp.Choice_40__c == 'ok') {
                rackSizes.add(ConstantUtilities.RACK_SIZE40);
            }
            if (opp.Choice_50__c == 'ok') {
                rackSizes.add(ConstantUtilities.RACK_SIZE50);
            }
            if (opp.Choice_60__c == 'ok') {
                rackSizes.add(ConstantUtilities.RACK_SIZE60);
            }
            if(opp.Industrial_Dishwasher_Product_Type__c == ConstantUtilities.INDUSTRIAL_DISHWASHER_PRODUCT_TYPE_GLASS){
                
                if (opp.Industrial_Dishwasher_Product_Type__c == ConstantUtilities.INDUSTRIAL_DISHWASHER_PRODUCT_TYPE_GLASS && 
                    (opp.Choice_35__c == 'ok' || opp.Choice_40__c == 'ok') && 
                    opp.Continuous_load__c != 'Yes') {
                        
                        // Query products with the specific conditions, only fetching those with Family = ConstantUtilities.FAMILY_INDUSTRIAL_GLASSWASHER
                        IDWProduct = [
                            SELECT Id, Name, ProductCode, Description, Family, CurrencyIsoCode, Electric_Connection_ISV__c, Rack_Size__c,Max_Height_Of_Washable_Glasses__c
                            FROM Product2
                            WHERE Id IN :productIds
                            AND Max_Height_Of_Washable_Glasses__c>=: opp.Max_height_of_washable_Glasses__c
                            AND Rack_Size__c IN :rackSizes
                        ];
                        
                    } 
                else  {
                    // Default behavior - check the Continuous_load__c field
                    if (opp.Continuous_load__c == 'Yes') {
                        // Query products with the specific Electric_Connection_ISV__c value and rack size filter
                        IDWProduct = [
                            SELECT Id, Name, ProductCode, Description, Family, CurrencyIsoCode, Electric_Connection_ISV__c, Rack_Size__c
                            FROM Product2
                            WHERE Id IN :productIds
                            AND Electric_Connection_ISV__c =: ConstantUtilities.ELECTRIC_CONNECTION_ISV_3P40050N
                            AND Family !=: ConstantUtilities.FAMILY_INDUSTRIAL_GLASSWASHER
                            AND Max_Height_Of_Washable_Glasses__c>=: opp.Max_height_of_washable_Glasses__c
                            AND Rack_Size__c IN :rackSizes
                        ];
                    } else {
                        // Query products with rack size filter only
                        IDWProduct = [
                            SELECT Id, Name, ProductCode, Description, Family, CurrencyIsoCode, Electric_Connection_ISV__c, Rack_Size__c
                            FROM Product2
                            WHERE Id IN :productIds
                            AND Family !=: ConstantUtilities.FAMILY_INDUSTRIAL_GLASSWASHER
                            AND Max_Height_Of_Washable_Glasses__c>=: opp.Max_height_of_washable_Glasses__c
                            AND Rack_Size__c IN :rackSizes
                        ];
                    }
                }
               
                
                
            }
            else{
               
                if( Decimal.valueOf(opp.No_of_plates_per_basket__c)<12 && Decimal.valueOf(opp.No_of_plates_per_basket__c)>0 ){
                   
                        IDWProduct = [
                            SELECT Id, Name, ProductCode, Description, Family, CurrencyIsoCode, Electric_Connection_ISV__c,Capicity_For_No_of_Plate_wash_up_to_18__c,Capacity_For_No_of_Plate_wash_up_to_12__c, Rack_Size__c
                            FROM Product2
                            WHERE Id IN :productIds
                            AND Electric_Connection_ISV__c =: ConstantUtilities.ELECTRIC_CONNECTION_ISV_3P40050N
                            AND Family !=: ConstantUtilities.FAMILY_INDUSTRIAL_GLASSWASHER
                            AND Max_Height_Of_Washable_Plate__c>=: opp.Plate_Diameter_Width_of_plate_in_cm__c
                            AND Capacity_For_No_of_Plate_wash_up_to_12__c >=:opp.Capacity_Practical_Basket__c
                        ];
                        
                    }
                    
                    else{
                        IDWProduct = [
                            SELECT Id, Name, ProductCode, Description, Family,Capicity_For_No_of_Plate_wash_up_to_18__c,Capacity_For_No_of_Plate_wash_up_to_12__c, CurrencyIsoCode, Electric_Connection_ISV__c, Rack_Size__c
                            FROM Product2
                            WHERE Id IN :productIds
                            AND Electric_Connection_ISV__c =: ConstantUtilities.ELECTRIC_CONNECTION_ISV_3P40050N
                            AND Family !=: ConstantUtilities.FAMILY_INDUSTRIAL_GLASSWASHER
                            AND Max_Height_Of_Washable_Plate__c>=: opp.Plate_Diameter_Width_of_plate_in_cm__c
                            AND Capicity_For_No_of_Plate_wash_up_to_18__c>=:opp.Capacity_Practical_Basket__c
                            
                            
                        ];
                    }
            }
            
            return IDWProduct;
        } catch (Exception e) {
            // Log the exception and rethrow a user-friendly message
            ExceptionHandler.logException('OpportunityProductRecommendationPlugin', 'IdWrecommend', e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    
    
    @AuraEnabled
    public static List<OpportunityLineItem> addProductsToOpportunityidw(List<Id> productIds, Id opportunityId) {
        try{
            
            if (productIds == null || productIds.isEmpty() || opportunityId == null) {
           
                throw new IllegalArgumentException('Product IDs and Opportunity ID must be provided.');
            }
            
            Opportunity opp = [
                SELECT Id, Pricebook2Id, CurrencyIsoCode 
                FROM Opportunity 
                WHERE Id = :opportunityId 
                LIMIT 1
            ];
            
            if (opp == null) {
                throw new IllegalArgumentException('Invalid Opportunity ID.');
            }
            
            List<PricebookEntry> pricebookEntries = [
                SELECT Id, Product2Id, UnitPrice, CurrencyIsoCode
                FROM PricebookEntry
                WHERE Product2Id IN :productIds AND Pricebook2Id = :opp.Pricebook2Id AND CurrencyIsoCode = :opp.CurrencyIsoCode
            ];
            
            if (pricebookEntries.isEmpty()) {
                throw new IllegalArgumentException('No pricebook entries found for the provided product IDs in the opportunity currency.');
            }
            
            List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
            for (PricebookEntry pbe : pricebookEntries) {
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityId = opportunityId;
                oli.PricebookEntryId = pbe.Id;
                oli.Quantity = 1; // Default quantity, adjust as necessary
                oli.UnitPrice = pbe.UnitPrice;
                lineItems.add(oli);
            }
            
            if (!lineItems.isEmpty()) {
                insert lineItems;
            }
            return lineItems;
            
        }
        catch (Exception e) {
            
            ExceptionHandler.logException('OpportunityProductRecomendationplugin', 'addProductsToOpportunityidw', e);
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    
    @AuraEnabled
    public static void addProductsToOpportunity(List<ProductWrapper> products, Id opportunityId) {
        try{
            
            Opportunity opp = [
                SELECT Id, Pricebook2Id, CurrencyIsoCode 
                FROM Opportunity 
                WHERE Id = :opportunityId 
                LIMIT 1
            ];
            
            if (opp == null) {
                throw new AuraHandledException('Invalid Opportunity ID.');
            }
            
            // Collect product IDs
            Set<Id> productIds = new Set<Id>();
            for (ProductWrapper productWrapper : products) {
                productIds.add(productWrapper.Id);
            }
            
            
            // Query PricebookEntry records that match the product IDs, Pricebook2Id, and CurrencyIsoCode
            List<PricebookEntry> pricebookEntries = [
                SELECT Id, Product2Id, UnitPrice, CurrencyIsoCode
                FROM PricebookEntry
                WHERE Product2Id IN :productIds 
                AND Pricebook2Id = :opp.Pricebook2Id 
                AND CurrencyIsoCode = :opp.CurrencyIsoCode
            ];
            
            if (pricebookEntries.isEmpty()) {
                throw new AuraHandledException('No pricebook entries found for the provided product IDs in the opportunity currency.');
            }
            
            // Create a map of Product2Id to PricebookEntry for quick lookup
            Map<Id, PricebookEntry> pricebookEntryMap = new Map<Id, PricebookEntry>();
            for (PricebookEntry pbe : pricebookEntries) {
                pricebookEntryMap.put(pbe.Product2Id, pbe);
            }
            
            List<OpportunityLineItem> lineItemsToInsert = new List<OpportunityLineItem>();
            for (ProductWrapper productWrapper : products) {
                PricebookEntry pbe = pricebookEntryMap.get(productWrapper.Id);
                if (pbe != null) {
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli.OpportunityId = opportunityId;
                    oli.PricebookEntryId = pbe.Id;
                    if(productWrapper.quantity!=null){
                        oli.Quantity = productWrapper.quantity;
                    }
                    else{
                        oli.Quantity=1;
                    }
                    // Use the quantity from the wrapper
                    oli.UnitPrice = pbe.UnitPrice;
                    lineItemsToInsert.add(oli);
                }
            }
            
            if (!lineItemsToInsert.isEmpty()) {
                try {
                    insert lineItemsToInsert;
                } catch (DmlException e) {
                    throw new AuraHandledException('Error inserting Opportunity Line Items: ' + e.getMessage());
                }
            }
        }
        catch (Exception e) {
            
            ExceptionHandler.logException('OpportunityProductRecomendationplugin', 'addProductsToOpportunity', e);
            throw new AuraHandledException(e.getMessage());
        }
        // Query the Opportunity to get its Pricebook2Id and CurrencyIsoCode
        
    }
    
    public class ProductWrapper {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public Decimal quantity { get; set; }
        
        // No-arg constructor required by Salesforce
        public ProductWrapper() {}
        
        public ProductWrapper(Id id, Decimal qty) {
            this.Id = id;
            this.quantity = qty;
        }
    }
    
    public static List<Map<String, Object>> getILMRecommendationsIRON(Decimal SingletotalLoad,Decimal doubletotalLoad,Decimal SheetSize,List<Product2> products, String loadField,String heatingType){
        
        Map<String, Id> productMap = new Map<String, Id>();
        list<String> ProductId = new list<String> ();
        for (Product2 product : products) {
            String compoundKey = product.ProductCode + '|' + product.Heating_type__c;
            productMap.put(compoundKey, product.Id);
        }
        List<Map<String, Object>> recommendations = new List<Map<String, Object>>();
        if(SingletotalLoad!=null && doubletotalLoad==null){
            
            if(SheetSize<=1.6 && SingletotalLoad<90){
                String targetCompoundKey = 'IFWI-0416' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            else if((SheetSize<=1.6 && SingletotalLoad>=90 && SingletotalLoad<=180)||(SheetSize>1.6 && SheetSize<=2 && SingletotalLoad<180)){
                String targetCompoundKey = 'IFWI-0420' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            else if((SheetSize>1.6 && SheetSize<=2 && SingletotalLoad>=180 && SingletotalLoad<240)||(SheetSize<=1.6 && SingletotalLoad>180 && SingletotalLoad<240)){
                String targetCompoundKey = 'IFWI-0430' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            else if( SingletotalLoad>=240 && SingletotalLoad<=300){
                String targetCompoundKey = 'IDCI-80033S1R *' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            else if(SingletotalLoad>300 && SingletotalLoad<=600){
                String targetCompoundKey = 'IDCI-80033S2R *' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            else{
                String targetCompoundKey = 'IDCI-80033S2R *' + '|' + heatingType;
                String targetCompoundKey1 = 'IDCI-80033S1R *' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
                ProductId.add(productMap.get(targetCompoundKey1));
                
            }
            
        }
        else if(SingletotalLoad!=null && doubletotalLoad!=null){
            if((doubletotalLoad>=60 && doubletotalLoad <= 80)||(SingletotalLoad>=180 && SingletotalLoad<=240)){
                String targetCompoundKey = 'IFWI-0630' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            if((doubletotalLoad>=60 && doubletotalLoad <= 80)&&(SingletotalLoad>=180 && SingletotalLoad<=240)){
                String targetCompoundKey = 'IFWI-0430' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            if(SingletotalLoad>=100 && SingletotalLoad<=300){
                String targetCompoundKey = 'IDCI-80033S1R *' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            
            if(SingletotalLoad>300 && SingletotalLoad<=600){
                String targetCompoundKey = 'IDCI-80033S2R *' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            else{
                String targetCompoundKey = 'IDCI-80033S2R *' + '|' + heatingType;
                String targetCompoundKey1 = 'IDCI-80033S1R *' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
                ProductId.add(productMap.get(targetCompoundKey1));
                
            }
        }
        else{
            if(doubletotalLoad<=60){
                String targetCompoundKey = 'IFWI-0430' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            if(doubletotalLoad>60 && doubletotalLoad <= 80){
                String targetCompoundKey = 'IFWI-0630' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
            }
            if(doubletotalLoad>80){
                String targetCompoundKey = 'ICI-60022S1R *' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));    
            }
            else{
                String targetCompoundKey = 'IDCI-80033S2R *' + '|' + heatingType;
                String targetCompoundKey1 = 'IDCI-80033S1R *' + '|' + heatingType;
                ProductId.add(productMap.get(targetCompoundKey));
                ProductId.add(productMap.get(targetCompoundKey1));
            }
        }
        
        
        
        
        recommendations=createRecommendation(products,ProductId,1,heatingType);
        return recommendations;
    }
    //Helper method to get ILM product recommendations based on load
    private static List<Map<String, Object>> getILMRecommendations(Decimal totalLoad, List<Product2> products, String loadField,String heatingType) {
        try{
            
            List<Map<String, Object>> recommendations = new List<Map<String, Object>>();
            
            if (totalLoad <= 11 && totalLoad >0) {
                recommendations.add(createRecommendation(products, 11, 1, loadField,heatingType));
            } else if (totalLoad <= 15 && totalLoad >0) {
                recommendations.add(createRecommendation(products, 15, 1, loadField,heatingType));
            } else if (totalLoad <= 30 && totalLoad >0) {
                recommendations.add(createRecommendation(products, 30, 1, loadField,heatingType));
            } else if (totalLoad <= 45 && totalLoad >0) {
                recommendations.add(createRecommendation(products, 30, 1, loadField,heatingType));
                recommendations.add(createRecommendation(products, 45, 1, loadField,heatingType));
            } else if (totalLoad <= 60 && totalLoad >0) {
                recommendations.add(createRecommendation(products, 60, 1, loadField,heatingType));
                recommendations.add(createRecommendation(products, 30, 2, loadField,heatingType));
            } else if (totalLoad <= 90 && totalLoad >0) {
                recommendations.add(createRecommendation(products, 60, 1, loadField,heatingType));
                recommendations.add(createRecommendation(products, 30, 1, loadField,heatingType));
                recommendations.add(createRecommendation(products, 30, 2, loadField,heatingType));
            } else if (totalLoad <= 110 && totalLoad >0) {
                recommendations.add(createRecommendation(products, 110, 1, loadField,heatingType));
                recommendations.add(createRecommendation(products, 60, 2, loadField,heatingType));
            }
            else if (totalLoad <= 130 && totalLoad > 0) {
                recommendations.add(createRecommendation(products,120, 1, loadField,heatingType));
                recommendations.add(createRecommendation(products,60, 2, loadField,heatingType));
            }  
            else if (totalLoad <= 250 && totalLoad >0) {
                recommendations.add(createRecommendation(products, 60, 2, loadField,heatingType));
                recommendations.add(createRecommendation(products, 45, 2, loadField,heatingType));
                recommendations.add(createRecommendation(products, 110, 1, loadField,heatingType));
                recommendations.add(createRecommendation(products, 120, 2, loadField,heatingType));
                recommendations.add(createRecommendation(products, 130, 2, loadField,heatingType));
                recommendations.add(createRecommendation(products,150, 1, loadField,heatingType));
            }
            else if (totalLoad > 250 && totalLoad >0){
                processLargeLoad(recommendations, products, totalLoad, loadField, heatingType);
            }
            
            return recommendations;
        }
        catch (Exception e) {
            
            ExceptionHandler.logException('OpportunityProductRecomendationplugin', 'getILMRecommendations', e);
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    private static void processLargeLoad(List<Map<String, Object>> recommendations, List<Product2> products, Decimal totalLoad, String loadField, String heatingType) {
        try{
            Decimal maxCapacity = [SELECT MasterLabel, Maximum_Capicity__c, Heating_Type__c, Loadtype__c FROM MaximumProductCapicity__mdt WHERE Heating_Type__c = :heatingType AND Loadtype__c = :loadField LIMIT 1].Maximum_Capicity__c;
       
        
        // Calculate 80% of totalLoad and divide by max capacity
        Decimal eightyPercent = Math.ceil(totalLoad * 0.8);
        
        Integer count130 = Math.floor(eightyPercent / maxCapacity).intValue();
       
        
        // Add recommendations for 130s
        addRecommendation(recommendations, products, maxCapacity, count130, loadField, heatingType);
        
        // Calculate remaining load
        Decimal loadCovered =  maxCapacity*count130 ;
        
        totalLoad = totalLoad-loadCovered;
        
        // If there is remaining load, call getILMRecommendations again
        if (totalLoad > 0) {
          
            List<Map<String, Object>> additionalRecommendations = getILMRecommendations(totalLoad, products, loadField, heatingType);
            recommendations.addAll(additionalRecommendations);
        }
        }
         catch (Exception e) {
            
            ExceptionHandler.logException('OpportunityProductRecomendationplugin', 'processLargeLoad', e);
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    private static void addRecommendation(List<Map<String, Object>> recommendations, List<Product2> products, Decimal capacity, Integer quantity, String loadField, String heatingType) {
        
        Map<String, Object> recommendation = createRecommendation(products, capacity, quantity, loadField, heatingType);
       
        recommendations.add(recommendation);
        
    }
    
    //Helper method to create a product recommendation
    private static Map<String, Object> createRecommendation(List<Product2> products, Decimal capacity, Integer quantity, String loadField,String heatingType) {
        try{
            
            for (Product2 product : products) {
                Decimal productCapacity;
                productCapacity = product.Wash_Load_capacity__c;
                if(product.Heating_Type__c==heatingType){
                    if (loadField == ConstantUtilities.PRODUCT_LOAD_FIELDS_WASH_LOAD_CAPACITY) {
                        productCapacity = product.Wash_Load_capacity__c;
                    } else if (loadField == ConstantUtilities.PRODUCT_LOAD_FIELDS_IRON_LOAD_CAPACITY) {
                        productCapacity = product.Iron_Load_capacity__c; 
                    } else if (loadField == ConstantUtilities.PRODUCT_LOAD_FIELDS_DRY_LOAD_CAPACITY) {
                        productCapacity = product.Dry_load_capacity__c;
                    } else {
                        continue;
                    }
                    
                   
                    
                    if (productCapacity == capacity) {
                        
                        Map<String, Object> recommendation = new Map<String, Object>();
                        recommendation.put('product', product);
                        recommendation.put('quantity', quantity);
                        return recommendation;
                    }
                }
            }
            return null;
        }
        catch (Exception e) {
            
            ExceptionHandler.logException('OpportunityProductRecomendationplugin', 'createRecommendation', e);
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    private static list<Map<String, Object>> createRecommendation(List<Product2> products, List<String> Ids, Integer quantity,String heatingType) {
        try {
            List<Map<String, Object>> recommendations = new List<Map<String, Object>>();
            
            for (Product2 product : products) {
                
                
                if (product.Heating_Type__c == heatingType && ids.contains(product.Id)) { 
                    Map<String, Object> recommendation = new Map<String, Object>();
                    recommendation.put('product', product);
                    recommendation.put('quantity', quantity);
                    recommendations.add(recommendation); // Add the matching product to the list
                }
            }
            
            return recommendations; // Return all matches
        } catch (Exception e) {
            ExceptionHandler.logException('OpportunityProductRecomendationplugin', 'createRecommendations', e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    
   @AuraEnabled
    public static void saveblueSheetData(String payload) {
        try{
            Map<String, Object> payloadMap;
            try {
                payloadMap = (Map<String, Object>) JSON.deserializeUntyped(payload);
            } catch (Exception e) {
                throw new AuraHandledException('Error deserializing payload: ' + e.getMessage());
            }
            
            String opportunityId = (String) payloadMap.get('opportunityId');
            if (opportunityId == null) {
                throw new AuraHandledException('Opportunity ID is missing in the payload.');
            }
            
            List<BuyingInfluence> buyingInfluenceList = new List<BuyingInfluence>();
            List<IdealCustomer> idealCustomerList = new List<IdealCustomer>();
            List<Strength> strengthList = new List<Strength>();
            List<RedFlag> redFlagList = new List<RedFlag>();
            
            String buyingInfluenceJson = (String) payloadMap.get('buyingInfluenceList');
            String idealCustomerJson = (String) payloadMap.get('idealCustomerList');
            String strengthJson = (String) payloadMap.get('strengthList');
            String refFlagJson = (String) payloadMap.get('redFlagList');
            
            if (buyingInfluenceJson != null) {
                try {
                    buyingInfluenceList = (List<BuyingInfluence>) JSON.deserialize(buyingInfluenceJson, List<BuyingInfluence>.class);
                } catch (Exception e) {
                    throw new AuraHandledException('Error deserializing buyingInfluenceList: ' + e.getMessage());
                }
            }
            
            if (idealCustomerJson != null) {
                try {
                    idealCustomerList = (List<IdealCustomer>) JSON.deserialize(idealCustomerJson, List<IdealCustomer>.class);
                } catch (Exception e) {
                    throw new AuraHandledException('Error deserializing idealCustomerList: ' + e.getMessage());
                }
            }
            
            if (strengthJson != null) {
                try {
                    strengthList = (List<Strength>) JSON.deserialize(strengthJson, List<Strength>.class);
                } catch (Exception e) {
                    throw new AuraHandledException('Error deserializing idealCustomerList: ' + e.getMessage());
                }
            }
            if (refFlagJson != null) {
                try {
                    redFlagList = (List<RedFlag>) JSON.deserialize(refFlagJson, List<RedFlag>.class);
                } catch (Exception e) {
                    throw new AuraHandledException('Error deserializing idealCustomerList: ' + e.getMessage());
                }
            }
            // Get existing records for the given opportunityId
            Map<String, Blue_Sheet__c> existingRecords = new Map<String, Blue_Sheet__c>();
            
            for (Blue_Sheet__c bs : [
                SELECT Id, OpportunityId__c,Buying_Influences_Involved__c, Evidence_to_support_your_Rating__c, Ideal_Customer_Criteria__c
                FROM Blue_Sheet__c
                WHERE OpportunityId__c = :opportunityId
            ]) {
                existingRecords.put(bs.Id, bs);
            }
            List<Blue_Sheet__c> recordsToUpsert= new List<Blue_Sheet__c>();
            Set<String> idsToDelete = new Set<String>();
            for (BuyingInfluence bi : buyingInfluenceList) {
                if (bi != null) {
                    Blue_Sheet__c newRecord = new Blue_Sheet__c();
                    newRecord.OpportunityId__c = opportunityId;
                    newRecord.Type__c = bi.type;
                    
                    if(bi.buyingInfluences != ''){
                        newRecord.Buying_Influences_Involved__c = bi.buyingInfluences;
                    }
                    newRecord.Role__c = bi.role;
                    newRecord.Degree_Of_Influence__c = bi.degreeOfInfluence;
                    newRecord.Mode__c = bi.mode;
                    newRecord.Buying_Influence_Key_Win_Results__c = bi.winResult;
                    newRecord.Evidence_to_support_your_Rating__c = bi.evidence;
                    newRecord.Rating_5_to_5__c = bi.rating;
                    newRecord.Flag__c = bi.flag;
                    if(existingRecords.containsKey(bi.recId)){
                        newRecord.id = bi.recId;
                        recordsToUpsert.add(newRecord);
                    }else{
                        recordsToUpsert.add(newRecord);
                    }
                }
            }
           
            for (IdealCustomer ic : idealCustomerList) {
                if (ic != null) {
                    Blue_Sheet__c newRecord = new Blue_Sheet__c();
                    newRecord.OpportunityId__c = opportunityId;
                    newRecord.Type__c = ic.type;
                    newRecord.Ideal_Customer_Criteria__c = ic.idealCustomerCriteria;
                    newRecord.Match_to_Criteria_5_to_5__c = ic.matchCriteria;
                    newRecord.Flag__c = ic.flag;
                    if(existingRecords.containsKey(ic.recId)){
                        newRecord.id = ic.recId;
                        recordsToUpsert.add(newRecord);
                    }else{
                        recordsToUpsert.add(newRecord);
                    }
                }
            }
            for (Strength rec : strengthList) {
                if (rec != null) {
                    Blue_Sheet__c newRecord = new Blue_Sheet__c();
                    newRecord.OpportunityId__c = opportunityId;
                    newRecord.Type__c = rec.type;
                    newRecord.Summary_Of_My_Position_Today__c = rec.summryOfMyPosition;
                    newRecord.Possible_Actions__c = rec.possibleActions;
                    newRecord.What__c = rec.what;
                    if(rec.who != ''){
                        newRecord.Who__c = rec.who;
                    }
                    if(rec.whenDate != ''){
                        newRecord.When__c = Date.valueOf(rec.whenDate);
                    }
                    
                    if(existingRecords.containsKey(rec.recId)){
                        newRecord.id = rec.recId;
                        recordsToUpsert.add(newRecord);
                    }else{
                        recordsToUpsert.add(newRecord);
                    }
                }
            }
            for (RedFlag rec : redFlagList) {
                if (rec != null) {
                    Blue_Sheet__c newRecord = new Blue_Sheet__c();
                    newRecord.OpportunityId__c = opportunityId;
                    newRecord.Type__c = rec.type;
                    newRecord.Summary_Of_My_Position_Today__c = rec.summryOfMyPosition;
                    newRecord.Possible_Actions__c = rec.possibleActions;
                    newRecord.Information_Needed__c = rec.informationNeeded;
                    if(rec.fromWhom != ''){
                        newRecord.From_Whom__c = rec.fromWhom;
                    }
                    if(existingRecords.containsKey(rec.recId)){
                        newRecord.id = rec.recId;
                        recordsToUpsert.add(newRecord);
                    }else{
                        recordsToUpsert.add(newRecord);
                    }
                }
            }
            idsToDelete = existingRecords.keySet();
            if(!recordsToUpsert.isEmpty()){
                for(blue_Sheet__C rec : recordsToUpsert){
                    if(existingRecords.containsKey(rec.Id)){
                        idsToDelete.remove(rec.Id);
                    }
                }
            }
            if (!recordsToUpsert.isEmpty()) {
                upsert recordsToUpsert;
            }
            if (!idsToDelete.isEmpty()) {
                delete [SELECT Id FROM Blue_Sheet__c WHERE Id IN :idsToDelete];
            }
            
        }catch(Exception e){
            ExceptionHandler.logException('blueSheetController', 'saveblueSheetData', e);
        }
    }
    
    
    
    
    @AuraEnabled(cacheable=true)
    public static List<BlueSheetData> getBlueSheetData(String opportunityId) {
        List<BlueSheetData> blueSheetDataList = new List<BlueSheetData>();
        try{
            List<Blue_Sheet__c> blueSheets = [
                SELECT Id, OpportunityId__c, Role__c,Buying_Influences_Involved__c,Buying_Influence_Name__c, Degree_Of_Influence__c, Mode__c, Buying_Influence_Key_Win_Results__c, 
                Evidence_to_support_your_Rating__c, Rating_5_to_5__c, Ideal_Customer_Criteria__c, Match_to_Criteria_5_to_5__c,Type__c,Summary_Of_My_Position_Today__c,flag__c,
                Possible_Actions__c, What__c, Who__c, When__c,Information_Needed__c,From_Whom__c, who_Name__c, Whom_Name__c
                FROM Blue_Sheet__c
                WHERE OpportunityId__c = :opportunityId
            ];
            
            
            for (Blue_Sheet__c bs : blueSheets) {
                BlueSheetData data = new BlueSheetData();
                data.Ids = bs.Id;
                data.buyingInfluences = bs.Buying_Influences_Involved__c;
                if(bs.Buying_Influences_Involved__c != null){
                    data.buyingInfluences  = bs.Buying_Influences_Involved__c;
                    data.buyingInfluenceName = bs.Buying_Influence_Name__c;
                    data.selectedValue = true;  
                }
                data.role = bs.Role__c;
                data.degreeOfInfluence = bs.Degree_Of_Influence__c;
                data.mode = bs.Mode__c;
                data.winResult = bs.Buying_Influence_Key_Win_Results__c;
                data.evidence = bs.Evidence_to_support_your_Rating__c;
                data.rating = bs.Rating_5_to_5__c;
                data.idealCustomerCriteria = bs.Ideal_Customer_Criteria__c;
                data.matchCriteria = bs.Match_to_Criteria_5_to_5__c;
                data.type = bs.Type__c;
                data.summryOfMyPosition  = bs.Summary_Of_My_Position_Today__c;
                data.possibleActions  = bs.Possible_Actions__c;
                data.what  = bs.What__c;
                data.flag = bs.flag__c;
                if(bs.Who__c != null){
                    data.who  = bs.Who__c;
                    data.notifyName = bs.who_Name__c;
                    data.selectedValue = true;  
                }
                data.whenDate  = String.valueOf(bs.When__c);
                data.informationNeeded  = bs.Information_Needed__c;
                if(bs.From_Whom__c != null){
                    data.fromWhom  = bs.From_Whom__c;
                    data.notifyName = bs.Whom_Name__c;
                    data.selectedValue = true;  
                }
                blueSheetDataList.add(data);
            }
            
        }catch(Exception e){
            ExceptionHandler.logException('blueSheetController', 'getBlueSheetData', e);
        }
        
        return blueSheetDataList;
    }    
    
    public class BlueSheetData {
        @AuraEnabled public String Ids;
        @AuraEnabled public String buyingInfluences;
        @AuraEnabled public String buyingInfluenceName;
        @AuraEnabled public String role;
        @AuraEnabled public String degreeOfInfluence;
        @AuraEnabled public String mode;
        @AuraEnabled public String winResult;
        @AuraEnabled public String evidence;
        @AuraEnabled public String rating;
        @AuraEnabled public String idealCustomerCriteria;
        @AuraEnabled public String matchCriteria;
        @AuraEnabled public String type;
        @AuraEnabled public String summryOfMyPosition;
        @AuraEnabled public String possibleActions;
        @AuraEnabled public String what;
        @AuraEnabled public String who;
        @AuraEnabled public String whenDate;
        @AuraEnabled public String informationNeeded;
        @AuraEnabled public String fromWhom;
        @AuraEnabled public Boolean selectedValue;
        @AuraEnabled public String notifyName;
        @AuraEnabled public String flag;
        
        
    }
    public class BuyingInfluence {
        public String id;
        public String recId;
        public String type;
        public String buyingInfluences;
        public String role;
        public String degreeOfInfluence;
        public String mode;
        public String winResult;
        public String evidence;
        public String rating;
        public String flag;

    }
    
    
    public class IdealCustomer {
        public String id;
        public String recId;
        public String type;
        public String idealCustomerCriteria;
        public String matchCriteria;
        public String flag;
    }
    public class Strength {
        public String id;
        public String recId;
        public String type;
        public String summryOfMyPosition;
        public String possibleActions;
        public String what;
        public String who;
        public String whenDate;
    }
    public class RedFlag {
        public String id;
        public String recId;
        public String type;
        public String summryOfMyPosition;
        public String possibleActions;
        public String informationNeeded;
        public String fromWhom;
    }
    @auraEnabled 
    public static List<Linen_Mapping__mdt> getCustomMetadata(String vertical, List<String> linens) {
        List<Linen_Mapping__mdt> metadataList = new List<Linen_Mapping__mdt>();
        
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
        return metadataList; 
    }
  	
}