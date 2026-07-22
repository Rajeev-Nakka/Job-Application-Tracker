trigger JobApplicationTrigger on Job_Application__c (before insert, before update) {
    for (Job_Application__c app : Trigger.new) {
        if (app.Applied_Date__c != null) {
            app.Days_Since_Applied__c = app.Applied_Date__c.daysBetween(Date.today());
        } else {
            app.Days_Since_Applied__c = null;
        }
    }
}