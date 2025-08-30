@isTest
public class LeadControllerTest {
    @isTest
    static void testCreateLead() {
        String leadDataJson = '{"Type_of_Customer__c":"Existing","Phone":"9827182781","Operation_Parakram__c":"Yes","Next_Follow_up_Date_Time__c":"2025-02-20","FirstName":"ffff","LastName":"sssss","Email":"warpdrivetechworks.blinfcon392@biocon.com","Company":"final","Street":"sasa","City":"Jaipur","State":"Rajasthan","PostalCode":"303303","Country":"India","Shipping__Street__s": "ssss","Shipping__City__s":"Trichy","Shipping__PostalCode__s":"123","Description":"aa","EmployeeName__c":"Neethu","EmployeeID__c":"123","Call_Centre_Remarks__c":"abcd","accountType":"customer","Product_Category__c":"Industrial Laundry Machine","IsSameLocation":true,"callCenterTeam":"Domestic Call Centre Team"}';
        String leadDataJson1 = '{"Type_of_Customer__c":"Existing","LeadSource":"Industrial Service Team","Partner_Email__c":"test@mail.com","Lead_Sub_Source__c":"Backend Team","LastName":"sssss","Email":"test@example.com","Company":"final","Street":"sasa","City":"Jaipur","State":"Rajasthan","PostalCode":"303303","Country":"India","Shipping__StateCode__s":"Tamil Nadu","Shipping__CountryCode__s":"India","Shipping__Street__s": "ssss","Shipping__City__s":"Trichy","Shipping__PostalCode__s":"12345","Description":"aa","EmployeeName__c":"Neethu","EmployeeID__c":"123","Call_Centre_Remarks__c":"abcd","accountType":"Partners"}';
        String leadDataJson2 = '{"Type_of_Customer__c":"Existing","FirstName":"ffff","LastName":"sssss","Email":"warpdrivetechworks.blinfcon392@biocon.com","Company":"final","Street":"sasa","City":"Jaipur","State":"Rajasthan","PostalCode":"303303","Country":"India","Shipping__Street__s": "ssss","Shipping__City__s":"Trichy","Shipping__PostalCode__s":"123","Description":"aa","EmployeeName__c":"Neethu","EmployeeID__c":"123","Call_Centre_Remarks__c":"abcd","accountType":"callCenterTeam","Product_Category__c":"Industrial Laundry Machine","IsSameLocation":true,"callCenterTeam":"Domestic Call Centre Team"}';
        
        // Call the method being tested
        try{
            Test.startTest();
            String leadId = LeadController.createLead(leadDataJson);
            String leadId1 = LeadController.createLead(leadDataJson1);
            String leadId2 = LeadController.createLead(leadDataJson2);
            
            Test.stopTest();
        }catch(exception e){
            
        }
        
        
        
    }
    
    @isTest
    static void testDuplicateLeads(){
        Lead leadRecords = TestDataFactory.createTestLead('Test Company2', '123452', 'GoogleAds', 'Domestic', 'IDW', 'Washing','123452',false);
        Test.startTest();
        List<Lead> leadList = LeadController.leadDuplicateCheck('Test Company','ILM','680030');
        Test.stopTest();
    }
    
    @isTest
    static void testLeadDuplicateCheck() {
        try{
            Lead testLead = new Lead(
                LastName = 'Test',
                Company = 'TestCompany',
                Product_Category__c = 'ILM',
                PostalCode = '680030',
                Email = 'test@example.com'
            );
            insert testLead;
            Lead testLead2 = new Lead(
                LastName = 'Test',
                Company = 'TestCompnay',
                Product_Category__c = 'ILM',
                PostalCode = '680030',
                Email = 'test2@example.com'
            );
            User uhs = [select Id from User where Profile.UserLicense.Name = 'Guest User License' limit 1];
            System.runAs(uhs) {
                Test.startTest();
                insert testLead2;
                
                Test.stopTest();
            }	
        }catch(exception e){
            
        }             
        List<Lead> duplicateLeads = LeadController.leadDuplicateCheck('TestCompany', 'ILM', '680030');
        
    }
    
}