/*
@Author : Yadram
@CreatedDate : 26 Aug 2024
@Description : Appropriate Method on Handler invoked based on trigger context. 
*/
trigger ContactTrigger on Contact (before insert,after insert, before update, after update,before delete, after delete, after undelete) {
 if (Trigger_Setting__mdt.getInstance(ConstantUtilities.CONTACT_TRIGGER_NAME)?.IsActive__c == true) {
        InterfaceTriggerHandler handler = new ContactTriggerHandler();
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                handler.beforeInsert( Trigger.new);
            } 
            when BEFORE_UPDATE {
                handler.beforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
            when BEFORE_DELETE {
                // handler.beforeDelete(Trigger.old, Trigger.oldMap);
            }
            when AFTER_INSERT {
                  // handler.beforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                 
                  handler.afterInsert(Trigger.new, Trigger.newMap);
            }
            when AFTER_UPDATE {
                  // handler.beforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
            when AFTER_DELETE {
                // handler.afterDelete(Trigger.old, Trigger.oldMap);
            } 
            when AFTER_UNDELETE {
                // handler.afterUndelete(Trigger.new, Trigger.newMap);
            }
        }
    }
}