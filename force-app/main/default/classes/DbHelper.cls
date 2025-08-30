public with sharing class DbHelper {

    @AuraEnabled(cacheable=true)
    public static List<cgcloud__Account_Template__c> getCustomerTemplates() {
        return [SELECT Id, Name FROM cgcloud__Account_Template__c WHERE Name LIKE '%RegionSubChannel%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<cgcloud__Product_Template__c> getProductTemplates() {
        return [SELECT Id, Name FROM cgcloud__Product_Template__c WHERE Name='Product' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<cgcloud__Sales_Organization__c> getSalesOrg() {
        return [SELECT Id, Name FROM cgcloud__Sales_Organization__c WHERE Name LIKE '%0001%' LIMIT 1];
    }

	@AuraEnabled(cacheable=true)
    public static List<cgcloud__Visit_Template__c> getVisitTemplates() {
        return [SELECT Id, Name FROM cgcloud__Visit_Template__c WHERE Name='Grocery / Sales' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<cgcloud__Product_Assortment_Template__c> getProductAssortmentTemplates() {
        return [SELECT Id, Name FROM cgcloud__Product_Assortment_Template__c WHERE Name LIKE '%Customer Selling Assortment%' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<cgcloud__Promotion_Template__c> getPromotionTemplates() {
        return [SELECT Id, Name FROM cgcloud__Promotion_Template__c WHERE Name LIKE '%Customer Promotion (Adv.)%' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<cgcloud__Order_Template__c> getOrderTemplates() {
        return [SELECT Id, Name FROM cgcloud__Order_Template__c WHERE Name LIKE '%Special Order%' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<cgcloud__Signature_Template__c> getSignatureTemplates() {
        return [SELECT Id, Name FROM cgcloud__Signature_Template__c WHERE Name='95112' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account WHERE Name LIKE '%NTO Store #201%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name FROM Contact WHERE Name LIKE '%Northern Trail Outfitters%' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProducts() {
        return [SELECT Id, Name FROM Product2 WHERE Name LIKE '%Big Pizza%' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Assortment> getAssortments() {
        return [SELECT Id, Name FROM Assortment WHERE Name LIKE '%NTO Atlanta Listing%' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<RetailStore> getRetailStores() {
        return [SELECT Id, Name FROM RetailStore WHERE Name LIKE '%NTO Store - Bryant Street%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<RetailLocationGroup> getRetailLocationGroups() {
        return [SELECT Id, Name FROM RetailLocationGroup WHERE Name LIKE '%NTO East Bay%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<InStoreLocation> getInStoreLocations() {
        return [SELECT Id, Name FROM InStoreLocation WHERE Name LIKE '%Backroom Storage%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<Promotion> getPromotions() {
        return [SELECT Id, Name FROM Promotion WHERE Name LIKE '%Endcap Display Promotion - Alpine Energy Bars%' LIMIT 1];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Image> getPlanogramImages() {
        return [SELECT Id, Name FROM Image WHERE Name LIKE '%Alpine%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<AssessmentIndicatorDefinition> getAssessmentIndicatorDefinitions() {
        return [SELECT Id, Name FROM AssessmentIndicatorDefinition WHERE Name LIKE '%Inventory Check | Inventory Count%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<RetailStoreKpi> getRetailStoreKpis() {
        return [SELECT Id, Name FROM RetailStoreKpi WHERE Name LIKE '%00000002%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<AssessmentTaskDefinition> getAssessmentTaskDefinitions() {
        return [SELECT Id, Name FROM AssessmentTaskDefinition WHERE Name LIKE '%Inventory Check%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<ActionPlanTemplate> getActionPlanTemplates() {
        return [SELECT Id, Name FROM ActionPlanTemplate WHERE Name LIKE '%Primary Template%' LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<Visit> getVisits() {
        return [SELECT Id, Name FROM Visit WHERE Name LIKE '%00000025%' LIMIT 1];
    }

}