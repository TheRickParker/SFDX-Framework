@isTest
private class baft_DomainCoverage {
    @isTest
    private static void regressionCoverage() {
        Test.startTest();
        // build trigger request
        baf_TriggerRequest testTriggerRequest = new baf_TriggerRequest(Account.getSObjectType())
            .SetBefore(true)
            .SetInsert(true)
            .SetNewRecords(new List<Account>())
            .SetNewRecordMap(new Map<Id, Account>());
        
        // call SObjectDomain
        new baf_SObjectDomain(testTriggerRequest).ExecuteTriggerActions();
        Test.stopTest();
    }

    private class testDomainActionOne extends baf_DomainActionBase {
        public override void ProcessAction(baf_TriggerRequest request) {
            if (request.targetSobject != Account.getSObjectType() || !request.isBefore || !request.isInsert) { return; }
            // actual data manipulation would happen here to suit the trigger's needs
        }
    }

    private class testDomainActionTwo extends baf_DomainActionBase {
        public override void ProcessAction(baf_TriggerRequest request) {
            if (request.targetSobject != Account.getSObjectType() || !request.isBefore || !request.isInsert) { return; }
            // actual data manipulation would happen here to suit the trigger's needs
        }
    }
}