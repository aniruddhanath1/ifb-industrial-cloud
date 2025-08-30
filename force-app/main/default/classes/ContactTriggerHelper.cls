/*
@Author : Yadram
@CreatedDate : 26 Aug 2024
@Description : Appropriate Method on Handler invoked based on trigger context.
*/
public class ContactTriggerHelper {
    
    public static void contactMergeMethod(Set<String> firstName,Set<String> lastName ,Set<String> phone, Set<String> email){
        system.debug('Inside Contact Merge Method');
        try{
            Map<String,List<Contact>> contactsMap = new Map<String,List<Contact>>();
            List<Contact> masterContactUpdate = new List<Contact>();
            List<Contact> contactToDelete = new List<Contact>();
            system.debug('firstNameSet>>'+firstName);
            system.debug('lastNameSet>>'+lastName);
            system.debug('phoneSet>>'+phone);
            system.debug('emailSet>>'+email);
            List<Contact> contactList = new List<Contact>([SELECT Id,FirstName,Lead__c,LastName,Title,Landline__c,AccountId,Alternative_Phone_Number__c,Department,MobilePhone,
                                                           Key_Decision_Maker__c,CurrencyIsoCode,Phone,Email,Customer_Department__c,Primary_Contact__c,Customer_Designation__c,
                                                           MailingCity,MailingStateCode,MailingState,MailingStreet,MailingPostalCode,MailingCountry,MailingCountryCode,
                                                           OtherCountry,OtherCity,OtherPostalCode,OtherState,OtherStateCode,OtherStreet,
                                                           LeadSource FROM Contact Where (firstName IN : firstName AND LastName IN : lastName AND Phone IN : phone) OR
                                                           (Phone IN : phone AND Email IN : Email) 
                                                           order by Createddate DESC]);
            system.debug('contactList>>'+contactList);
            if(contactList.size() >0){
                system.debug('InsideContactListIF');
                for(Contact conRecord : contactList){
                    String contactNameAndPhone = '';
                    String contactPhoneAndEmail ='';
                    if((String.isBlank(conRecord.firstName)  || (!String.isBlank(conRecord.firstName)))    && conRecord.lastName != Null && conRecord.phone != null){
                        system.debug('InsideContactListsecondIF');
                        contactNameAndPhone = conRecord.firstName+''+ conRecord.lastName +''+conRecord.phone;
                        system.debug('contactNameAndPhone>>'+contactNameAndPhone);
                        if( !contactsMap.containsKey(conRecord.firstName+''+ conRecord.lastName +''+conRecord.phone ) ) {
                            contactsMap.put( contactNameAndPhone, new List<Contact>() );
                        }
                        contactsMap.get(contactNameAndPhone ).add( conRecord ); 
                        system.debug('contactsMap>>'+contactsMap);
                    }
                    if(conRecord.Phone != Null && conRecord.Email != null){
                        contactPhoneAndEmail = conRecord.Phone+''+ conRecord.Email; 
                        if( !contactsMap.containsKey(conRecord.Phone +''+conRecord.Email ) ) {
                            
                            contactsMap.put( contactPhoneAndEmail, new List<Contact>() );
                        }
                        contactsMap.get(contactPhoneAndEmail ).add( conRecord );
                        system.debug('contactsMap2>>'+contactsMap);
                    }  
                } 
                if(!contactsMap.isEmpty()){
                    Set<Id> masterContactIds = new Set<Id>();
                    for( String key : contactsMap.keySet() ) {
                        List<Contact> contactsToMerge = contactsMap.get( key );                      
                        if( contactsToMerge.size() > 0) {
                            Contact masterContact = contactsToMerge[0];
                            system.debug(masterContact);
                            for( Integer i = 1; i < contactsToMerge.size(); i++ ) {
                                Contact mergedContact = contactsToMerge[i];
                                masterContact.Customer_Department__c = masterContact.Customer_Department__c != Null ?  masterContact.Customer_Department__c : mergedContact.Customer_Department__c;
                                masterContact.Customer_Designation__c = masterContact.Customer_Designation__c != Null ?  masterContact.Customer_Designation__c : mergedContact.Customer_Designation__c;
                                masterContact.Email = masterContact.Email != Null ?  masterContact.Email : mergedContact.Email;
                                
                                masterContact.FirstName = masterContact.FirstName != Null ?  masterContact.FirstName : mergedContact.FirstName;
                                masterContact.LastName = masterContact.LastName != Null ?  masterContact.LastName : mergedContact.LastName;
                                
                                masterContact.Lead__c = masterContact.Lead__c != Null ?  masterContact.Lead__c : mergedContact.Lead__c;
                                masterContact.Title = masterContact.Title != Null ?  masterContact.Title : mergedContact.Title;
                                
                                masterContact.Department = masterContact.Department != Null ?  masterContact.Department : mergedContact.Department;
                                masterContact.Landline__c = masterContact.Landline__c != Null ?  masterContact.Landline__c : mergedContact.Landline__c;
                                masterContact.AccountId = masterContact.AccountId != Null ?  masterContact.AccountId : mergedContact.AccountId;
                                
                                masterContact.Alternative_Phone_Number__c = masterContact.Alternative_Phone_Number__c != Null ?  masterContact.Alternative_Phone_Number__c : mergedContact.Alternative_Phone_Number__c;
                                masterContact.MobilePhone = masterContact.MobilePhone != Null ?  masterContact.MobilePhone : mergedContact.MobilePhone;
                                masterContact.Key_Decision_Maker__c = masterContact.Key_Decision_Maker__c != Null ?  masterContact.Key_Decision_Maker__c : mergedContact.Key_Decision_Maker__c;
                                
                                masterContact.CurrencyIsoCode = masterContact.CurrencyIsoCode != Null ?  masterContact.CurrencyIsoCode : mergedContact.CurrencyIsoCode;
                                masterContact.MobilePhone = masterContact.MobilePhone != Null ?  masterContact.MobilePhone : mergedContact.MobilePhone;
                                masterContact.Email = masterContact.Email != Null ?  masterContact.Email : mergedContact.Email;
                                
                                masterContact.MailingCity = masterContact.MailingCity != Null ?  masterContact.MailingCity : mergedContact.MailingCity;
                                masterContact.MailingStateCode = masterContact.MailingStateCode != Null ?  masterContact.MailingStateCode : mergedContact.MailingStateCode;
                                masterContact.MailingState = masterContact.MailingState != Null ?  masterContact.MailingState : mergedContact.MailingState;
                                
                                masterContact.MailingStreet = masterContact.MailingStreet != Null ?  masterContact.MailingStreet : mergedContact.MailingStreet;
                                masterContact.MailingPostalCode = masterContact.MailingPostalCode != Null ?  masterContact.MailingPostalCode : mergedContact.MailingPostalCode;
                                masterContact.MailingCountry = masterContact.MailingCountry != Null ?  masterContact.MailingCountry : mergedContact.MailingCountry;
                                
                                masterContact.MailingCountryCode = masterContact.MailingCountryCode != Null ?  masterContact.MailingCountryCode : mergedContact.MailingCountryCode;
                                masterContact.LeadSource = masterContact.LeadSource != Null ?  masterContact.LeadSource : mergedContact.LeadSource;
                                masterContact.OtherCountry = mergedContact.OtherCountry;
                                masterContact.OtherCity = mergedContact.OtherCity;
                                masterContact.OtherPostalCode = mergedContact.OtherPostalCode;
                                masterContact.OtherState = mergedContact.OtherState;
                                masterContact.OtherStateCode = mergedContact.OtherStateCode;
                                masterContact.OtherStreet = mergedContact.OtherStreet;
                                if(!masterContactIds.contains(masterContact.Id)){
                                    masterContact.Primary_Contact__c = true;
                                    masterContactUpdate.add(masterContact);
                                    masterContactIds.add(masterContact.Id);
                                    contactToDelete.add(mergedContact);
                                }
                                
                                 
                                
                            }
                        }  
                    }
                }  
            } 
            if(!contactToDelete.isEmpty()){
                Delete contactToDelete;
            } 
            if(!masterContactUpdate.isEmpty()){
                Update masterContactUpdate;   
            }
            
        }
        catch(Exception e){
            ExceptionHandler.logException('ContactTriggerHelper', 'contactMergeMethod', e);
        }   
        
    }
    
}