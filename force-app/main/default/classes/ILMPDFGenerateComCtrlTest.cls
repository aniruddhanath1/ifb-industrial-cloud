@isTest
public class ILMPDFGenerateComCtrlTest {
    
    @isTest 
    public static void testGeneratePDFClass(){
        Test.startTest();
        Invoice__c invoiceObj = TestDataFactory.invoiceRecordCreation();
        Product2 prodObj = TestDataFactory.createProduct2();
        TestDataFactory.invoiceLineIteamCreation(prodObj.Id,invoiceObj.Id);
        System.assertEquals('WASHER EXTRACTOR IWE 108 – ELECTRIC.', prodObj.Name, 'WASHER EXTRACTOR IWE 108 – ELECTRIC.');
        PageReference pageRef = new PageReference('ILMPdfGenerate');
        pageRef.getParameters().put('id', invoiceObj.Id);
        pageRef.getParameters().put('typeofpdf', 'ILMRGFE');
        Test.setCurrentPage(pageRef);
        InvoicePDFGenerateController generatePDFCtrlObj = new InvoicePDFGenerateController();
        Test.stopTest();
    }
}