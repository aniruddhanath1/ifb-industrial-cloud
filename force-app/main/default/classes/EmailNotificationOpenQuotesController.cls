public class EmailNotificationOpenQuotesController {
    @InvocableMethod(label='OpenQuotesNotification')
    public static void openQuotesReport() {
        try {
            DateTime currentTime = DateTime.now();
            Integer currentHour = (Integer) currentTime.hour();
            List<SBQQ__Quote__c> listOfQuotes = new List<SBQQ__Quote__c>();
            Set<Id> quotesOwnerIds = new Set<Id>();

            if (currentHour == ConstantUtilities.DAILY_HOUR || Test.isRunningTest()) {
                for (SBQQ__Quote__c quoteObject : [
                    SELECT Id, SBQQ__NetAmount__c, SBQQ__Account__r.Name, OwnerId, SBQQ__Status__c 
                    FROM SBQQ__Quote__c  WHERE SBQQ__Status__c != :ConstantUtilities.QUOTE_APPROVED 
                                                OR SBQQ__Status__c != :ConstantUtilities.QUOTE_REJECTED
                ]) {
                    listOfQuotes.add(quoteObject);
                    quotesOwnerIds.add(quoteObject.OwnerId);
                }
            }

            if (!listOfQuotes.isEmpty() && !quotesOwnerIds.isEmpty()) {
                leadDetailMapping(listOfQuotes, quotesOwnerIds);
            }
        } catch (Exception e) {
            ExceptionHandler.logException('EmailNotificationOpenQuotesController', 'openQuotesReport', e);
        }
    }
    public static void leadDetailMapping(List<SBQQ__Quote__c> listOfQuotes, Set<Id> quotesOwnerIds) {
        try {
            Map<Id, List<SBQQ__Quote__c>> userQuoteMap = new Map<Id, List<SBQQ__Quote__c>>();
            if (!quotesOwnerIds.isEmpty() && !listOfQuotes.isEmpty()) {
                List<User> userList = [
                    SELECT Id, Email, Name, ManagerId, Manager.Email 
                    FROM User WHERE Id IN :quotesOwnerIds
                ];
                for (SBQQ__Quote__c quoteObj : listOfQuotes) {
                    if (userQuoteMap.containsKey(quoteObj.OwnerId)) {
                        userQuoteMap.get(quoteObj.OwnerId).add(quoteObj);
                    } else {
                        userQuoteMap.put(quoteObj.OwnerId, new List<SBQQ__Quote__c>{quoteObj});
                    }
                }
                List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
                for (User user : userList) {
                    List<SBQQ__Quote__c> userQuotes = userQuoteMap.get(user.Id);
                    if (userQuotes != null && !userQuotes.isEmpty()) {
                        Messaging.SingleEmailMessage email = createEmail(user, userQuotes);
                        emailMessages.add(email);
                    }
                }
                if (!emailMessages.isEmpty()) {
                    Messaging.sendEmail(emailMessages);
                }
            }
        } catch (Exception e) {
            ExceptionHandler.logException('EmailNotificationOpenQuotesController', 'leadDetailMapping', e);
        }
    }
    private static Messaging.SingleEmailMessage createEmail(User user, List<SBQQ__Quote__c> listOfQuotes) {
        String subject = ConstantUtilities.QUOTE_EMAIL_SUBJECT;
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        String body = '<html><body>';
        body += '<p>Hello ' + user.Name + ',</p>';

        if (listOfQuotes != null && !listOfQuotes.isEmpty()) {
            body += '<p>Here are your Open Quotes:</p>';
            body += '<table border="1" cellpadding="5" cellspacing="0">';
            body += '<tr><th>Customer Name</th><th>Total Amount</th><th>Current Status</th><th>Link</th></tr>';

            for (SBQQ__Quote__c quoteObj : listOfQuotes) {
                String quoteLink = baseUrl + '/' + quoteObj.Id;
                body += '<tr>';
                body += '<td>' + quoteObj.SBQQ__Account__r.Name + '</td>';
                body += '<td>' + quoteObj.SBQQ__NetAmount__c + '</td>';
                body += '<td>' + quoteObj.SBQQ__Status__c + '</td>';
                body += '<td><a href="' + quoteLink + '">View Quote</a></td>';
                body += '</tr>';
            }
            body += '</table>';
        }
        body += '<p>Best regards,<br/>IFB</p>';
        body += '</body></html>';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{user.Email});
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        return mail;
    }
}