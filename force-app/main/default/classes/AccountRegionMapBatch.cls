public class AccountRegionMapBatch implements Database.Batchable<SObject>, Database.Stateful {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query all Accounts with a Billing Postal Code
        return Database.getQueryLocator([
            SELECT Id, BillingPostalCode, Owner.Id
            FROM Account
            WHERE BillingPostalCode != null
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        // Collect all postal codes from the scope
        Set<String> postalCodes = new Set<String>();
        for (Account acc : scope) {
            if (String.isNotBlank(acc.BillingPostalCode)) {
                postalCodes.add(acc.BillingPostalCode);
            }
        }

        // Query Region Map records matching the postal codes
        Map<String, Id> postalCodeToUserMap = new Map<String, Id>();
        for (Region_Map__c region : [
            SELECT Zipcode__c, Region_Owner__r.Id
            FROM Region_Map__c
            WHERE Zipcode__c IN :postalCodes
        ]) {
            postalCodeToUserMap.put(region.Zipcode__c, region.Region_Owner__r.Id);
        }

        // Prepare accounts for update
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : scope) {
            if (postalCodeToUserMap.containsKey(acc.BillingPostalCode)) {
                acc.ownerId = postalCodeToUserMap.get(acc.BillingPostalCode);
                accountsToUpdate.add(acc);
            }
        }

        // Update accounts in bulk
        if (!accountsToUpdate.isEmpty()) {
            Database.SaveResult[] results = Database.update(accountsToUpdate, false);
           
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Optional: Add any finish logic or notification
        System.debug('Batch Process Completed.');
    }
}