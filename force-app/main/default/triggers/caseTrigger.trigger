trigger caseTrigger on Case (before insert, before update) {
    if(Trigger.isInsert){
        System.debug('case trigger insert ran');
        CaseBusinessHours.newRecord(Trigger.new);
    }
    else{
        CaseBusinessHours.updateRecord(Trigger.old,Trigger.new);
    }
}