@isTest
private class baft_TriggerRequest {
    @isTest
    private static void regressionCoverage() {
        Test.startTest();
        baf_TriggerRequest beforeTriggerRequest = new baf_TriggerRequest(Account.getSObjectType())
            .SetBefore(true)
            .SetAfter(false)
            .SetInsert(true)
            .SetUpdate(false)
            .SetDelete(false)
            .SetNewRecords(new List<Account>())
            .SetNewRecordMap(new Map<Id, Account>())
            .SetOldRecords(new List<Account>())
            .SetOldRecordMap(new Map<Id, Account>());
        baf_ServiceRequest svc = new baf_ServiceRequest().WithParam(
            'baf_TriggerRequest', 
            beforeTriggerRequest
        );
        baf_TriggerRequest afterTriggerRequest = baf_TriggerRequest.FromSvcRequest(svc);
        baf_TriggerProcess tp = afterTriggerRequest.triggerProcess;

        System.assertEquals(beforeTriggerRequest.isBefore, afterTriggerRequest.isBefore);
        System.assertEquals(beforeTriggerRequest.isAfter, afterTriggerRequest.isAfter);
        System.assertEquals(beforeTriggerRequest.isInsert, afterTriggerRequest.isInsert);
        System.assertEquals(beforeTriggerRequest.isUpdate, afterTriggerRequest.isUpdate);
        System.assertEquals(beforeTriggerRequest.isDelete, afterTriggerRequest.isDelete);
        System.assertEquals(beforeTriggerRequest.newRecords, afterTriggerRequest.newRecords);
        System.assertEquals(beforeTriggerRequest.newRecordMap, afterTriggerRequest.newRecordMap);
        System.assertEquals(beforeTriggerRequest.oldRecords, afterTriggerRequest.oldRecords);
        System.assertEquals(beforeTriggerRequest.oldRecordMap, afterTriggerRequest.oldRecordMap);

        afterTriggerRequest.SetUpdate(true);
        afterTriggerRequest.SetInsert(false);
        String proc = afterTriggerRequest.process;
        afterTriggerRequest.SetUpdate(false);
        afterTriggerRequest.SetDelete(true);
        String proc2 = afterTriggerRequest.process;
        
        Test.stopTest();
    }
}
