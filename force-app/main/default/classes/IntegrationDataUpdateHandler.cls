public class IntegrationDataUpdateHandler {

    public static void updateRecordsBasedOnResponse(String objectType, String jsonResponse) {
        try {
            List<ResponseWrapper> responseList = (List<ResponseWrapper>) JSON.deserialize(jsonResponse, List<ResponseWrapper>.class);
            List<SObject> recordsToUpdate = new List<SObject>();
            for (ResponseWrapper response : responseList) {
                if (response.success) {
                    SObject record;
                    switch on objectType {
                        when 'Lead' {
                            record = new Lead(Id = response.id,is_Send_To_OMS__c = true);
                        }
                        when 'Account' {
                            record = new Account(Id = response.id,is_Send_To_OMS__c = true);
                        }
                        when 'Contact' {
                            record = new Contact(Id = response.id,is_Send_To_OMS__c = true);
                        }
                        when else {
                            throw new IllegalArgumentException('Unsupported object type: ' + objectType);
                        }
                    }
                    recordsToUpdate.add(record);
                }
            }
            if (!recordsToUpdate.isEmpty()) {
                update recordsToUpdate;
            }
        } catch (Exception e) {
            System.debug('Error in updateRecordsBasedOnResponse: ' + e.getMessage());
        }
    }
    public class ResponseWrapper {
        public String id;
        public Boolean success;
    }
}