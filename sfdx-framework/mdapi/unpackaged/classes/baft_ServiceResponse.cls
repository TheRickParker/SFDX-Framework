@IsTest
private class baft_ServiceResponse {
    private static baf_ServiceRequest newTestableRequest(String variant) {
        baf_ServiceRequest req = new baf_ServiceRequest();
        req.Name = 'Test Request '+variant;
        req.Action = 'Do the test '+variant;
        req.Parameters = null;
        return req;
    }

    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        baf_ServiceResponse resp1 = new baf_ServiceResponse(newTestableRequest('1'));
        baf_ServiceResponse resp2 = new baf_ServiceResponse(newTestableRequest('2'), baf_RequestStatus.FAILURE);
        baf_ServiceResponse resp3 = new baf_ServiceResponse(newTestableRequest('3'), baf_RequestStatus.ERROR, new baf.CriteriaException('test'));
        baf_ServiceResponse resp4 = new baf_ServiceResponse(newTestableRequest('4'), baf_RequestStatus.SUCCESS, new Account());
        Test.stopTest();
    }
}