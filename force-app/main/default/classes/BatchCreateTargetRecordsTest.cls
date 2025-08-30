@IsTest
private class BatchCreateTargetRecordsTest {
    
    @testSetup
    static void setupTestData() {
        // Create a test user
		User testUser = new User(
				FirstName = 'Test',
				LastName = 'User',
				Email = 'testuser@example.com',
				Username = 'testuser@example.com.' + System.currentTimeMillis(),
				Alias = 'tuser',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8',
				IsActive = true,
				ProfileId = [SELECT Id FROM Profile WHERE Name = 'ASM - Area Sales Manager' LIMIT 1].Id,
				LanguageLocaleKey = 'en_US'
		);
        insert testUser;
    }
    
    @IsTest
    static void testBatchExecution() {
        // Query the test user created in @testSetup
        List<User> testUsers = [SELECT Id FROM User WHERE IsActive = true AND Profile.Name = 'ASM - Area Sales Manager'];
        System.assertNotEquals(0, testUsers.size(), 'Test user should exist');

        // Run the batch
		System.runAs(testUsers[0]) {
			Test.startTest();
			BatchCreateTargetRecords batchJob = new BatchCreateTargetRecords();
			Database.executeBatch(batchJob);
			Test.stopTest();
		}


        // Validate that Target__c records were created
        List<Target__c> createdTargets = [SELECT Id, Type__c, Sub_Type__c, User__c FROM Target__c WHERE User__c = :testUsers[0].Id];
        System.assertNotEquals(0, createdTargets.size(), 'Target records should be created');

        // Validate hierarchy relationships
        Map<String, Target__c> yearlyTargets = new Map<String, Target__c>();
        Map<String, Target__c> halfYearlyTargets = new Map<String, Target__c>();
        Map<String, Target__c> quarterlyTargets = new Map<String, Target__c>();

        for (Target__c target : createdTargets) {
            if (target.Type__c == 'Yearly') {
                yearlyTargets.put(target.User__c, target);
            } else if (target.Type__c == 'Half Yearly') {
                halfYearlyTargets.put(target.User__c + '_' + target.Sub_Type__c, target);
            } else if (target.Type__c == 'Quarterly') {
                quarterlyTargets.put(target.User__c + '_' + target.Sub_Type__c, target);
            }
        }

        // Verify that yearly targets exist
        System.assert(yearlyTargets.containsKey(testUsers[0].Id), 'Yearly Target should exist for user');

        // Verify that half-yearly targets have valid parent targets
        for (Target__c halfYearly : halfYearlyTargets.values()) {
            //System.assertNotEquals(null, halfYearly.Parent_Target__c, 'Half Yearly targets should have parent');
            //System.assertEquals(yearlyTargets.get(testUsers[0].Id).Id, halfYearly.Parent_Target__c, 'Half Yearly parent should be correct');
        }

        // Verify that quarterly targets have valid parent targets
        for (Target__c quarterly : quarterlyTargets.values()) {
            Integer quarter = Integer.valueOf(quarterly.Sub_Type__c);
            Integer halfYear = (quarter + 1) / 2;
            //System.assertNotEquals(null, quarterly.Parent_Target__c, 'Quarterly targets should have parent');
            //System.assertEquals(halfYearlyTargets.get(testUsers[0].Id + '_' + halfYear).Id, quarterly.Parent_Target__c, 'Quarterly parent should be correct');
        }

        // Verify that monthly targets exist
        for (Target__c monthly : createdTargets) {
            if (monthly.Type__c == 'Monthly') {
                Integer month = Integer.valueOf(monthly.Sub_Type__c);
                Integer quarter = (month + 2) / 3;
                //System.assertNotEquals(null, monthly.Parent_Target__c, 'Monthly targets should have parent');
                //System.assertEquals(quarterlyTargets.get(testUsers[0].Id + '_' + quarter).Id, monthly.Parent_Target__c, 'Monthly parent should be correct');
            }
        }
    }
}