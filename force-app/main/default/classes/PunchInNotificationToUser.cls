public without sharing class PunchInNotificationToUser implements Schedulable {

    public static void notifyUsersWithoutHoliday() {
        try {
            DateTime todayDateTime = (DateTime) Date.today();
            String dayOfWeek = todayDateTime.format('E');
            
            if (dayOfWeek == ConstantUtilities.DAY_SUN) {
                return;
            }

            Set<Id> userSet = getUsersWithHolidayOrLeave();
            handleAttendanceForUsers(userSet);
            sendNotifications(userSet);

        } catch (Exception e) {
            ExceptionHandler.logException('PunchInNotificationToUser', 'notifyUsersWithoutHoliday', e);
        }
    }

    public static Set<Id> getUsersWithHolidayOrLeave() {
        Set<Id> userSet = new Set<Id>();
        Set<String> publicGroupNames = new Set<String>();
        Map<Id, String> groupHolidayMap = new Map<Id, String>();
        
        try {
            List<Event> todayEvents = [
                SELECT Owner.Name, OwnerId, Type, Subject, Leave_Status__c, StartDateTime, EndDateTime
                FROM Event
                WHERE (Type = :ConstantUtilities.EVENT_TYPE_LEAVE OR Type = :ConstantUtilities.EVENT_TYPE_HOLIDAY)
                AND ActivityDate = TODAY
            ];

            for (Event event : todayEvents) {
                if (event.Type == ConstantUtilities.EVENT_TYPE_LEAVE && event.Leave_Status__c == ConstantUtilities.EVENT_LEAVE_STATUS) {
                    userSet.add(event.OwnerId);
                }

                if (event.Type == ConstantUtilities.EVENT_TYPE_HOLIDAY) {
                    String publicGroupName = event.Owner.Name + '_Group';
                    publicGroupNames.add(publicGroupName);
                    groupHolidayMap.put(event.OwnerId, event.Subject);
                }
            }

            if (!publicGroupNames.isEmpty()) {
                List<GroupMember> groupMembers = [
                    SELECT UserOrGroupId
                    FROM GroupMember
                    WHERE Group.Name IN :publicGroupNames
                ];

                for (GroupMember member : groupMembers) {
                    userSet.add(member.UserOrGroupId);
                }
            }
        } catch (Exception e) {
            ExceptionHandler.logException('PunchInNotificationToUser', 'getUsersWithHolidayOrLeave', e);
        }

        return userSet;
    }

    public static void handleAttendanceForUsers(Set<Id> userSet) {
        try {
            List<Attendance__c> existingAttendances = [
                SELECT Id, OwnerId, Subjects__c, Type__c
                FROM Attendance__c
                WHERE CreatedDate = TODAY
            ];

            Map<Id, Attendance__c> userAttendanceMap = new Map<Id, Attendance__c>();
            for (Attendance__c attendance : existingAttendances) {
                userAttendanceMap.put(attendance.OwnerId, attendance);
            }

            List<Attendance__c> attendanceRecordsToInsert = new List<Attendance__c>();
            List<Attendance__c> attendanceRecordsToUpdate = new List<Attendance__c>();

            for (Id userId : userSet) {
                if (userAttendanceMap.containsKey(userId)) {
                    Attendance__c existingAttendance = userAttendanceMap.get(userId);
                    existingAttendance.Subjects__c = ConstantUtilities.EVENT_TYPE_HOLIDAY;
                    existingAttendance.Type__c = ConstantUtilities.EVENT_TYPE_HOLIDAY;
                    attendanceRecordsToUpdate.add(existingAttendance);
                } else {
                    Attendance__c newAttendance = new Attendance__c();
                    newAttendance.OwnerId = userId;
                    newAttendance.Subjects__c = ConstantUtilities.EVENT_TYPE_HOLIDAY;
                    newAttendance.Type__c = ConstantUtilities.EVENT_TYPE_HOLIDAY;
                    attendanceRecordsToInsert.add(newAttendance);
                }
            }

            if (!attendanceRecordsToInsert.isEmpty()) {
                insert attendanceRecordsToInsert;
            }

            if (!attendanceRecordsToUpdate.isEmpty()) {
                update attendanceRecordsToUpdate;
            }

        } catch (Exception e) {
            ExceptionHandler.logException('PunchInNotificationToUser', 'handleAttendanceForUsers', e);
        }
    }

    public static void sendNotifications(Set<Id> userSet) {
        try {
            CustomNotificationType notificationType = [
                SELECT Id
                FROM CustomNotificationType
                WHERE DeveloperName = :ConstantUtilities.FREQUENTLY_NOTIFICATION 
                LIMIT 1
            ];

            List<User> usersWithoutHoliday = [
                SELECT Id, Name, Profile.Name 
                FROM User 
                WHERE Id NOT IN :userSet
                AND Profile.Name Not IN ('Call center users', 'CEO', 'System Administrator') AND isActive = true
            ];

            IFB_Notification__mdt notificationData = IFB_Notification__mdt.getInstance(ConstantUtilities.PUNCH_IN_NOTIFICATION_DATA);

            for (User user : usersWithoutHoliday) {
                notify(user.Id, notificationType.Id, user.Id, notificationData);
            }

        } catch (Exception e) {
            ExceptionHandler.logException('PunchInNotificationToUser', 'sendNotifications', e);
        }
    }

    public static void notify(Id ownerId, Id notificationTypeId, Id targetId, IFB_Notification__mdt notificationData) {
        try {
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle(notificationData.Notification_Title__c);
            notification.setBody(notificationData.Notification_Body__c);
            notification.setNotificationTypeId(notificationTypeId);
            notification.setTargetPageRef(ConstantUtilities.PAGE_ATTENDANCE);
            notification.send(new Set<String>{ownerId});
        } catch (Exception e) {
            ExceptionHandler.logException('PunchInNotificationToUser', 'notify', e);
        }
    }
    
    public void execute(SchedulableContext sc) {
        PunchInNotificationToUser.notifyUsersWithoutHoliday();
    }
}