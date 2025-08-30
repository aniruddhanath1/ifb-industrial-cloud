/**
* @File Name : AdobeLeadSync.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : February 6, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | February 6, 2025 |   | Initial Version
**/

public without sharing class AdobeLeadSync {
    
    public class LeadWrapper {
        public String leadId { get; set; }
        public String opportunityId { get; set; }
        public String status { get; set; }
        public String score { get; set; }
        public String rating { get; set; }
        public String followUpDate { get; set; }
        public String requirement { get; set; }
        public String budget { get; set; }
        public String purchaseTimeline { get; set; }
        public String siteSuitability { get; set; }
        public String spaceAvailability { get; set; }
        public DateTime createdAt {get;set;}
        
        public AccountWrapper account { get; set; }
        public CustomerWrapper customer { get; set; }
        
        public AddressWrapper address { get; set; }
        
        public OrganizationWrapper organization { get; set; }
        
        public LeadWrapper() {
            account = new AccountWrapper();
            customer = new CustomerWrapper();
            address = new AddressWrapper();
            organization = new OrganizationWrapper();
        }
    }
    public class AccountWrapper {
        public String source { get; set; }
        public String subSource { get; set; }
        public String productCategory { get; set; }
        public String type { get; set; }
        public String typeOfCustomer { get; set; }
    }
    public class CustomerWrapper {
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String company { get; set; }
        public String phone { get; set; }
        public String landline { get; set; }
        public String altPhone { get; set; }
        public String email { get; set; }
        public String decisionMaker { get; set; }
        public String department { get; set; }
        public String designation { get; set; }
    }
    public class AddressWrapper {
        public BillingWrapper billing = new BillingWrapper();
        public ShippingWrapper shipping = new ShippingWrapper();
    }
    public class BillingWrapper {
        public String city { get; set; }
        public String country { get; set; }
        public String postalCode { get; set; }
        public String state { get; set; }
        public String street { get; set; }
        
    }
    public class ShippingWrapper {
        public String city = '' ;
        public String country  = '' ;
        public String postalCode = '';
        public String state  = '';
        public String street = '';
    }
    public class OrganizationWrapper {
        public String name { get; set; }
        public String sector { get; set; }
        public String segment { get; set; }
        public String subSegment { get; set; }
        public String otherBusiness { get; set; }
        public String otherLocations { get; set; }
        public String regionName { get; set; }
        public String typeOfSetup { get; set; }
        public Decimal annualRevenue { get; set; }
        public String website { get; set; }
    }
    public static List<LeadWrapper> getLeadData(List<Lead> queriedLeads) {
        
        List<LeadWrapper> leadWrapperList = new list<LeadWrapper>();
        
        for(Lead queriedLead :queriedLeads ){
            
            LeadWrapper leadWrapper = new LeadWrapper();
            
            leadWrapper.leadId = queriedLead.Id;
            leadWrapper.opportunityId = ' ';
            leadWrapper.status = queriedLead.Status;
            leadWrapper.score = String.valueOf(queriedLead.Lead_Score__c);
            leadWrapper.rating = queriedLead.Rating;
            if(queriedLead.Next_Follow_up_Date_Time__c!=null){
                leadWrapper.followUpDate = (queriedLead.Next_Follow_up_Date_Time__c).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss');
            }else{
                leadWrapper.followUpDate='';
            }
            leadWrapper.requirement = queriedLead.Requirement__c;
            leadWrapper.budget = ' ';
            leadWrapper.purchaseTimeline = queriedLead.Purchase_Timeline__c;
            leadWrapper.siteSuitability = queriedLead.Site_Suitability__c;
            leadWrapper.spaceAvailability = queriedLead.Space_Availability__c;
            leadWrapper.createdAt = queriedLead.CreatedDate;
            
            leadWrapper.account.source = queriedLead.LeadSource;
            leadWrapper.account.subSource = queriedLead.Lead_Sub_Source__c;
            leadWrapper.account.productCategory = queriedLead.Product_Category__c;
            leadWrapper.account.type = queriedLead.Type__c;
            leadWrapper.account.typeOfCustomer = queriedLead.Type_of_Customer__c;
            
            leadWrapper.customer.firstName = queriedLead.FirstName;
            leadWrapper.customer.lastName = queriedLead.LastName;
            leadWrapper.customer.company = queriedLead.Company;
            leadWrapper.customer.phone = queriedLead.Phone;
            leadWrapper.customer.landline = queriedLead.phone;
            leadWrapper.customer.altPhone = queriedLead.Alternative_Phone_Number__c;
            leadWrapper.customer.email = queriedLead.Email;
            leadWrapper.customer.decisionMaker = queriedLead.Is_our_contact_a_Key_Decision_Maker__c;
            leadWrapper.customer.department = queriedLead.Customer_Department__c;
            leadWrapper.customer.designation = queriedLead.Customer_Designation__c;
            
            
            leadWrapper.address.billing.city = queriedLead.Shipping__City__s;
            leadWrapper.address.billing.country = queriedLead.Shipping__CountryCode__s;
            leadWrapper.address.billing.postalCode = queriedLead.Shipping__PostalCode__s;
            leadWrapper.address.billing.state = queriedLead.Shipping__StateCode__s;
            leadWrapper.address.billing.street = queriedLead.Shipping__Street__s;
            
            leadWrapper.address.shipping.city = queriedLead.City;
            leadWrapper.address.shipping.country = queriedLead.Country;
            leadWrapper.address.shipping.postalCode = queriedLead.PostalCode;
            leadWrapper.address.shipping.state = queriedLead.State;
            leadWrapper.address.shipping.street = queriedLead.Street;
            
            leadWrapper.organization.name = queriedLead.Company;
            leadWrapper.organization.sector = queriedLead.Sector__c;
            leadWrapper.organization.segment = queriedLead.Customer_Segment_Vertical__c;
            leadWrapper.organization.subSegment = queriedLead.Customer_Sub_segment_Sub_Vertical__c;
            leadWrapper.organization.otherBusiness = queriedLead.Other_Business__c;
            leadWrapper.organization.otherLocations = queriedLead.Other_Locations__c;
            leadWrapper.organization.regionName = queriedLead.Region_Name__c;
            leadWrapper.organization.typeOfSetup = queriedLead.Type_of_Setup__c;
            leadWrapper.organization.annualRevenue = queriedLead.AnnualRevenue;
            leadWrapper.organization.website = queriedLead.Website;
            
            leadWrapperList.add(leadWrapper);
            
        }
        System.debug(JSON.serialize(leadWrapperList));
        return leadWrapperList;
    }
    public static List<LeadWrapper> getOppData(List<Opportunity> queriedOpportunities) {
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        Set<Id> accIDs = new Set<Id>();
        for(Opportunity opp:queriedOpportunities){
            accIDs.add(opp.AccountId);
        }
        List<Contact> conList = [SELECT Id,AccountId, FirstName, LastName,Email, Phone ,Alternative_Phone_Number__c,Key_Decision_Maker__c,Customer_Department__c,Customer_Designation__c FROM Contact WHERE AccountId IN:accIds AND Primary_Contact__c=True LIMIT 1];
        for(Contact con:conList){
            conMap.put(con.AccountId,con);
        }
        List<LeadWrapper> leadWrapperList = new list<LeadWrapper>();
        
        for(Opportunity queriedOpportunity :queriedOpportunities ){
            if(conMap.containsKey(queriedOpportunity.AccountId)){
                LeadWrapper leadWrapper = new LeadWrapper();
                leadWrapper.leadId = queriedOpportunity.LeadIDText__c;
                leadWrapper.opportunityId = queriedOpportunity.Id;
                leadWrapper.status = queriedOpportunity.StageName;
                leadWrapper.score = String.valueOf(queriedOpportunity.Lead_Score__c);
                leadWrapper.rating = queriedOpportunity.Rating__c;
                if(queriedOpportunity.Next_Follow_up_Date_Time__c!=null){
                    leadWrapper.followUpDate = (queriedOpportunity.Next_Follow_up_Date_Time__c).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss');
                }else{
                    leadWrapper.followUpDate='';
                }
                leadWrapper.requirement ='' ;
                leadWrapper.budget = ' ';
                leadWrapper.purchaseTimeline = queriedOpportunity.Purchase_Timeline__c;
                leadWrapper.siteSuitability = queriedOpportunity.Site__c;
                leadWrapper.spaceAvailability = queriedOpportunity.Space_Availability__c;
                leadWrapper.createdAt = queriedOpportunity.CreatedDate;
                
                
                leadWrapper.account.source = queriedOpportunity.LeadSource;
                leadWrapper.account.subSource = '' ;
                leadWrapper.account.productCategory = queriedOpportunity.Product_Category__c;
                leadWrapper.account.type = queriedOpportunity.Type;
                leadWrapper.account.typeOfCustomer = queriedOpportunity.Type_of_Customer__c;
                
                leadWrapper.customer.firstName = conMap.get(queriedOpportunity.AccountId).FirstName;
                leadWrapper.customer.lastName = conMap.get(queriedOpportunity.AccountId).LastName;
                leadWrapper.customer.company = queriedOpportunity.Account.Name;
                leadWrapper.customer.phone = conMap.get(queriedOpportunity.AccountId).Phone;
                leadWrapper.customer.landline = conMap.get(queriedOpportunity.AccountId).phone;
                leadWrapper.customer.altPhone = conMap.get(queriedOpportunity.AccountId).Alternative_Phone_Number__c;
                leadWrapper.customer.email = conMap.get(queriedOpportunity.AccountId).Email;
                leadWrapper.customer.decisionMaker = conMap.get(queriedOpportunity.AccountId).Key_Decision_Maker__c;
                leadWrapper.customer.department = conMap.get(queriedOpportunity.AccountId).Customer_Department__c;
                leadWrapper.customer.designation = conMap.get(queriedOpportunity.AccountId).Customer_Designation__c;
                
                
                leadWrapper.address.billing.city = queriedOpportunity.Account.ShippingCity;
                leadWrapper.address.billing.country = queriedOpportunity.Account.ShippingCountry;
                leadWrapper.address.billing.postalCode = queriedOpportunity.Account.ShippingPostalCode;
                leadWrapper.address.billing.state = queriedOpportunity.Account.ShippingState;
                leadWrapper.address.billing.street = queriedOpportunity.Account.ShippingStreet;
                
                leadWrapper.address.shipping.city = queriedOpportunity.Account.BillingCity;
                leadWrapper.address.shipping.country = queriedOpportunity.Account.BillingCountry;
                leadWrapper.address.shipping.postalCode = queriedOpportunity.Account.BillingPostalCode;
                leadWrapper.address.shipping.state = queriedOpportunity.Account.BillingState;
                leadWrapper.address.shipping.street = queriedOpportunity.Account.BillingStreet;
                
                leadWrapper.organization.name = queriedOpportunity.Account.Name;
                leadWrapper.organization.sector = queriedOpportunity.Account.Sector__c;
                leadWrapper.organization.segment = queriedOpportunity.Account.Customer_Segment__c;
                leadWrapper.organization.subSegment = queriedOpportunity.Account.Customer_Sub_segment__c;
                leadWrapper.organization.otherBusiness = queriedOpportunity.Account.Other_Business__c;
                leadWrapper.organization.otherLocations = '';
                leadWrapper.organization.regionName = '';
                leadWrapper.organization.typeOfSetup = queriedOpportunity.Type_of_Setup__c;
                leadWrapper.organization.annualRevenue = queriedOpportunity.Account.AnnualRevenue;
                leadWrapper.organization.website = queriedOpportunity.Account.Website;
                
                leadWrapperList.add(leadWrapper);
            }
        }
        System.debug(JSON.serializePretty(leadWrapperList));
        return leadWrapperList;
    }
}