@IsTest
private class baft_ServiceRequest {
    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        baf_ServiceRequest req = new baf_ServiceRequest();
        req.Name = 'Test Request';
        req.Action = 'Do the test';
        req.Parameters = null;

        baf_ServiceRequest req2 = new baf_ServiceRequest('1', '2');
        
        baf_ServiceRequest req3 = new baf_ServiceRequest('1', '2', new Map<String, Object>());
        Test.stopTest();
    }
}