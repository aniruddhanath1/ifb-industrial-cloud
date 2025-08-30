@isTest
public class POPdfGenerateComCtrlTest {
	@testSetup
    public static void dataSetupForTest(){
        Account accObj = TestDataFactory.createAccount();
        Order orderObj = TestDataFactory.createTestOrder(accObj.Id);
        Product2 productObj = TestDataFactory.createProduct2();
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(
            Id = pricebookId,
            IsActive = true
        );
        update standardPricebook;
        pricebookEntry priceBookEntryObj = TestDataFactory.createPriceBookEntity(standardPricebook.Id,productObj.Id);
        TestDataFactory.createOrderLineItemRecord(orderObj.Id, productObj.Id, priceBookEntryObj.Id);
    }
    
    @isTest
    public static void testGeneratePDFMethod(){
        Order orderObj = [SELECT Id From Order Limit 1];
        PageReference pageRef = new PageReference('/apex/ILMPdfGenerate');
        pageRef.getParameters().put('id',orderObj.Id);
        pageRef.getParameters().put('typeofpdf','ILM_RGFE');
        test.setCurrentPageReference(pageRef);
        POPdfGenerateComCtrl pdfGeneratorClassObj = new POPdfGenerateComCtrl();
    }
    
     @isTest
    public static void testWrapperClassesTest(){
        POPdfGenerateComCtrl.WrapperOfAccountDetails wrapperObj = new POPdfGenerateComCtrl.WrapperOfAccountDetails();
        wrapperObj.billingAddress = 'Test';
        wrapperObj.mobileNo = 'Test';
        wrapperObj.billingEmail = 'Test';
        wrapperObj.stateNameCode = 'Test';
        wrapperObj.panNo = 'Test';
        wrapperObj.shipTo = 'Test';
        wrapperObj.name = 'Test';
        wrapperObj.shippingAddress = 'Test';
        wrapperObj.ShipingPhoneNo = 'Test';
        wrapperObj.shipingMobileNo = 'Test';
    }
}