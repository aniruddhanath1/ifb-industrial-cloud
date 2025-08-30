public with sharing class blueSheetController {
    
    @AuraEnabled
    public static void saveblueSheetData(String payload) {
        try{
            Map<String, Object> payloadMap;
            try {
                payloadMap = (Map<String, Object>) JSON.deserializeUntyped(payload);
            } catch (Exception e) {
                throw new AuraHandledException('Error deserializing payload: ' + e.getMessage());
            }
            
            String opportunityId = (String) payloadMap.get('opportunityId');
            if (opportunityId == null) {
                throw new AuraHandledException('Opportunity ID is missing in the payload.');
            }
            
            List<BuyingInfluence> buyingInfluenceList = new List<BuyingInfluence>();
            List<IdealCustomer> idealCustomerList = new List<IdealCustomer>();
            List<Strength> strengthList = new List<Strength>();
            List<RedFlag> redFlagList = new List<RedFlag>();
            
            String buyingInfluenceJson = (String) payloadMap.get('buyingInfluenceList');
            String idealCustomerJson = (String) payloadMap.get('idealCustomerList');
            String strengthJson = (String) payloadMap.get('strengthList');
            String refFlagJson = (String) payloadMap.get('redFlagList');
            
            if (buyingInfluenceJson != null) {
                try {
                    buyingInfluenceList = (List<BuyingInfluence>) JSON.deserialize(buyingInfluenceJson, List<BuyingInfluence>.class);
                } catch (Exception e) {
                    throw new AuraHandledException('Error deserializing buyingInfluenceList: ' + e.getMessage());
                }
            }
            
            if (idealCustomerJson != null) {
                try {
                    idealCustomerList = (List<IdealCustomer>) JSON.deserialize(idealCustomerJson, List<IdealCustomer>.class);
                } catch (Exception e) {
                    throw new AuraHandledException('Error deserializing idealCustomerList: ' + e.getMessage());
                }
            }
            
            if (strengthJson != null) {
                try {
                    strengthList = (List<Strength>) JSON.deserialize(strengthJson, List<Strength>.class);
                } catch (Exception e) {
                    throw new AuraHandledException('Error deserializing idealCustomerList: ' + e.getMessage());
                }
            }
            if (refFlagJson != null) {
                try {
                    redFlagList = (List<RedFlag>) JSON.deserialize(refFlagJson, List<RedFlag>.class);
                } catch (Exception e) {
                    throw new AuraHandledException('Error deserializing idealCustomerList: ' + e.getMessage());
                }
            }
            // Get existing records for the given opportunityId
            Map<String, Blue_Sheet__c> existingRecords = new Map<String, Blue_Sheet__c>();
            
            for (Blue_Sheet__c bs : [
                SELECT Id, OpportunityId__c,Buying_Influences_Involved__c, Evidence_to_support_your_Rating__c, Ideal_Customer_Criteria__c
                FROM Blue_Sheet__c
                WHERE OpportunityId__c = :opportunityId
            ]) {
                existingRecords.put(bs.Id, bs);
            }
            List<Blue_Sheet__c> recordsToUpsert= new List<Blue_Sheet__c>();
            Set<String> idsToDelete = new Set<String>();
            for (BuyingInfluence bi : buyingInfluenceList) {
                if (bi != null) {
                    Blue_Sheet__c newRecord = new Blue_Sheet__c();
                    newRecord.OpportunityId__c = opportunityId;
                    newRecord.Type__c = bi.type;
                    
                    if(bi.buyingInfluences != ''){
                        newRecord.Buying_Influences_Involved__c = bi.buyingInfluences;
                    }
                    newRecord.Role__c = bi.role;
                    newRecord.Degree_Of_Influence__c = bi.degreeOfInfluence;
                    newRecord.Mode__c = bi.mode;
                    newRecord.Buying_Influence_Key_Win_Results__c = bi.winResult;
                    newRecord.Evidence_to_support_your_Rating__c = bi.evidence;
                    newRecord.Rating_5_to_5__c = bi.rating;
                    newRecord.Flag__c = bi.flag;
                    if(existingRecords.containsKey(bi.recId)){
                        newRecord.id = bi.recId;
                        recordsToUpsert.add(newRecord);
                    }else{
                        recordsToUpsert.add(newRecord);
                    }
                }
            }
           
            for (IdealCustomer ic : idealCustomerList) {
                if (ic != null) {
                    Blue_Sheet__c newRecord = new Blue_Sheet__c();
                    newRecord.OpportunityId__c = opportunityId;
                    newRecord.Type__c = ic.type;
                    newRecord.Ideal_Customer_Criteria__c = ic.idealCustomerCriteria;
                    newRecord.Match_to_Criteria_5_to_5__c = ic.matchCriteria;
                    newRecord.Flag__c = ic.flag;
                    if(existingRecords.containsKey(ic.recId)){
                        newRecord.id = ic.recId;
                        recordsToUpsert.add(newRecord);
                    }else{
                        recordsToUpsert.add(newRecord);
                    }
                }
            }
            for (Strength rec : strengthList) {
                if (rec != null) {
                    Blue_Sheet__c newRecord = new Blue_Sheet__c();
                    newRecord.OpportunityId__c = opportunityId;
                    newRecord.Type__c = rec.type;
                    newRecord.Summary_Of_My_Position_Today__c = rec.summryOfMyPosition;
                    newRecord.Possible_Actions__c = rec.possibleActions;
                    newRecord.What__c = rec.what;
                    if(rec.who != ''){
                        newRecord.Who__c = rec.who;
                    }
                    if(rec.whenDate != ''){
                        newRecord.When__c = Date.valueOf(rec.whenDate);
                    }
                    
                    if(existingRecords.containsKey(rec.recId)){
                        newRecord.id = rec.recId;
                        recordsToUpsert.add(newRecord);
                    }else{
                        recordsToUpsert.add(newRecord);
                    }
                }
            }
            for (RedFlag rec : redFlagList) {
                if (rec != null) {
                    Blue_Sheet__c newRecord = new Blue_Sheet__c();
                    newRecord.OpportunityId__c = opportunityId;
                    newRecord.Type__c = rec.type;
                    newRecord.Summary_Of_My_Position_Today__c = rec.summryOfMyPosition;
                    newRecord.Possible_Actions__c = rec.possibleActions;
                    newRecord.Information_Needed__c = rec.informationNeeded;
                    if(rec.fromWhom != ''){
                        newRecord.From_Whom__c = rec.fromWhom;
                    }
                    if(existingRecords.containsKey(rec.recId)){
                        newRecord.id = rec.recId;
                        recordsToUpsert.add(newRecord);
                    }else{
                        recordsToUpsert.add(newRecord);
                    }
                }
            }
            idsToDelete = existingRecords.keySet();
            if(!recordsToUpsert.isEmpty()){
                for(blue_Sheet__C rec : recordsToUpsert){
                    if(existingRecords.containsKey(rec.Id)){
                        idsToDelete.remove(rec.Id);
                    }
                }
            }
            if (!recordsToUpsert.isEmpty()) {
                upsert recordsToUpsert;
            }
            if (!idsToDelete.isEmpty()) {
                delete [SELECT Id FROM Blue_Sheet__c WHERE Id IN :idsToDelete];
            }
            
        }catch(Exception e){
            ExceptionHandler.logException('blueSheetController', 'saveblueSheetData', e);
        }
    }
    
    
    
    
    @AuraEnabled(cacheable=true)
    public static List<BlueSheetData> getBlueSheetData(String opportunityId) {
        List<BlueSheetData> blueSheetDataList = new List<BlueSheetData>();
        try{
            List<Blue_Sheet__c> blueSheets = [
                SELECT Id, OpportunityId__c, Role__c,Buying_Influences_Involved__c,Buying_Influence_Name__c, Degree_Of_Influence__c, Mode__c, Buying_Influence_Key_Win_Results__c, 
                Evidence_to_support_your_Rating__c, Rating_5_to_5__c, Ideal_Customer_Criteria__c, Match_to_Criteria_5_to_5__c,Type__c,Summary_Of_My_Position_Today__c,flag__c,
                Possible_Actions__c, What__c, Who__c, When__c,Information_Needed__c,From_Whom__c, who_Name__c, Whom_Name__c
                FROM Blue_Sheet__c
                WHERE OpportunityId__c = :opportunityId
            ];
            
            
            for (Blue_Sheet__c bs : blueSheets) {
                BlueSheetData data = new BlueSheetData();
                data.Ids = bs.Id;
                data.buyingInfluences = bs.Buying_Influences_Involved__c;
                if(bs.Buying_Influences_Involved__c != null){
                    data.buyingInfluences  = bs.Buying_Influences_Involved__c;
                    data.buyingInfluenceName = bs.Buying_Influence_Name__c;
                    data.selectedValue = true;  
                }
                data.role = bs.Role__c;
                data.degreeOfInfluence = bs.Degree_Of_Influence__c;
                data.mode = bs.Mode__c;
                data.winResult = bs.Buying_Influence_Key_Win_Results__c;
                data.evidence = bs.Evidence_to_support_your_Rating__c;
                data.rating = bs.Rating_5_to_5__c;
                data.idealCustomerCriteria = bs.Ideal_Customer_Criteria__c;
                data.matchCriteria = bs.Match_to_Criteria_5_to_5__c;
                data.type = bs.Type__c;
                data.summryOfMyPosition  = bs.Summary_Of_My_Position_Today__c;
                data.possibleActions  = bs.Possible_Actions__c;
                data.what  = bs.What__c;
                data.flag = bs.flag__c;
                if(bs.Who__c != null){
                    data.who  = bs.Who__c;
                    data.notifyName = bs.who_Name__c;
                    data.selectedValue = true;  
                }
                data.whenDate  = String.valueOf(bs.When__c);
                data.informationNeeded  = bs.Information_Needed__c;
                if(bs.From_Whom__c != null){
                    data.fromWhom  = bs.From_Whom__c;
                    data.notifyName = bs.Whom_Name__c;
                    data.selectedValue = true;  
                }
                blueSheetDataList.add(data);
            }
            
        }catch(Exception e){
            ExceptionHandler.logException('blueSheetController', 'getBlueSheetData', e);
        }
        
        return blueSheetDataList;
    }    
    
    public class BlueSheetData {
        @AuraEnabled public String Ids;
        @AuraEnabled public String buyingInfluences;
        @AuraEnabled public String buyingInfluenceName;
        @AuraEnabled public String role;
        @AuraEnabled public String degreeOfInfluence;
        @AuraEnabled public String mode;
        @AuraEnabled public String winResult;
        @AuraEnabled public String evidence;
        @AuraEnabled public String rating;
        @AuraEnabled public String idealCustomerCriteria;
        @AuraEnabled public String matchCriteria;
        @AuraEnabled public String type;
        @AuraEnabled public String summryOfMyPosition;
        @AuraEnabled public String possibleActions;
        @AuraEnabled public String what;
        @AuraEnabled public String who;
        @AuraEnabled public String whenDate;
        @AuraEnabled public String informationNeeded;
        @AuraEnabled public String fromWhom;
        @AuraEnabled public Boolean selectedValue;
        @AuraEnabled public String notifyName;
        @AuraEnabled public String flag;
        
        
    }
    public class BuyingInfluence {
        public String id;
        public String recId;
        public String type;
        public String buyingInfluences;
        public String role;
        public String degreeOfInfluence;
        public String mode;
        public String winResult;
        public String evidence;
        public String rating;
        public String flag;

    }
    
    
    public class IdealCustomer {
        public String id;
        public String recId;
        public String type;
        public String idealCustomerCriteria;
        public String matchCriteria;
        public String flag;
    }
    public class Strength {
        public String id;
        public String recId;
        public String type;
        public String summryOfMyPosition;
        public String possibleActions;
        public String what;
        public String who;
        public String whenDate;
    }
    public class RedFlag {
        public String id;
        public String recId;
        public String type;
        public String summryOfMyPosition;
        public String possibleActions;
        public String informationNeeded;
        public String fromWhom;
    }
}