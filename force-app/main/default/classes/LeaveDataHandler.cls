public without sharing class LeaveDataHandler {

    public static void sendLeaveRequest(List<String> empCodes, Integer weeksInPast, Integer weeksInFuture) {
        try {
            Integration_Handler__mdt intHandlerInst = Integration_Handler__mdt.getInstance(ConstantUtilities.LEAVE_UPDATE);
            String requestJson = buildRequestJson(empCodes, weeksInPast, weeksInFuture);
    
            HttpRequest req = new HttpRequest();
            req.setEndpoint(intHandlerInst.URL__c);
            req.setMethod(intHandlerInst.Http_Method__c);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setHeader('Authorization', 'Bearer '+ intHandlerInst.Static_Token_Value__c);
            req.setTimeout(120000);
            req.setBody(requestJson);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                insert Utilities.getInfoLog('LeaveDataHandler' , 'sendLeaveRequest', requestJson,'Status Code-'+res.getStatusCode()+' \n Body-'+res.getBody()); 
                String jsonResponse = res.getBody();
                handleLeaveData(jsonResponse);
            } else {
                throw new CalloutException('Error in response: ' + res.getStatus());
            }
        } catch (Exception e) {
             System.debug(e);
             insert Utilities.getExceptionErrorLog('LeaveDataHandler', 'sendLeaveRequest', e);
        }
    }

        public static String buildRequestJson(List<String> empCodes, Integer weeksInPast, Integer weeksInFuture) {
        try {
            Map<String, Object> requestBody = new Map<String, Object>();
    
            if (!empCodes.isEmpty()) {
                requestBody.put(ConstantUtilities.EMP_CODES, empCodes);
            }
    
            Date fromDate = Date.today().addDays(-(weeksInPast * 7));
            Date toDate = Date.today().addDays(weeksInFuture * 7);
    
            // Updated the format to remove the 'Z' at the end
            String formattedFromDate = DateTime.newInstance(fromDate, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd\'T\'HH:mm:ss');
            String formattedToDate = DateTime.newInstance(toDate, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd\'T\'HH:mm:ss');
            
            requestBody.put(ConstantUtilities.TO_DATE, formattedToDate);
            requestBody.put(ConstantUtilities.FROM_DATE, formattedFromDate);
    
            return JSON.serialize(requestBody);
        } catch (Exception e) {
            insert Utilities.getExceptionErrorLog('LeaveDataHandler', 'buildRequestJson', e);
            return null;
        }
    }

    public static void handleLeaveData(String jsonResponse) {
        try {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
            List<Object> leaveDataList = (List<Object>) responseMap.get(ConstantUtilities.DATA);

            if (leaveDataList != null && !leaveDataList.isEmpty()) {
                List<Event> eventsToInsert = new List<Event>();

                for (Object leaveEntry : leaveDataList) {
                    Map<String, Object> leaveData = (Map<String, Object>) leaveEntry;

                    Event eventRecord = new Event();
                    eventRecord.IsAllDayEvent = true;
                    eventRecord.DurationInMinutes = 1440;
                    eventRecord.Subject = ConstantUtilities.LEAVE;
                    eventRecord.Type = ConstantUtilities.LEAVE;

                    Map<String, String> fieldMappings = new Map<String, String>();
                    Map<String, String> fieldDataTypeMap = new Map<String, String>();

                    List<API_Configuration__c> mappings = [
                        SELECT JSON_Key__c, Field_API_Name__c, Data_Type__c
                        FROM API_Configuration__c
                        WHERE API_Type__c = :ConstantUtilities.LEAVE_UPDATE
                    ];

                    for (API_Configuration__c mapping : mappings) {
                        fieldMappings.put(mapping.JSON_Key__c, mapping.Field_API_Name__c);
                        fieldDataTypeMap.put(mapping.JSON_Key__c, mapping.Data_Type__c);
                    }

                    for (String jsonKey : fieldMappings.keySet()) {
                        String salesforceField = fieldMappings.get(jsonKey);
                        if (leaveData.containsKey(jsonKey)) {
                            Object fieldValue = leaveData.get(jsonKey);
                            String fieldType = fieldDataTypeMap.get(jsonKey);
                            assignFieldValue(eventRecord, salesforceField, fieldValue, fieldType);
                        }
                    }

                    eventsToInsert.add(eventRecord);
                }

                if (!eventsToInsert.isEmpty()) {
                    upsertEvents(eventsToInsert);
                }
            }
        } catch (Exception e) {
            insert Utilities.getExceptionErrorLog('LeaveDataHandler', 'handleLeaveData', e);
        }
    }

    private static void assignFieldValue(Event eventRecord, String salesforceField, Object value, String fieldType) {
        try {
            if (value != null) {
                if (fieldType == ConstantUtilities.DATE_STRING) {
                    String valueDate = String.valueOf(value);
                    Date dateTimeValue = Date.valueOf(valueDate.split('T')[0]);
                    eventRecord.put(salesforceField, dateTimeValue);
                } else if (fieldType == ConstantUtilities.INTEGER_STRING) {
                    eventRecord.put(salesforceField, Integer.valueOf(value));
                } else {
                    eventRecord.put(salesforceField, value);
                }
            }
        } catch (Exception e) {
            insert Utilities.getExceptionErrorLog('LeaveDataHandler', 'assignFieldValue', e);
        }
    }

    public static void upsertEvents(List<Event> eventList) {
        try {
            if (eventList == null || eventList.isEmpty()) {
                return;
            }

            Set<String> employeeCodes = new Set<String>();
            Set<Date> activityDates = new Set<Date>();
            Map<String, Event> eventInputMap = new Map<String, Event>();

            for (Event ev : eventList) {
                String uniqueKey = ev.Employee_Code__c + '-' + ev.Type + '-' + String.valueOf(ev.ActivityDate);
                employeeCodes.add(ev.Employee_Code__c);
                activityDates.add(ev.ActivityDate);
                eventInputMap.put(uniqueKey, ev);
            }

            Map<String, Event> existingEventsMap = new Map<String, Event>();
            List<Event> existingEvents = [
                SELECT Id, Employee_Code__c, Type, ActivityDate, Leave_Status__c
                FROM Event
                WHERE Employee_Code__c IN :employeeCodes
                AND Type = :ConstantUtilities.LEAVE
                AND ActivityDate IN :activityDates
            ];

            for (Event existingEvent : existingEvents) {
                String uniqueKey = existingEvent.Employee_Code__c + '-' + existingEvent.Type + '-' + String.valueOf(existingEvent.ActivityDate);
                existingEventsMap.put(uniqueKey, existingEvent);
            }

            List<Event> eventsToUpdate = new List<Event>();
            List<Event> eventsToInsert = new List<Event>();

            for (String key : eventInputMap.keySet()) {
                if (existingEventsMap.containsKey(key) && existingEventsMap.get(key).Leave_Status__c != eventInputMap.get(key).Leave_Status__c) {
                    Event existingEvent = existingEventsMap.get(key);
                    existingEvent.Leave_Status__c = eventInputMap.get(key).Leave_Status__c;
                    eventsToUpdate.add(existingEvent);
                } else {
                    eventsToInsert.add(eventInputMap.get(key));
                }
            }

            if (!eventsToInsert.isEmpty()) {
                insert eventsToInsert;
            }

            if (!eventsToUpdate.isEmpty()) {
                update eventsToUpdate;
            }
        } catch (Exception e) {
            insert Utilities.getExceptionErrorLog('LeaveDataHandler', 'upsertEvents', e);
        }
    }

}