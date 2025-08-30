public class MyQuoteController {
    public String quoteId { get; set; }
    public SBQQ__Quote__c quote { get; set; }
    public String templateId {get; set;}
    public String currencyName {get; set;}
    public String headerImage {get; set;}
    public String ShippingName {get; set;}
    public String ShippingStreet {get; set;}
    public String BillingName {get; set;}
    public String BillingStreet {get; set;}
    Public String AccountName {get; set;}
    Public String ARANo {get; set;}
    public List<SBQQ__QuoteLine__c> quoteLineItems { get; set; }
    public Boolean isBillToAndShipToSame { get; set; }
    public Boolean isExportQuote { get; set; }
    public Boolean isRateContractQuote { get; set;}
    public Boolean isBOQQuote { get; set;}
    public Boolean isDiscountMax { get; set; }
    public Boolean isDiscountPresent { get; set; }
    public Boolean isEssentialLineItemPresent { get; set; }
    public Integer splitValue1 { get; set; }
    public Integer splitValue2 { get; set; }
    public Integer splitValue3 { get; set; }
    public Integer paymentTerm  { get; set; }
    public Integer splitRatioListSize { get; set; }
    public Boolean isSplitPaymentSize { get; set; }
    public Boolean isFullPayment { get; set; }
    public Boolean isSplitPayment { get; set; }
    public List<LineItemWrapper> lineItemList { get; set; }
    public class LineItemWrapper {
        public String Name { get; set; }
        public String ProductCode { get; set; }
        public Decimal Price { get; set; }
        public String ImageLink { get; set; }
        public String MakeName { get; set; }
        public Decimal NetTotal { get; set; }
        public String HSNCode { get; set; }
        public String MaterialCode { get; set; }
        public Decimal Gst { get; set; }
        public Decimal PackageTotal { get; set; }
        public Decimal Discount { get; set; }
        public Decimal Quantity { get; set; }
        public String ProductOption { get; set; }
        public Decimal listPrice { get;set; }
        public Boolean isEssentialLineItem { get;set; }
    }

    public MyQuoteController() {
        try{
            quoteId = ApexPages.currentPage().getParameters().get('qId');
            templateId = ApexPages.currentPage().getParameters().get('tid');
            isExportQuote = false;
            isBOQQuote = false;
            isDiscountMax = false;
            quote = [SELECT Id, Name, SBQQ__ExpirationDate__c, SBQQ__Account__r.ARA_No__c,Created_Date__c,Product_category__c, SBQQ__Account__r.Name, Maximum_Discount__c,
                SBQQ__PrimaryContact__r.Name, SBQQ__PrimaryContact__r.Phone,SBQQ__PrimaryContact__r.Salutation,SBQQ__PrimaryContact__r.Email,SBQQ__PrimaryContact__r.Fax,
                SBQQ__ShippingName__c, SBQQ__ShippingStreet__c, SBQQ__ShippingCity__c, SBQQ__ShippingState__c, SBQQ__ShippingPostalCode__c, SBQQ__ShippingCountry__c,
                SBQQ__BillingName__c, SBQQ__BillingStreet__c, SBQQ__BillingCity__c, SBQQ__BillingState__c, SBQQ__BillingCountry__c, SBQQ__BillingPostalCode__c,IFB_GST_No__c,
                CurrencyIsoCode,Freight_Terms__c,Payment_Term__c,WarrantyTerm_In_Year__c,Expected_Delivery_Period__c ,
                Owner.Name, Owner.Email,SBQQ__NetAmount__c,Total_Amount_Including_GST__c,SBQQ__AverageCustomerDiscount__c,Bank_Address__c,Total_GST_Amount__c,
                RecordType.DeveloperName,Owner.Profile.Name,Owner.Phone, Bank_State__c, Bank_Name__c, Bank_Account_Name__c, Bank_Account_Number__c,
                Bank_IFSC_Code__c, Payment_Split_ratio__c,Fright_Charges__c
                FROM SBQQ__Quote__c
                WHERE Id = :quoteId LIMIT 1];

            quoteLineItems = [SELECT Id, SBQQ__Product__c, SBQQ__Product__r.Family, SBQQ__Product__r.RecordTypeId, SBQQ__Product__r.RecordType.Name,
            SBQQ__Product__r.Name, SBQQ__ListTotal__c, SBQQ__ProductOption__c, SBQQ__ProductCode__c, SBQQ__UnitCost__c, SBQQ__Quantity__c,
            SBQQ__ListPrice__c, SBQQ__RegularTotal__c, Image_Link__c, SBQQ__ProductName__c, SBQQ__SpecialPrice__c, SBQQ__Discount__c,
            SBQQ__TotalDiscountRate__c, SBQQ__Product__r.MakeName, SBQQ__Product__r.ModelName, SBQQ__NetTotal__c,
            SBQQ__Product__r.ProductCode, SBQQ__Product__r.Wash_Load_capacity__c, SBQQ__NetPrice__c, SBQQ__Product__r.HSN_Code__c,
            Custom_Discount__c, SBQQ__Product__r.Material_Code__c, Gst__c, SBQQ__PackageTotal__c, SBQQ__AdditionalDiscount__c, SBQQ__Number__c
            FROM SBQQ__QuoteLine__c
            WHERE SBQQ__Quote__c = :quoteId
            ORDER BY SBQQ__Number__c];

            AccountName = escapeHtml(quote.SBQQ__Account__r.Name);
            ShippingStreet = escapeHtml(quote.SBQQ__ShippingStreet__c);
            ShippingName = escapeHtml(quote.SBQQ__ShippingName__c);
            BillingStreet = (String.isNotEmpty(quote.SBQQ__BillingStreet__c) && String.isNotBlank(quote.SBQQ__BillingStreet__c)) ? escapeHtml(quote.SBQQ__BillingStreet__c) : '';
            BillingName = (String.isNotEmpty(quote.SBQQ__BillingName__c) && String.isNotBlank(quote.SBQQ__BillingName__c)) ? escapeHtml(quote.SBQQ__BillingName__c) : '';
            if (BillingName.equalsIgnoreCase(ShippingName) &&
                    BillingStreet.equalsIgnoreCase(ShippingStreet) &&
                    quote.SBQQ__BillingCity__c.equalsIgnoreCase(quote.SBQQ__ShippingCity__c) &&
                    quote.SBQQ__BillingState__c.equalsIgnoreCase(quote.SBQQ__ShippingState__c) &&
                    quote.SBQQ__BillingPostalCode__c.equalsIgnoreCase(quote.SBQQ__ShippingPostalCode__c) &&
                    quote.SBQQ__BillingCountry__c.equalsIgnoreCase(quote.SBQQ__ShippingCountry__c)) {

                isBillToAndShipToSame = true;
            }
            else {
                isBillToAndShipToSame = false;
            }
            currencyName = quote.CurrencyIsoCode;
            paymentTerm = (Integer)quote.Payment_Term__c;
            isFullPayment = quote.Payment_Term__c != null && quote.Payment_Term__c == 100.00;
            isSplitPayment = quote.Payment_Term__c != null && quote.Payment_Term__c != 100.00 ;
            lineItemList = new List<LineItemWrapper>();
            ARANo = quote.SBQQ__Account__r.ARA_No__c;
            for(SBQQ__QuoteLine__c LineItems:quoteLineItems){
                LineItemWrapper lineItem = new LineItemWrapper();
                lineItem.Name = escapeHtml(LineItems.SBQQ__ProductName__c);
                lineItem.ProductCode = escapeHtml(LineItems.SBQQ__Product__r.ProductCode);
                lineItem.ImageLink = LineItems.Image_Link__c;
                lineItem.MakeName = LineItems.SBQQ__Product__r.MakeName;
                lineItem.NetTotal = LineItems.SBQQ__SpecialPrice__c;
                lineItem.HSNCode = LineItems.SBQQ__Product__r.HSN_Code__c;
                lineItem.MaterialCode = LineItems.SBQQ__Product__r.Material_Code__c;
                lineItem.Gst = LineItems.Gst__c;
                lineItem.Quantity = LineItems.SBQQ__Quantity__c;
                lineItem.PackageTotal = lineItems.SBQQ__PackageTotal__c;
                lineItem.listPrice = lineItems.SBQQ__ListTotal__c;
                lineItem.Discount = LineItems.Custom_Discount__c;
                lineItem.ProductOption = (lineItems.SBQQ__ProductOption__c != null ? lineItems.SBQQ__ProductOption__c :null);
                lineItem.isEssentialLineItem = LineItems.SBQQ__Product__r.RecordType.Name?.indexOf('Essentials') >= 0;

                lineItemList.add(lineItem);
            }
            if(quote.RecordType.DeveloperName == 'Exports'){
                isExportQuote = true;
            }
            else if(quote.RecordType.DeveloperName == 'BOQ_specified'){
                isBOQQuote = true;
            }
            else if(quote.RecordType.DeveloperName == 'Rate_Contract'){
                isRateContractQuote = true;
            }


            if(quote.Maximum_Discount__c > 20){
                isDiscountMax = true;
            }
            if(quote.Maximum_Discount__c > 0){
                isDiscountPresent = true;
            }

            for (SBQQ__QuoteLine__c quoteLineItem: quoteLineItems) {
                if (quoteLineItem.SBQQ__TotalDiscountRate__c < 0 && quoteLineItem.SBQQ__Discount__c > 0) {
                    isDiscountPresent = true;
                    break;
                }
            }

            for (SBQQ__QuoteLine__c quoteLineItem: quoteLineItems) {
                if (quoteLineItem.SBQQ__Product__r.RecordType.Name?.indexOf('Essentials') >= 0) {
                    isEssentialLineItemPresent = true;
                    break;
                }
            }
            if(quote.Payment_Split_ratio__c != ''){
                List<String> splitRatioList = quote.Payment_Split_ratio__c.split(':');
                splitRatioListSize=splitRatioList.size();
                if(splitRatioList.size() == 3){
                    isSplitPaymentSize=true;
                    splitValue1 = Integer.valueOf(splitRatioList[0]);
                    splitValue2 = Integer.valueOf(splitRatioList[1]);
                    splitValue3 = Integer.valueOf(splitRatioList[2]);
                }
                else if(splitRatioList.size() == 2){
                    splitValue1 = Integer.valueOf(splitRatioList[0]);
                    splitValue2 = Integer.valueOf(splitRatioList[1]);
                }
                else{
                    splitValue1 = Integer.valueOf(splitRatioList[0]);
                }
            }
            this.getDetails();
        }
        catch(Exception e){
            ExceptionHandler.logException('MyquoteController', 'MyQuoteController', e);
        }
    }
    public void getDetails(){
        List <Document> docsList =  [SELECT Name,Id FROM Document WHERE Name LIKE 'HeaderImage%'];
        Id OrgId = UserInfo.getOrganizationId();
        String orgURL = System.URL.getOrgDomainUrl().toExternalForm();

        if (!docsList.isEmpty()) {
            for(Document img: docsList){
                if(img.Name == 'headerImage'){
                    headerImage = orgURL.replace('my.salesforce.com', 'file.force.com/servlet/servlet.ImageServer?') + 'id=' + img.Id + '&oid=' + OrgId;
                }
            }
        }
    }
    public static String escapeHtml(String input) {
        if (input == null) {
            return null;
        }
        input = input.replace('&', '&amp;');
        input = input.replace('<', '&lt;');
        input = input.replace('>', '&gt;');
        input = input.replace('"', '&quot;');
        input = input.replace('\'','&#39;');
        return input;
    }


}