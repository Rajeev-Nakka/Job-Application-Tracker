public with sharing class JobApplicationService {

    public static List<Job_Application__c> getStaleApplications() {
        Date staleThreshold = Date.today().addDays(-14);

        return [
            SELECT Id, Name, Role_c__c, Status__c,
                   Applied_Date__c, Days_Since_Applied__c
            FROM Job_Application__c
            WHERE Status__c = 'Applied'
            AND Applied_Date__c <= :staleThreshold
            ORDER BY Applied_Date__c ASC
        ];
    }

    public static Integer getStaleApplicationCount() {
        return getStaleApplications().size();
    }

    @AuraEnabled(cacheable=true)
    public static List<Job_Application__c> getAllApplications() {
        return [
            SELECT Id, Name, Role_c__c, Status__c,
                   Applied_Date__c, Follow_Up_Date__c, Days_Since_Applied__c
            FROM Job_Application__c
            WITH SECURITY_ENFORCED
            ORDER BY Applied_Date__c DESC NULLS LAST
        ];
    }

    @AuraEnabled
    public static void updateStatus(Id applicationId, String newStatus) {
        Job_Application__c app = new Job_Application__c(
            Id = applicationId,
            Status__c = newStatus
        );
        update as user app;
    }
}