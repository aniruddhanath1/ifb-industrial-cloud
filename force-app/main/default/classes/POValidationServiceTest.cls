@IsTest
public class POValidationServiceTest {

	@TestSetup
	public static void testPOValidationServiceClass(){
		Test.startTest();
		Account account = TestDataFactory.createAccount();
		User userObj = [SELECT Id From User WHERE Id =: UserInfo.getUserId()];

		Opportunity opp = TestDataFactory.createOpportunityForAccount(account.Id,'Prospecting', userObj);

		SBQQ__Quote__c quote = TestDataFactory.createQuote(opp);
		quote.Freight_Includes__c = 'Included in the Quote';
		quote.SBQQ__Opportunity2__c=opp.Id;
		quote.SBQQ__Primary__c=true;
		quote.Payment_Term__c=40;
		quote.WarrantyTerm_In_Year__c=1;
		quote.Freight_Terms__c='Borne by Customer';
		quote.Actual_Delivery_Period__c = '5-8 weeks';
		update quote;

		Order orderObj = TestDataFactory.createTestOrder(account.Id);
		orderObj.name = 'Test 1';
		orderObj.Status='PO Draft';
		orderObj.EffectiveDate=Date.today();
		orderObj.SBQQ__Quote__c=quote.Id;
		orderObj.PO_Received__c=false;
		orderObj.Credit_Approval_Check_Required__c=false;
		orderObj.GST_Certificate_Provided__c=true;
		orderObj.TCS_Declaration_Form_Provided__c=false;
		orderObj.PAN_Card_Provided__c=true;
		orderObj.Payment_Terms__c=40;
		orderObj.Warranty_Term_In_Year__c=1;
		orderObj.Freight_Terms__c='Borne by Customer';
		orderObj.GST_Certificate_Provided__c = false;
		orderObj.Advance_Received_Amount__c = 10;
		orderObj.Delivery_Period__c = '3-4 weeks';
		update orderObj;

		orderObj = TestDataFactory.createTestOrder(account.Id);
		orderObj.name = 'Test 3';
		orderObj.Status='PO Draft';
		orderObj.EffectiveDate=Date.today();
		orderObj.SBQQ__Quote__c=quote.Id;
		orderObj.PO_Received__c=true;
		orderObj.Credit_Approval_Check_Required__c=true;
		orderObj.GST_Certificate_Provided__c=false;
		orderObj.TCS_Declaration_Form_Provided__c=true;
		orderObj.PAN_Card_Provided__c=true;
		orderObj.Payment_Terms__c=40;
		orderObj.Warranty_Term_In_Year__c=1;
		orderObj.Freight_Terms__c='Borne by Customer';
		orderObj.GST_Certificate_Provided__c = true;
		orderObj.GST_No__c = '06AABCN6808R1ZX';
		orderObj.PAN_No__c = 'AABCN6808R';
		orderObj.CIN_No__c = 'U44003MH1945PLC004403';
		orderObj.Delivery_Period__c = '3-4 weeks';
		orderObj.PAN_Card_Provided__c = false;
		orderObj.Advance_less_than_Payment_Term_committed__c = false;
		orderObj.OwnerId = userObj.Id;
		update orderObj;

		orderObj = TestDataFactory.createTestOrder(account.Id);
		orderObj.name = 'Test 2';
		orderObj.Status='PO Draft';
		orderObj.EffectiveDate=Date.today();
		orderObj.SBQQ__Quote__c=quote.Id;
		orderObj.PO_Received__c=true;
		orderObj.Credit_Approval_Check_Required__c=true;
		orderObj.GST_Certificate_Provided__c=false;
		orderObj.TCS_Declaration_Form_Provided__c=true;
		orderObj.PAN_Card_Provided__c=true;
		orderObj.Payment_Terms__c=1;
		orderObj.Warranty_Term_In_Year__c=2;
		orderObj.Freight_Terms__c='Borne by IFB';
		orderObj.GST_Certificate_Provided__c = true;
		orderObj.GST_No__c = '06AABCN6808R1ZX';
		orderObj.PAN_No__c = 'AABCN6808R';
		orderObj.CIN_No__c = 'U44003MH1945PLC004403';
		orderObj.Delivery_Period__c = '3-4 weeks';
		orderObj.Installation_Level__c = 'Ground';
		orderObj.OwnerId = userObj.Id;
		update orderObj;

		orderObj = TestDataFactory.createTestOrder(account.Id);
		orderObj.name = 'Test 4';
		orderObj.Status='PO Draft';
		orderObj.EffectiveDate=Date.today();
		orderObj.PO_Received__c=true;
		orderObj.Credit_Approval_Check_Required__c=true;
		orderObj.GST_Certificate_Provided__c=false;
		orderObj.TCS_Declaration_Form_Provided__c=true;
		orderObj.PAN_Card_Provided__c=true;
		orderObj.Payment_Terms__c=1;
		orderObj.Warranty_Term_In_Year__c=2;
		orderObj.Freight_Terms__c='Borne by IFB';
		orderObj.GST_Certificate_Provided__c = true;
		orderObj.GST_No__c = '06AABCN6808R1ZX';
		orderObj.PAN_No__c = 'AABCN6808R';
		orderObj.CIN_No__c = 'U44003MH1945PLC004403';
		orderObj.Delivery_Period__c = '3-4 weeks';
		orderObj.Installation_Level__c = 'Ground';
		orderObj.OwnerId = userObj.Id;
		orderObj.Advance_Received_Amount__c = null;
		update orderObj;

		opp = TestDataFactory.createOpportunityForAccount(account.Id,'Prospecting', userObj);
		SBQQ__Quote__c quote1 = TestDataFactory.createQuote(opp);
		quote1.Freight_Includes__c = 'Included in the Quote';
		quote1.SBQQ__Opportunity2__c=opp.Id;
		quote1.SBQQ__Primary__c=true;
		quote1.Payment_Term__c=40;
		quote1.WarrantyTerm_In_Year__c=1;
		quote1.Freight_Terms__c='Borne by Customer';
		update quote1;

		Order order = TestDataFactory.createTestOrderConditionaly(account.Id, false);
		order.Name='Test Order AAAAA';
		order.AccountId=account.Id;
		order.Status='PO Draft';
		order.EffectiveDate=Date.today();
		order.SBQQ__Quote__c=quote.Id;
		order.PO_Received__c=true;
		order.Credit_Approval_Check_Required__c=true;
		order.GST_Certificate_Provided__c=true;
		order.TCS_Declaration_Form_Provided__c=true;
		order.PAN_Card_Provided__c=true;
		order.Payment_Terms__c=40;
		order.Warranty_Term_In_Year__c=1;
		order.Freight_Terms__c='Borne by Customer';
		order.Advance_less_than_Payment_Term_committed__c=false;
		insert order;

		Test.stopTest();
	}

	@IsTest
	public static void testClassMethod(){

		Map<String,Order> mapOfOrders = new Map<String,Order>();
		for(Order orderObj : [SELECT Id, Name From Order WHERE name != 'Test Order AAAAA']){
			mapOfOrders.put(orderObj.Name, orderObj);
		}

		Order orderObj = mapOfOrders.get('Test 1');
		POValidationService.ResponseWrapper result = POValidationService.validatePO(orderObj.Id ,true);
		System.assertEquals(8, result.validationErrors.size());
		orderObj = mapOfOrders.get('Test 3');
		result = POValidationService.validatePO(orderObj.Id  ,true);
		System.assertEquals(2, result.validationErrors.size());
		orderObj = mapOfOrders.get('Test 2');
		result = POValidationService.validatePO(orderObj.Id ,true);
		System.assertEquals(5, result.validationErrors.size());
		POValidationService.validatePO('123' ,true);
		Order tempOrder = new Order();
		result = POValidationService.validatePO(tempOrder.Id ,true);
		System.assertEquals(1, result.validationErrors.size());
		Account accObj = [SELECT Id From Account Limit 1];
		result = POValidationService.validatePO(accObj.Id ,true);
		System.assertEquals(1, result.validationErrors.size());
		orderObj = mapOfOrders.get('Test 4');
		result = POValidationService.validatePO(orderObj.Id ,true);
		System.assertEquals(2, result.validationErrors.size());

	}

	@IsTest
	static void testValidatePO_QueueableJobNotTriggered() {
		Test.startTest();
		Order order = [SELECT Id, Advance_less_than_Payment_Term_committed__c, Freight_Terms__c,
		Warranty_Term_In_Year__c, Payment_Terms__c, PAN_Card_Provided__c
		, TCS_Declaration_Form_Provided__c, GST_Certificate_Provided__c,
		Credit_Approval_Check_Required__c, PO_Received__c, SBQQ__Quote__c, EffectiveDate, Status, AccountId, Name From Order WHERE name = 'Test Order AAAAA' Limit 1];

		POValidationService.ResponseWrapper result = POValidationService.validatePO(order.Id ,true);
		POValidationService.updateOrder(order.Id);
		Test.stopTest();
		System.assertEquals(4, result.validationErrors.size());
		System.assertEquals(0, Limits.getQueueableJobs());
	}
}