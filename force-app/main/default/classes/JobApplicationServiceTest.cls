@isTest
private class JobApplicationServiceTest {

    @isTest
    static void testGetStaleApplications_returnsOnlyStaleApplied() {
        // Stale: Applied, 20 days ago
        Job_Application__c staleApp = new Job_Application__c(
            Name = 'Stale Co',
            Status__c = 'Applied',
            Applied_Date__c = Date.today().addDays(-20)
        );

        // Not stale: Applied, only 2 days ago
        Job_Application__c freshApp = new Job_Application__c(
            Name = 'Fresh Co',
            Status__c = 'Applied',
            Applied_Date__c = Date.today().addDays(-2)
        );

        // Not stale: old date, but status is Offer, not Applied
        Job_Application__c offerApp = new Job_Application__c(
            Name = 'Offer Co',
            Status__c = 'Offer',
            Applied_Date__c = Date.today().addDays(-30)
        );

        insert new List<Job_Application__c>{ staleApp, freshApp, offerApp };

        Test.startTest();
        List<Job_Application__c> staleResults = JobApplicationService.getStaleApplications();
        Integer staleCount = JobApplicationService.getStaleApplicationCount();
        Test.stopTest();

        System.assertEquals(1, staleResults.size(), 'Only one application should be considered stale');
        System.assertEquals('Stale Co', staleResults[0].Name, 'The stale application should be Stale Co');
        System.assertEquals(1, staleCount, 'Stale count should match the stale results size');
    }

    @isTest
    static void testGetStaleApplications_noRecords_returnsEmptyList() {
        Test.startTest();
        List<Job_Application__c> results = JobApplicationService.getStaleApplications();
        Test.stopTest();

        System.assertEquals(0, results.size(), 'No applications exist, so the result should be empty');
    }
}