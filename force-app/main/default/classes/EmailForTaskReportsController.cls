/*
@Author : Aman Sagar
@CreatedDate : 13th June 2024
@Description : Sending Email to User with the task & visit planned for next day.
*/
public class EmailForTaskReportsController {
    @InvocableMethod(label='Daily Reports')
    public static void dailyReport() {
        try{
            DateTime currentTime = DateTime.now();
        	Integer currentHour = currentTime.hour();
			Integer currentMinute = currentTime.minute();
			List<Task> listOfTasks  = new List<Task>();
			List<Visit> listOfVisits = new List<Visit>();
        	
			if(currentHour == ConstantUtilities.DAILY_HOUR){
				listOfTasks = [SELECT Id, ActivityDate, Description, Subject, OwnerId FROM Task WHERE ActivityDate = :Date.today() + 1];
        		listOfVisits = [SELECT Id, Account.Name, PlannedVisitStartTime, PlannedVisitEndTime, Summary__c, OwnerId FROM Visit WHERE DAY_ONLY(PlannedVisitStartTime) = :Date.today() + 1];
				
			}
			else if(currentHour == ConstantUtilities.WEEKLY_HOUR){
				listOfTasks = [SELECT Id, ActivityDate, Description, Subject, OwnerId FROM Task WHERE ActivityDate = NEXT_N_DAYS:7];
				listOfVisits = [SELECT Id, Account.Name, PlannedVisitStartTime, PlannedVisitEndTime, Summary__c, OwnerId FROM Visit WHERE PlannedVisitStartTime = NEXT_N_DAYS:7];
			}
			else if(currentHour == ConstantUtilities.MONTHLY_HOUR){
				Date firstDayOfMonth = Date.today().toStartOfMonth();
        		Date lastDayOfMonth = Date.today().addMonths(1).toStartofMonth().addDays(-1);

        		listOfTasks = [SELECT Id, ActivityDate, Description, Subject, OwnerId FROM Task WHERE ActivityDate >= :firstDayOfMonth AND ActivityDate <= :lastDayOfMonth];
        		listOfVisits = [SELECT Id, Account.Name, PlannedVisitStartTime, PlannedVisitEndTime, Summary__c, OwnerId FROM Visit WHERE PlannedVisitStartTime >= :firstDayOfMonth AND PlannedVisitStartTime <= :lastDayOfMonth];
			}
        
        	mapping(listOfTasks, listOfVisits);
        	}
		catch(Exception e){
             ExceptionHandler.logException('EmailForTaskReportsController' , 'FilteringRecordsOnTheBasicOfDayWeekMonth', e);
        }
		
    }

    @TestVisible
    private static void sendEmail(User user, List<Task> tasks, List<Visit> visits) {
		try{
            String subject = 'Summary of Tasks and Visits for Tomorrow';
        	String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        	String body = '<html><body>';
        	body += '<p>Hello ' + user.Name + ',</p>';

        	if (tasks != null && !tasks.isEmpty()) {
            	body += '<p>Here are your tasks:</p>';
            	body += '<table border="1" cellpadding="5" cellspacing="0">';
            	body += '<tr><th>Subject</th><th>Description</th><th>Due Date</th><th>Link</th></tr>';
            	for (Task task : tasks) {
                	String taskLink = baseUrl + '/' + task.Id;
                	body += '<tr>';
                	body += '<td>' + task.Subject + '</td>';
                	body += '<td>' + (task.Description != null ? task.Description : '') + '</td>';
                	body += '<td>' + (task.ActivityDate != null ? task.ActivityDate.format() : '') + '</td>';
                	body += '<td><a href="' + taskLink + '">View Task</a></td>';
                	body += '</tr>';
            	}
            	body += '</table>';
        	}
        	if (visits != null && !visits.isEmpty()) {
            	body += '<p>Here are your visits</p>';
            	body += '<table border="1" cellpadding="5" cellspacing="0">';
            	body += '<tr><th>Account</th><th>Start Time</th><th>End Time</th><th>Summary</th><th>Link</th></tr>';
            	for (Visit visit : visits) {
                	String visitLink = baseUrl + '/' + visit.Id;
                	body += '<tr>';
                	body += '<td>' + visit.Account.Name + '</td>';
                	body += '<td>' + (visit.PlannedVisitStartTime != null ? visit.PlannedVisitStartTime.format() : '') + '</td>';
                	body += '<td>' + (visit.PlannedVisitEndTime != null ? visit.PlannedVisitEndTime.format() : '') + '</td>';
                	body += '<td>' + (visit.Summary__c != null ? visit.Summary__c : '') + '</td>';
                	body += '<td><a href="' + visitLink + '">View Visit</a></td>';
                	body += '</tr>';
            	}
            	body += '</table>';
        	}

        	body += '<p>Best regards,<br/>Your Company</p>';
        	body += '</body></html>';

        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	mail.setToAddresses(new String[] { user.Email });
        	mail.setSubject(subject);
        	mail.setHtmlBody(body);
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        	}
		catch(Exception e){
            ExceptionHandler.logException('EmailForTaskReportsController' , 'SendingMailToUser', e);
        }
        
    }
	
	public static void mapping(List<Task> listOfTasks,List<Visit> listOfVisits ){
        try{
           List<User> userList = [SELECT Id, Email, Name FROM User];
        	Map<Id, List<Task>> userTaskMap = new Map<Id, List<Task>>();
        	Map<Id, List<Visit>> userVisitMap = new Map<Id, List<Visit>>();

        	for (Task tsk : listOfTasks) {
            	if (userTaskMap.containsKey(tsk.OwnerId)) {
                	userTaskMap.get(tsk.OwnerId).add(tsk);
            	} else {
                	List<Task> taskList = new List<Task>();
                	taskList.add(tsk);
                	userTaskMap.put(tsk.OwnerId, taskList);
            	}
        	}

        	for (Visit vst : listOfVisits) {
            	if (userVisitMap.containsKey(vst.OwnerId)) {
                	userVisitMap.get(vst.OwnerId).add(vst);
            	} else {
                	List<Visit> visitList = new List<Visit>();
                	visitList.add(vst);
                	userVisitMap.put(vst.OwnerId, visitList);
            	}
        	}

        	for (User user : userList) {
            	List<Task> userTasks = userTaskMap.get(user.Id);
            	List<Visit> userVisits = userVisitMap.get(user.Id);
            	if ((userTasks != null && !userTasks.isEmpty()) || (userVisits != null && !userVisits.isEmpty())) {
                	sendEmail(user, userTasks, userVisits);
            	}
        	}	 
        }
		catch(Exception e){
            ExceptionHandler.logException('EmailForTaskReportsController' , 'MappingUserWitTaskAndVisits', e);
            
        }
		
	}
}