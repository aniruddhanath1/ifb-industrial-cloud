trigger LeadTrigger on Lead (before insert,after insert, before update, after update,before delete, after delete, after undelete) {
     system.debug('leadtrigger');
    if (Trigger_Setting__mdt.getInstance(ConstantUtilities.LEAD_TRIGGER_NAME)?.IsActive__c == true) {
        system.debug('leadtrigger');
        InterfaceTriggerHandler handler = new LeadTriggerHandler();
        switch on Trigger.operationType {
            when BEFORE_INSERT {
               handler.beforeInsert(Trigger.new);
            } 
            when BEFORE_UPDATE {
                 handler.beforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
            }
            when BEFORE_DELETE {
                // handler.beforeDelete(Trigger.old, Trigger.oldMap);
            }
            when AFTER_INSERT {
                 handler.afterInsert(Trigger.new, Trigger.newMap);
            }
            when AFTER_UPDATE {
                 handler.afterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
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