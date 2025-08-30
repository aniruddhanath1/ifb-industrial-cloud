/*
@Author : Yadram
@CreatedDate : 26 Aug 2024
@Description : Appropriate Method on Handler invoked based on trigger context.
*/

public without sharing class ContactTriggerHandler implements InterfaceTriggerHandler {
    
    public ContactTriggerHandler() {   
        //this.helper = new ContactTriggerHandler();
    }
    public void beforeInsert(List<Contact> newContacts) {
        List<Contact> contactsToCheckPhoneNumber = new List<Contact>();
        for(Contact contactRecord : newContacts){
            if(contactRecord.MailingCountryCode  == ConstantUtilities.COUNTRY_CODE_IN){
                contactsToCheckPhoneNumber.add(contactRecord);
            }
        }
        if(contactsToCheckPhoneNumber.size() >0){
            Utilities.checkPhoneOrSTDcodeForSObjects(contactsToCheckPhoneNumber);
        }
        // helper.doTask1();
        // helper.doTask2();
    }
    public void beforeUpdate(List<Contact> oldContacts, List<Contact> newContacts, Map<ID, SObject> oldContactMap, Map<ID, SObject> newContactMap) {
        List<Contact> contactsToCheckPhoneNumber = new List<Contact>();
        for(Contact contactRecord : newContacts){
            system.debug(contactRecord);
            Contact oldContact = (Contact) Trigger.OldMap.get(contactRecord.Id);
            if(contactRecord.MailingCountryCode == ConstantUtilities.COUNTRY_CODE_IN ){
                if((contactRecord.Phone != null && contactRecord.Phone != oldContact.phone) || (contactRecord.Phone == oldContact.phone)){
                    contactsToCheckPhoneNumber.add(contactRecord);  
                } 
            }
        }
        if(contactsToCheckPhoneNumber.size() >0){
            Utilities.checkPhoneOrSTDcodeForSObjects(contactsToCheckPhoneNumber);
        }
        // helper.doTask3();
        // helper.doTask4();
    }
    public void beforeDelete(List<Contact> oldContacts, Map<ID, SObject> oldContactMap) {
        // helper.doTask5();
        // helper.doTask1();
    }
    public void afterInsert(List<Contact> newContacts, Map<ID, SObject> newContactMap) {
        Set<String> contactFirstNameSet = new Set<String>();
        Set<String> contactLastNameSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        Set<String> emailSet = new Set<String>();
        for(Contact contactRecord : newContacts){
            if(String.isBlank(contactRecord.firstName) ||(!String.isBlank(contactRecord.firstName)   && contactRecord.LastName != Null && contactRecord.Phone != Null)){
                contactFirstNameSet.add(contactRecord.FirstName);
                contactLastNameSet.add(contactRecord.LastName);
                phoneSet.add(contactRecord.Phone);
                
            }
            If((contactRecord.Phone != null && contactRecord.Email != Null)){
                phoneSet.add(contactRecord.Phone);
                emailSet.add(contactRecord.Email);
            }  
        }
        
        if((!contactFirstNameSet.isEmpty() || !contactLastNameSet.isEmpty() && !phoneSet.isEmpty()) || (!phoneSet.isEmpty() && !emailSet.isEmpty()) ){
            ContactTriggerHelper.contactMergeMethod( contactFirstNameSet,contactLastNameSet, phoneSet,emailSet);
        }
    }
    public void afterUpdate(List<Contact> oldContacts, List<Contact> newContacts, Map<ID, SObject> oldContactMap, Map<ID, SObject> newContactMap) {
        // helper.doTask3();
        // helper.doTask1();
    }
    public void afterDelete(List<Contact> oldContacts, Map<ID, SObject> oldContactMap) {
        // helper.doTask3();
        // helper.doTask1();
    }
    public void afterUndelete(List<Contact> newContacts, Map<ID, SObject> newContactMap) {
        // helper.doTask4();
        // helper.doTask2();
    }
    
}