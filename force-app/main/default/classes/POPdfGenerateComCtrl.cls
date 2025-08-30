public class POPdfGenerateComCtrl {
    public String typeOfPDF { get; set; }
    public String recordId { get; set; }
    public WrapperOrderDetails orderObject { get; set; }
    public WrapperOfAccountDetails accountDetails { get; set; }
    public List<wrapperOrderLineItems> orderLineItemList { get; set; }

    // Constructor for initialization
    public POPdfGenerateComCtrl() {
        this.recordId = ApexPages.currentPage().getParameters().get('id');
        this.typeOfPDF = ApexPages.currentPage().getParameters().get('typeofpdf');
        this.orderObject = new WrapperOrderDetails();
        this.accountDetails = new WrapperOfAccountDetails();
        this.orderLineItemList = new List<wrapperOrderLineItems>();

        try {
            // Fetching Order Record
            Order orderObj = [SELECT Id,Name,TotalAmount, GST_No__c, Account.Name, Account.Bill_To_Name__c, Account.BillingAddress, Account.Phone, Account.cgcloud__Account_Email__c,
            PoNumber,Delivery_Terms__c, Warranty_Term_In_Year__c, Advance_Amount_p__c, Product_Category__c, Freight_Terms__c,Fright_Charges__c,Freight_Included__c,
            Account.Ship_to_Name__c, Account.ShippingAddress, Account.cgcloud__Account_Number__c, Account.GST_Number__c ,SBQQ__Quote__r.Bank_Detail__r.Address__c,SBQQ__Quote__r.Bank_Detail__r.GST__c,Payment_Terms__c,
            Total_GST_Amount__c,Total_Amount_Including_GST__c,OrderNumber FROM Order
            WHERE Id =: recordId
            LIMIT 1];

            // Null checks for Order Object fields
            orderObject.totalAmount = orderObj.TotalAmount != null ? orderObj.TotalAmount : 0;
            orderObject.GSTNo = orderObj.GST_No__c != null ? orderObj.GST_No__c : '';
            orderObject.FreightTerm = orderObj.Freight_Terms__c != null ? orderObj.Freight_Terms__c: '';
            orderObject.productCategory = orderObj.Product_Category__c != null ? orderObj.Product_Category__c : '';
            orderObject.deliverTerms = orderObj.Delivery_Terms__c != null ? orderObj.Delivery_Terms__c : '';
            orderObject.warntyTerms = orderObj.Warranty_Term_In_Year__c != null ? orderObj.Warranty_Term_In_Year__c : 0;
            orderObject.advanceAmount = orderObj.Payment_Terms__c != null ? orderObj.Payment_Terms__c : 0;
            orderObject.currentDate = DateTime.now().format('MM/dd/yyyy');
            orderObject.PoNumber = orderObj.Name != null ? orderObj.Name : '';
            orderObject.totalGstAmount = orderObj.Total_GST_Amount__c !=null ? orderObj.Total_GST_Amount__c : 0;
            orderObject.totalAmountInclGst = orderObj.Total_Amount_Including_GST__c !=null ? orderObj.Total_Amount_Including_GST__c : 0;
            orderObject.OrderNumber = orderObj.OrderNumber !=null ? orderObj.OrderNumber : '';
            orderObject.FrightCharges = orderObj.Fright_Charges__C !=null ? orderObj.Fright_Charges__C : 0;
            orderObject.FreightIncluded = orderObj.Freight_Included__c !=null ? orderObj.Freight_Included__c : '';

            // Null checks for Account Details fields
            accountDetails.nameOfConsignor = orderObj.Account.Bill_To_Name__c != null ? orderObj.Account.Bill_To_Name__c : '';
            accountDetails.nameOfConsignee = orderObj.Account.Ship_to_Name__c != null ? orderObj.Account.Ship_to_Name__c : '';
            accountDetails.Address = orderObj.SBQQ__Quote__r.Bank_Detail__r.Address__c  != null ? orderObj.SBQQ__Quote__r.Bank_Detail__r.Address__c : '' ;
            accountDetails.GST = orderObj.SBQQ__Quote__r.Bank_Detail__r.GST__c != null ? orderObj.SBQQ__Quote__r.Bank_Detail__r.GST__c : '';
            accountDetails.BillingStreet = orderObj.Account.BillingAddress != null ? orderObj.Account.BillingAddress.getStreet() : '';
            accountDetails.BillingCity = orderObj.Account.BillingAddress != null ? orderObj.Account.BillingAddress.getCity() : '';
            accountDetails.BillingState = orderObj.Account.BillingAddress != null ? orderObj.Account.BillingAddress.getState() : '';
            accountDetails.BillingPostalCode = orderObj.Account.BillingAddress != null ? orderObj.Account.BillingAddress.getPostalCode() : '';
            accountDetails.phoneNo = orderObj.Account.Phone != null ? orderObj.Account.Phone : '';
            accountDetails.email = orderObj.Account.cgcloud__Account_Email__c != null ? orderObj.Account.cgcloud__Account_Email__c : '';
            accountDetails.PostalCode = orderObj.Account.ShippingAddress != null ? orderObj.Account.ShippingAddress.getPostalCode() : '';
            accountDetails.City = orderObj.Account.ShippingAddress != null ? orderObj.Account.ShippingAddress.getCity() : '';
            accountDetails.Street = orderObj.Account.ShippingAddress != null ? orderObj.Account.ShippingAddress.getStreet() : '';
            accountDetails.gstiNUIN = orderObj.Account.GST_Number__c != null ? orderObj.Account.GST_Number__c : '';

            // Fetching related Order Items with null checks
            Integer count = 1;
            for (OrderItem orderLineItemObj : [SELECT Id, Material_Code__c, Product2.Name, Product2.MakeName, Product2.ProductCode,
            Product2.Capacity__c, Product2.Heating_type__c, UnitPrice, Quantity, TotalPrice,
            GST__c
            FROM OrderItem
            WHERE OrderId =: recordId]) {

                wrapperOrderLineItems orderProduct = new wrapperOrderLineItems();
                orderProduct.srNo = count;
                orderProduct.materialCode = orderLineItemObj.Material_Code__c != null ? orderLineItemObj.Material_Code__c : '';
                orderProduct.productName = orderLineItemObj.Product2.Name != null ? orderLineItemObj.Product2.Name : '';
                orderProduct.makeName = orderLineItemObj.Product2.MakeName != null ? orderLineItemObj.Product2.MakeName : '';
                orderProduct.modelName = orderLineItemObj.Product2.ProductCode != null ? orderLineItemObj.Product2.ProductCode : '';
                orderProduct.heatingType = orderLineItemObj.Product2.Heating_type__c != null ? orderLineItemObj.Product2.Heating_type__c : '';
                orderProduct.unitPrice = orderLineItemObj.UnitPrice != null ? orderLineItemObj.UnitPrice : 0;
                orderProduct.quantity = orderLineItemObj.Quantity != null ? orderLineItemObj.Quantity : 0;
                orderProduct.totalPrice = orderLineItemObj.TotalPrice != null ? orderLineItemObj.TotalPrice : 0;
                orderProduct.gst = orderLineItemObj.GST__c != null ? orderLineItemObj.GST__c : 0;

                orderLineItemList.add(orderProduct);
                count++;
            }
        } catch (Exception e) {
        }
    }

    // Wrapper classes
    public class WrapperOrderDetails {
        public Decimal totalAmount { get; set; }
        public Decimal totalGstAmount { get; set; }
        public Decimal totalAmountInclGst { get; set; }
        public String GSTNo { get; set; }
        public String productCategory { get; set; }
        public String deliverTerms { get; set; }
        public Decimal warntyTerms { get; set; }
        public Decimal advanceAmount { get; set; }
        public String currentDate { get; set; }
        public String PoNumber { get; set; }
        public String FreightTerm {get; set;}
        public String OrderNumber {get; set;}

        public Decimal FrightCharges {get; set;}
        public String FreightIncluded {get; set;}
    }

    public class WrapperOfAccountDetails {
        public String nameOfConsignor { get; set; }
        public String nameOfConsignee { get; set; }
        public String billingAddress { get; set; }
        public String phoneNo { get; set; }
        public String mobileNo { get; set; }
        public String billingEmail { get; set; }
        public String stateNameCode { get; set; }
        public String panNo { get; set; }
        public String gstiNUIN { get; set; }
        public String shipTo { get; set; }
        public String name { get; set; }
        public String BillingStreet { get; set; }
        public String BillingCity { get; set; }
        public String BillingPostalCode { get; set; }
        public String BillingState { get; set; }
        public String BillingCountry { get; set; }
        public String shippingAddress { get; set; }
        public String ShipingPhoneNo { get; set; }
        public String shipingMobileNo { get; set; }
        public String email { get; set; }
        public String Street { get; set; }
        public String City { get; set; }
        public String PostalCode { get; set; }
        public String Address {get; set;}
        public String GST {get; set;}
    }

    public class wrapperOrderLineItems {
        public String materialCode { get; set; }
        public String productName { get; set; }
        public String makeName { get; set; }
        public String modelName { get; set; }
        public Decimal capacity { get; set; }
        public String heatingType { get; set; }
        public Decimal unitPrice { get; set; }
        public Decimal quantity { get; set; }
        public Decimal totalPrice { get; set; }
        public Decimal gst { get; set; }
        public Integer srNo { get; set; }
    }
}