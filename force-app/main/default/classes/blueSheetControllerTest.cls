@isTest 
public class blueSheetControllerTest {
	
    @isTest
    public static void getBlueSheetDataTest(){
        User objUser = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];   
        Account insertedAcc = TestDataFactory.createAccount();
        Opportunity opp = TestDataFactory.createOpportunityForAccount(insertedAcc.Id,'Prospecting',objUser);
        Blue_Sheet__c blueSheetObj = TestDataFactory.createBlueSheetRecord(opp);
            blueSheetObj.Who__c = objUser.Id;
            blueSheetObj.From_Whom__c = objUser.Id;
            Update blueSheetObj;   
        
        Test.startTest();
        List<blueSheetController.BlueSheetData> listData = blueSheetController.getBlueSheetData(opp.Id);
        System.assertEquals(listData.size(), listData.size(), 'List Should Not Empty...');
        
        
        Map<String,Object> mainNewMap = new Map<String,Object>();
        mainNewMap.put('opportunityId',opp.Id);
        
        blueSheetController.BuyingInfluence fieldClassObj = new blueSheetController.BuyingInfluence();
        fieldClassObj.type = 'Buying Influences Involved';
        mainNewMap.put('buyingInfluenceList',JSON.serialize(new List<blueSheetController.BuyingInfluence>{fieldClassObj}));

        
        blueSheetController.IdealCustomer thirdClassObj = new blueSheetController.IdealCustomer();
        thirdClassObj.type = 'Buying Influences Involved';
        mainNewMap.put('idealCustomerList',JSON.serialize(new List<blueSheetController.IdealCustomer>{thirdClassObj}));
        
        
        blueSheetController.Strength fourthClassObj = new blueSheetController.Strength();
        fourthClassObj.type = 'Buying Influences Involved';
        fourthClassObj.whenDate = String.valueOf(System.today());
        mainNewMap.put('strengthList',JSON.serialize(new List<blueSheetController.Strength>{fourthClassObj}));
        
        
        blueSheetController.RedFlag fifthClassObj = new blueSheetController.RedFlag();
        fifthClassObj.type = 'Buying Influences Involved';
        mainNewMap.put('redFlagList',JSON.serialize(new List<blueSheetController.RedFlag>{fifthClassObj}));
        
        blueSheetController.saveblueSheetData(JSON.serialize(mainNewMap));
        Test.stopTest();
        Integer remainingBlueSheet = [SELECT COUNT() FROM Blue_Sheet__c];
        
    }
}