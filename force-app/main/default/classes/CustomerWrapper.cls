public class CustomerWrapper {
    @AuraEnabled
    public String customerID { get; set; }
    
    @AuraEnabled
    public String customerName { get; set; }
    
    @AuraEnabled
    public List<MachineDetail> machine_details { get; set; }
    
    @AuraEnabled
    public List<InstallationDetail> installation_details { get; set; }
    
    @AuraEnabled
    public List<WarrantyDetail> warranty_details { get; set; }
    
    @AuraEnabled
    public List<Essential> essentials { get; set; }
    
    @AuraEnabled
    public List<Complaint> complaints { get; set; }

    public class MachineDetail {
        @AuraEnabled
        public String serialNo { get; set; }
        @AuraEnabled
        public String productCode { get; set; }
        @AuraEnabled
        public String fgCode { get; set; }
        @AuraEnabled
        public String modelDescription { get; set; }
        @AuraEnabled
        public String purchaseDate { get; set; }
    }

    public class InstallationDetail {
        @AuraEnabled
        public String serialNo { get; set; }
        @AuraEnabled
        public String installation_location { get; set; }
        @AuraEnabled
        public String pincode { get; set; }
        @AuraEnabled
        public String service_Engineer { get; set; }
        @AuraEnabled
        public String dateofInstallation { get; set; }
    }

    public class WarrantyDetail {
        @AuraEnabled
        public String serialNo { get; set; }
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public String warrantyType { get; set; }
        @AuraEnabled
        public String warrantyStartDate { get; set; }
        @AuraEnabled
        public String warrantyEndDate { get; set; }
    }

    public class Essential {
        @AuraEnabled
        public String dateofPurchase { get; set; }
        @AuraEnabled
        public String material { get; set; }
        @AuraEnabled
        public String materialDescription { get; set; }
        @AuraEnabled
        public Integer quantity { get; set; }
        @AuraEnabled
        public String price { get; set; }
        @AuraEnabled
        public String soldtoParty { get; set; }
        @AuraEnabled
        public String soldtoPartName { get; set; }
        @AuraEnabled
        public String shiptoParty { get; set; }
        @AuraEnabled
        public String shiptoPartyName { get; set; }
    }

    public class Complaint {
        @AuraEnabled
        public String serialNo { get; set; }
        @AuraEnabled
        public String callType { get; set; }
        @AuraEnabled
        public String periodOfComplaint { get; set; }
        @AuraEnabled
        public String dateOfComplaint { get; set; }
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public EngineerDetails engineerDetails { get; set; }
    }

    public class EngineerDetails {
        @AuraEnabled
        public String technicianCode { get; set; }
        @AuraEnabled
        public String technicianName { get; set; }
        @AuraEnabled
        public String contactNo { get; set; }
    }
}