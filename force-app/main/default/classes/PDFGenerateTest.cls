@isTest
public class PDFGenerateTest {
    @TestSetup
    public static void setupTestData() {
        Account insertedAcc = TestDataFactory.createAccount();
        User testUser = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];   
        Opportunity opp = TestDataFactory.createOpportunityForAccount(insertedAcc.Id, 'Prospecting', testUser);
        Blue_Sheet__c blueSheetObj = TestDataFactory.createBlueSheetRecord(opp);
    }
    
    @isTest
    public static void testMethodOne(){    
        Opportunity opp = [SELECT Id, Blue_Sheet_Created_Date__c, Blue_Sheet_Last_Modified_Date__c FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.PDFgenerator;
        pageRef.getParameters().put('id',opp.Id);
        
        test.setCurrentPageReference(pageRef);
        
        PDFGenerate pdfGenerateClassObj = new PDFGenerate();           
        opp.Blue_Sheet_Created_Date__c = System.Today();
        opp.Blue_Sheet_Last_Modified_Date__c = System.Today();
        Update opp;
        
        pdfGenerateClassObj.opportunity = opp;
        
        Test.startTest();
        DateTime createdDateIST = pdfGenerateClassObj.getBlueSheetCreatedDateIST();
        DateTime lastModifiedDateIST  = pdfGenerateClassObj.getBlueSheetLastModifiedDateIST();
        Test.stopTest();
        System.assertEquals(opp.Blue_Sheet_Created_Date__c.addHours(5).addMinutes(30), createdDateIST);
        System.assertEquals(opp.Blue_Sheet_Last_Modified_Date__c.addHours(5).addMinutes(30), lastModifiedDateIST);
        
    }
}