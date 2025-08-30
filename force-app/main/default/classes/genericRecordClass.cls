public without sharing class genericRecordClass {
    @AuraEnabled(cacheable=true)
    public static List<User> getUserDetails(String searchKey, String objectName){
        try{
            string searchAcc= '\'' + String.escapeSingleQuotes(searchKey) + '%\'';
            string query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchAcc+' LIMIT 5';
            
            system.debug('query: '+query);
            return Database.query(query); 
            
        }catch(Exception e){
            ExceptionHandler.logException('genericRecordClass', 'getUserDetails', e);
            return null;
        }
        
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactDetails(String searchKey, String opportunityId) {
        try{
            Opportunity opportunityInst = [SELECT Id, AccountId FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
            String searchAcc = '%' + String.escapeSingleQuotes(searchKey) + '%';
            String query = 'SELECT Id, Name,LastName FROM Contact WHERE Name LIKE :searchAcc AND AccountId = :accountId LIMIT 5';
            
            system.debug('Query: ' + query);
            return database.queryWithBinds( query, 
                                           new Map<String, Object>{'accountId' => opportunityInst.AccountId,'searchAcc' => searchAcc}, 
                                           AccessLevel.SYSTEM_MODE
                                          );
            
        }catch(Exception e){
            ExceptionHandler.logException('genericRecordClass', 'getContactDetails', e);
            return null;
        }
        
    }
}