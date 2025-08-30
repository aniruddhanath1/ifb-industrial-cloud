/*
@Author : Yadam
@CreatedDate : 13th June 2024
@Description : This class use by ILMPDFGenerateComponenst.
*/

public class InvoicePDFGenerateController {
    public String recordId;
    public String typeOfPDF{get;set;}
    public String ifb_Tax_Invoice {get;set;}
    public String ifb_Delivery_Challan{get;set;}
    public String idwBranch_Name_Of_Consignor{get;set;}
    public String ifb_Industries_Limited {get;set;}
    public String iDw_Branch_Name_Of_Consignor_Address {get;set;}
    public String iDw_Hub_Name_Name_Of_Consignor_Address {get;set;}
    public string iLM_Consignor_Address{get;set;} 
    public String iDw_Branch_gStin {get;set;}
    public String iDw_Hub_gStin {get;set;}
    public String iLM_PAN_GSTIN {get;set;}
    public String iFb_Address {get;set;}
    public String iFb_Phone {get;set;}
    public String iFb_Fax {get;set;}
    public String iFb_Websit_Email {get;set;}
    public String iFb_Pan_No {get;set;}
    public String iFb_Cin {get;set;}
    public String iFb_IdwBranch_StateName_Code {get;set;}
    public String iFb_IdwHub_StateName_Code {get;set;}
    public String iFB_IlmPdf_StateName_Code {get;set;}
    public String iFB {get;set;}
    public String pLace_Of_Supply {get;set;}

    public wrapperOfInvoideDetailColumn wrapperObj{get;set;}
    public wrapperOfAccountDetails wrapperObjAccount{get;set;}
    public List<wrapperOfInvoiceLineItems> invoiceLineItemList{get;set;}
    public wrapperOfILITotalDetails wrapperObjLast{get;set;}
    public InvoicePDFGenerateController(){
        this.recordId = ApexPages.currentPage().getParameters().get('id');
        this.typeOfPDF = ApexPages.currentPage().getParameters().get('typeofpdf');
        ifb_Tax_Invoice = ConstantUtilities.IFB_TAX_INVOICE;
        ifb_Delivery_Challan = ConstantUtilities.IFB_DELIVERY_CHALLAN;
        idwBranch_Name_Of_Consignor = ConstantUtilities.IDW_BRANCH_NAME_OF_CONSIGNOR;
        ifb_Industries_Limited = ConstantUtilities.IFB_INDUSTRIES_LIMITED;
        iDw_Branch_Name_Of_Consignor_Address = ConstantUtilities.IDW_BRANCH_NAME_OF_CONSIGNOR_ADDRESS;
        iDw_Hub_Name_Name_Of_Consignor_Address = ConstantUtilities.IDW_HUB_NAME_OF_CONSIGNOR_ADDRESS;
        iLM_Consignor_Address = ConstantUtilities.ILM_CONSIGNOR_ADDRESS;
        iDw_Branch_gStin = ConstantUtilities.IDW_BRANCH_GSTIN;
        iDw_Hub_gStin = ConstantUtilities.IDW_HUB_GSTIN;
        iLM_PAN_GSTIN = ConstantUtilities.ILM_PDF_PAN_GSTIN;
        iFB =ConstantUtilities.IFB;
        iFb_Address =  ConstantUtilities.IFB_ADDRESS;
        iFb_Phone = ConstantUtilities.IFB_PHONE;
        iFb_Fax = ConstantUtilities.IFB_FAX;
        iFb_Websit_Email = ConstantUtilities.IBF_WEBSITE_EMAIL;
        iFb_Pan_No = ConstantUtilities.IFB_PAN_NO;
        iFb_Cin = ConstantUtilities.IBF_CIN;
        iFb_IdwBranch_StateName_Code = ConstantUtilities.IDW_BRANCH_STATENAME_CODE;
        iFb_IdwHub_StateName_Code = ConstantUtilities.IDW_HUB_STATENAME_CODE;
        iFB_IlmPdf_StateName_Code = ConstantUtilities.ILM_PDF_STATENAME_CODE;
        pLace_Of_Supply = ConstantUtilities.PLACE_OF_SUPPLY;
        
        
        
        
        
        try{
            Invoice__c invoiceObj = [SELECT Id, Invoice_NO__c, SO_No__c, PO_NO__c,Purchase_Order__r.Account.Name, Purchase_Order__r.Account.Parent.BillingAddress, Purchase_Order__r.Account.Phone, 
                                     Purchase_Order__r.Account.cgcloud__Account_Number__c, Purchase_Order__r.Account.ShippingAddress, Total_Amount__c, Total_Invoice_Amount__c FROM Invoice__c WHERE Id =: recordId Limit 1];
            wrapperObj = new wrapperOfInvoideDetailColumn();
            wrapperObj.invoiceNo = invoiceObj.Invoice_NO__c;
            wrapperObj.invoiceDate = '';
            wrapperObj.invoiceTime = '';
            wrapperObj.invoiceTranceportName = '';
            wrapperObj.invoiceTranceportMode = '';
            wrapperObj.invoiceVehicleNo = '';
            wrapperObj.LRNumber = '';
            wrapperObj.invoiceGrossWeight = '';
            wrapperObj.invoiceNetWt = '';
            wrapperObj.invoiceSalesOrder = invoiceObj.SO_No__c;
            wrapperObj.invoiceChallanDetails = '';
            wrapperObj.invoicePODetails = invoiceObj.PO_NO__c;
            wrapperObjAccount = new wrapperOfAccountDetails();
            wrapperObjAccount.nameOfConsignee = invoiceObj.Purchase_Order__r.Account.Name; 
            wrapperObjAccount.consigneeBilledTo = '';
            if(invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress != Null){
                String str = (invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getStreet() != null ? invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getStreet() : '');
                str += ' '+(invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getCity() != null ? invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getCity() : '');
                str +=    ' '+(invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getState() != null ? invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getState() : '');
                str += ' '+(invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getCountry() != null ? invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getCountry() : '');
                str +=    ' '+(invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getPostalCode() != null ? invoiceObj.Purchase_Order__r.Account.Parent.BillingAddress.getPostalCode() : '');
                wrapperObjAccount.billingAddress = str;
            }
            wrapperObjAccount.phoneNo = invoiceObj.Purchase_Order__r.Account.Phone;
            wrapperObjAccount.mobileNo = '';
            wrapperObjAccount.billingEmail = invoiceObj.Purchase_Order__r.Account.cgcloud__Account_Number__c;
            wrapperObjAccount.stateNameCode = '';
            wrapperObjAccount.panNo = '';
            wrapperObjAccount.gstiNUIN = '';
            
            wrapperObjAccount.shipTo = '';
            wrapperObjAccount.name = '';
            if(invoiceObj.Purchase_Order__r.Account.ShippingAddress != Null){
                String str1 = (invoiceObj.Purchase_Order__r.Account.ShippingAddress.getStreet() != null ? invoiceObj.Purchase_Order__r.Account.ShippingAddress.getStreet() : '');
                str1 += ' '+(invoiceObj.Purchase_Order__r.Account.ShippingAddress.getCity() != null ? invoiceObj.Purchase_Order__r.Account.ShippingAddress.getCity() : '');
                str1 +=    ' '+(invoiceObj.Purchase_Order__r.Account.ShippingAddress.getState() != null ? invoiceObj.Purchase_Order__r.Account.ShippingAddress.getState() : '');
                str1 += ' '+(invoiceObj.Purchase_Order__r.Account.ShippingAddress.getCountry() != null ? invoiceObj.Purchase_Order__r.Account.ShippingAddress.getCountry() : '');
                str1 +=    ' '+(invoiceObj.Purchase_Order__r.Account.ShippingAddress.getPostalCode() != null ? invoiceObj.Purchase_Order__r.Account.ShippingAddress.getPostalCode() : '');
                
                wrapperObjAccount.shippingAddress = str1;
            }
            wrapperObjAccount.ShipingPhoneNo = invoiceObj.Purchase_Order__r.Account.Phone;
            wrapperObjAccount.shipingMobileNo = '';
            wrapperObjAccount.email = invoiceObj.Purchase_Order__r.Account.cgcloud__Account_Number__c;
            
            Decimal gstValue1 = 0;
            Decimal gstValue2 = 0;
            Decimal gstValue3 = 0;
            Decimal quantity = 0;
            invoiceLineItemList = new List<wrapperOfInvoiceLineItems>();
            for(Invoice_Line_Item__c invoiceLineItemObj : [SELECT Id, Material_Code__c, HSN_OF_SKU__c, Product__r.Name,Quantity__c, Total_Amount__c, CGST__c, CGST_Value__c, SGST__c, SGST_Value__c, IGST__c, IGST_Value__c, Invoice__r.Total_Amount__c, Invoice__r.Total_Invoice_Amount__c From Invoice_Line_Item__c WHERE Invoice__r.Id =: recordId ]){
                wrapperOfInvoiceLineItems wrapperInvoiceLineItemObj = new wrapperOfInvoiceLineItems();
                wrapperInvoiceLineItemObj.ivItemCodeCustMatCode = invoiceLineItemObj.Material_Code__c;
                wrapperInvoiceLineItemObj.ivDescofGoodsServices = invoiceLineItemObj.Product__r.Name;
                wrapperInvoiceLineItemObj.ivCustPO = '';
                wrapperInvoiceLineItemObj.ivHSNofGoodsServices = invoiceLineItemObj.HSN_OF_SKU__c;
                wrapperInvoiceLineItemObj.ivQty = invoiceLineItemObj.Quantity__c;
                wrapperInvoiceLineItemObj.ivUoM = '';
                wrapperInvoiceLineItemObj.ivUnitPrice = 0.00;
                wrapperInvoiceLineItemObj.ivTotalAmount = invoiceLineItemObj.Total_Amount__c;
                wrapperInvoiceLineItemObj.ivDiscount1 = '';
                wrapperInvoiceLineItemObj.ivDiscount2 = '';
                wrapperInvoiceLineItemObj.ivTaxablevalue = '';
                wrapperInvoiceLineItemObj.gstRate1 = invoiceLineItemObj.CGST__c;
                wrapperInvoiceLineItemObj.gstAmount1 = invoiceLineItemObj.CGST_Value__c;
                wrapperInvoiceLineItemObj.gstRate2 = invoiceLineItemObj.SGST__c;
                wrapperInvoiceLineItemObj.gstAmount2 = invoiceLineItemObj.SGST_Value__c;
                wrapperInvoiceLineItemObj.gstRate3 = invoiceLineItemObj.IGST__c;
                wrapperInvoiceLineItemObj.gstAmount3 = invoiceLineItemObj.IGST_Value__c;
                gstValue1 += (invoiceLineItemObj.IGST_Value__c == Null ? 0 : invoiceLineItemObj.IGST_Value__c);
                gstValue2 += (invoiceLineItemObj.CGST_Value__c == Null ? 0 : invoiceLineItemObj.CGST_Value__c);
                gstValue3 += (invoiceLineItemObj.SGST_Value__c == Null ? 0 : invoiceLineItemObj.SGST_Value__c);
                quantity += (invoiceLineItemObj.Quantity__c != Null ? invoiceLineItemObj.Quantity__c : 0);
                invoiceLineItemList.add(wrapperInvoiceLineItemObj);
            }
            
            wrapperObjLast = new wrapperOfILITotalDetails();
            wrapperObjLast.totalAmount = invoiceObj.Total_Amount__c;
            wrapperObjLast.totalTax = 0.00;
            
            wrapperObjLast.totalCGST = gstValue2;
            wrapperObjLast.totalSGST = gstValue3;
            wrapperObjLast.totalIGST = gstValue1;
            wrapperObjLast.totalinvoiceValue = invoiceObj.Total_Invoice_Amount__c;
            wrapperObjLast.cgstWord = DecimalToWordsConverter.convertDecimalToWords(gstValue2);
            wrapperObjLast.sgstWord = DecimalToWordsConverter.convertDecimalToWords(gstValue3);
            wrapperObjLast.totalIGSTWord = DecimalToWordsConverter.convertDecimalToWords(gstValue1);
            wrapperObjLast.totalWord = DecimalToWordsConverter.convertDecimalToWords(invoiceObj.Total_Invoice_Amount__c);
            wrapperObjLast.totalQuantity = quantity;
        }
        catch(Exception e){
            ExceptionHandler.logException('InvoicePDFGenerateController', 'InvoicePDFGenerateController', e);
        }
    }
    
    public class wrapperOfAccountDetails{
        public string nameOfConsignee{get;set;}
        public String consigneeBilledTo{get;set;}
        public string billingAddress{get;set;}
        public string phoneNo{get;set;}
        public string mobileNo{get;set;}
        public string billingEmail{get;set;}
        public string stateNameCode{get;set;}
        public string panNo{get;set;}
        public string gstiNUIN{get;set;}
        
        public string shipTo{get;set;}
        public string name{get;set;}
        public string shippingAddress{get;set;}
        public string ShipingPhoneNo{get;set;}
        public string shipingMobileNo{get;set;}
        public string email{get;set;}
    }
    
    public class wrapperOfILITotalDetails{
        public Decimal totalAmount{get;set;}
        public Decimal taxebleAmount{get;set;}
        public Decimal totalTax{get;set;}
        public Decimal totalCGST{get;set;}
        public Decimal totalSGST{get;set;}
        public Decimal totalinvoiceValue{get;set;}
        public Decimal totalIGST{get;set;}
        public Decimal finalTotal{get;set;}
        public String cgstWord{get;set;}
        public String sgstWord{get;set;}
        public String totalWord{get;set;}
        public String totalIGSTWord{get;set;}
        public Decimal totalQuantity{get;set;}
    }
    
    public class wrapperOfInvoiceLineItems{
        public string ivItemCodeCustMatCode{get;set;}
        public string ivDescofGoodsServices{get;set;}
        public string ivCustPO{get;set;}
        public string ivHSNofGoodsServices{get;set;}
        public Decimal ivQty{get;set;}
        public string ivUoM{get;set;}
        public Decimal ivUnitPrice{get;set;}
        public Decimal ivTotalAmount{get;set;}
        public string ivDiscount1{get;set;}
        public string ivDiscount2{get;set;}
        public string ivTaxablevalue{get;set;}
        public Decimal gstRate1{get;set;}
        public Decimal gstAmount1{get;set;}
        public Decimal gstRate2{get;set;}
        public Decimal gstAmount2{get;set;}
        public Decimal gstRate3{get;set;}
        public Decimal gstAmount3{get;set;}
    }
    
    public class wrapperOfInvoideDetailColumn{
        public String invoiceNo{get;set;}
        public String invoiceDate{get;set;}
        public String invoiceTime{get;set;}
        public String invoiceTranceportName{get;set;}
        public String invoiceTranceportMode{get;set;}
        public String invoiceVehicleNo{get;set;}
        public String LRNumber{get;set;}
        public String invoiceGrossWeight{get;set;}
        public String invoiceNetWt{get;set;}
        public String invoiceSalesOrder{get;set;}
        public String invoiceChallanDetails{get;set;}
        public String invoicePODetails{get;set;}
    }
    
    
}