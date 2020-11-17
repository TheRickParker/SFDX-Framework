@IsTest
private class baft_SchemaHelper {
    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        DescribeSObjectResult objectResult = baf_SchemaHelper.GetDescribe(Account.getSObjectType());
        DescribeFieldResult fieldResult = baf_SchemaHelper.GetDescribe(Account.Id);
        List<Integer> fieldHashesResult = baf_SchemaHelper.GetFieldHashes(Account.getSObjectType());
        Id generatedIdResult = baf_SchemaHelper.GenerateIdFor(Account.getSObjectType());
        Boolean userIsSetupObject = baf_SchemaHelper.IsSetupSObject(User.getSObjectType());
        Test.stopTest();
    }
}