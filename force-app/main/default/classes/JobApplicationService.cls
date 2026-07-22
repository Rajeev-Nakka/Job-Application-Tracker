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
}