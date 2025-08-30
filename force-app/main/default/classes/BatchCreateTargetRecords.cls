global class BatchCreateTargetRecords implements Database.Batchable<sObject> {

    private static final Integer NUM_HALF_YEARLY = 2;
    private static final Integer NUM_QUARTERLY = 4;
    private static final Integer NUM_MONTHLY = 12;
    private static final String YEARLY_TYPE = 'Yearly';
    private static final String HALF_YEARLY_TYPE = 'Half Yearly';
    private static final String QUARTERLY_TYPE = 'Quarterly';
    private static final String MONTHLY_TYPE = 'Monthly';
	private static final String ASM_PROFILE_NAME = 'ASM - Area Sales Manager';
	private static final String RSM_PROFILE_NAME = 'RSM - Regional Sales Manager';
	private static final String NSM_PROFILE_NAME = 'NSM - National Sales Manager';
	private static final String STATE_HEAD_PROFILE_NAME = 'State Head';
	private static final String CEO_PROFILE_NAME = 'CEO';
	private static final String COMMERCIAL_VALIDATOR_PROFILE_NAME = 'Commercial Validator';


	private static final Set<String> PROFILE_NAME_SET = new Set<String>{ '', '', '', '', '', '' };

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id
            FROM User
            WHERE IsActive = true
				AND ProfileId != ''
				AND (Profile.Name =: ASM_PROFILE_NAME
					OR Profile.Name =: RSM_PROFILE_NAME
					OR Profile.Name =: NSM_PROFILE_NAME
					OR Profile.Name =: STATE_HEAD_PROFILE_NAME
					OR Profile.Name =: CEO_PROFILE_NAME
					OR Profile.Name =: COMMERCIAL_VALIDATOR_PROFILE_NAME)
        ]);
    }

    global void execute(Database.BatchableContext BC, List<User> scope) {
        Integer currentYear = System.today().year();
        List<Target__c> targetsToInsert = new List<Target__c>();
        Map<String, Target__c> yearlyMap = new Map<String, Target__c>();
        Map<String, Target__c> halfYearlyMap = new Map<String, Target__c>();
        Map<String, Target__c> quarterlyMap = new Map<String, Target__c>();

        for (User u : scope) {
            Target__c yearlyTarget = new Target__c(
                Type__c = YEARLY_TYPE,
                Year__c = String.valueOf(currentYear),
                User__c = u.Id
            );
            targetsToInsert.add(yearlyTarget);

            for (Integer halfYear = 1; halfYear <= NUM_HALF_YEARLY; halfYear++) {
                Target__c halfYearlyTarget = createTarget(HALF_YEARLY_TYPE, halfYear, currentYear, u.Id);
                targetsToInsert.add(halfYearlyTarget);

                for (Integer quarter = 1; quarter <= NUM_QUARTERLY / NUM_HALF_YEARLY; quarter++) {
                    Integer quarterIndex = (halfYear - 1) * (NUM_QUARTERLY / NUM_HALF_YEARLY) + quarter;
                    Target__c quarterlyTarget = createTarget(QUARTERLY_TYPE, quarterIndex, currentYear, u.Id);
                    targetsToInsert.add(quarterlyTarget);

                    for (Integer month = 1; month <= NUM_MONTHLY / NUM_QUARTERLY; month++) {
                        Integer monthIndex = (quarterIndex - 1) * (NUM_MONTHLY / NUM_QUARTERLY) + month;
                        Target__c monthlyTarget = createTarget(MONTHLY_TYPE, monthIndex, currentYear, u.Id);
                        targetsToInsert.add(monthlyTarget);
                    }
                }
            }
        }

        if (!targetsToInsert.isEmpty()) {
            Database.insert(targetsToInsert);
        }
        for (Target__c target : targetsToInsert) {
            if (target.Type__c == YEARLY_TYPE) {
                yearlyMap.put(target.User__c, target);
            } else if (target.Type__c == HALF_YEARLY_TYPE) {
                halfYearlyMap.put(target.User__c + '_' + target.Sub_Type__c, target);
            } else if (target.Type__c == QUARTERLY_TYPE) {
                quarterlyMap.put(target.User__c + '_' + target.Sub_Type__c, target);
            }
        }

        List<Target__c> targetsToUpdate = new List<Target__c>();
        for (Target__c target : targetsToInsert) {
            if (target.Type__c == HALF_YEARLY_TYPE) {
                target.Parent_Target__c = yearlyMap.get(target.User__c).Id;
            } else if (target.Type__c == QUARTERLY_TYPE) {
                Integer quarter = Integer.valueOf(target.Sub_Type__c);
                Integer halfYear = (quarter + 1) / 2;
                target.Parent_Target__c = halfYearlyMap.get(target.User__c + '_' + halfYear).Id;
            } else if (target.Type__c == MONTHLY_TYPE) {
                Integer month = Integer.valueOf(target.Sub_Type__c);
                Integer quarter = (month + 2) / 3;
                target.Parent_Target__c = quarterlyMap.get(target.User__c + '_' + quarter).Id;
            }
            targetsToUpdate.add(target);
        }

        if (!targetsToUpdate.isEmpty()) {
            Database.update(targetsToUpdate);
        }
    }

    private Target__c createTarget(String type, Integer subType, Integer year, Id userId) {
        return new Target__c(
            Type__c = type,
            Sub_Type__c = String.valueOf(subType),
            Year__c = String.valueOf(year),
            User__c = userId
        );
    }

    global void finish(Database.BatchableContext BC) {
    }
}