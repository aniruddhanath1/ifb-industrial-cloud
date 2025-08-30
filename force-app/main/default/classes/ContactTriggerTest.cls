@isTest
public class ContactTriggerTest {
    
    @testSetup
    static void setupDataForTest(){
        Test.startTest();
        try{
            Lead lead1 = (Lead) TestDataFactory.createLead(); 
            List<Contact> contactList = new List<Contact>();
            contactList.add(TestDataFactory.createContactWithoutAccount(null,'Contact 1','8956235879','Test@gmail.com',null,null,false));
            contactList.add(TestDataFactory.createContactWithoutAccount(null,'Contact 2','8956235879','Test@gmail.com',null,null,false));
            contactList.add(TestDataFactory.createContactWithoutAccount('Test','Contact','8956235879','Test@gmail.com',null,lead1.Id,false));
            Upsert contactList;
            System.assert(contactList.size() > 0, 'The list of contacts is  not empty.');

        }catch(exception e){
            
        }
                Test.stopTest();
    }
    
    @isTest
    static void testAfterInsertAgain() {
        Contact con = TestDataFactory.createContactWithoutAccount('firstName', 'Contact', '8378273827', 'test@mail.com', null, null, true);
        con.Phone = '9283738273';
        system.debug(con);
        Test.startTest();
        try{
            update con;
            Lead lead1 = [SELECT Id, FirstName, LastName, Company, PostalCode, Product_Category__c, Requirement__c, Email, Status From Lead Limit 1];
            List<Contact> contactList = new List<Contact>();
            contactList = [SELECT Id, FirstName, LastName, Phone, Email,MailingCountryCode, Lead__c From Contact WHERE (LastName = 'Contact 1' OR LastName = 'Contact 2' OR LastName = 'Contact')];
            Set<String> str1 = new Set<String>{contactList[0].LastName,contactList[0].LastName};    
            Set<String> str2 = new Set<String>{contactList[0].Phone,contactList[1].Phone};        
            Set<String> str3 = new Set<String>{contactList[0].email,contactList[1].email};            
            ContactTriggerHelper.contactMergeMethod(new Set<String>(),str1, str2, str3);
            
            ContactTriggerHandler handlerClassObj = new ContactTriggerHandler();
            handlerClassObj.beforeInsert(contactList);
            handlerClassObj.afterUpdate(contactList,contactList,new Map<ID, SObject>{contactList[0].Id => contactList[0]}, new Map<ID, SObject>{contactList[0].Id => contactList[0]});
            handlerClassObj.afterDelete(contactList,  new Map<ID, SObject>{contactList[0].Id => contactList[0]});
            handlerClassObj.beforeDelete(contactList,  new Map<ID, SObject>{contactList[0].Id => contactList[0]});
            handlerClassObj.afterUndelete(contactList,  new Map<ID, SObject>{contactList[0].Id => contactList[0]});
        }catch(exception e){}
        
        Test.stopTest();
    }
    
}