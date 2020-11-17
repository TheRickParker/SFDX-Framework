@IsTest
private class baft_ObjectHelper {
    @IsTest
    private static void regressionCoverage() {
        Test.startTest();

        String result1 = baf_ObjectHelper.ConvertToNumberForSoql(42);
        String result2 = baf_ObjectHelper.ConvertToBooleanForSoql(true);
        String result3 = baf_ObjectHelper.ConvertToDateForSoql(DateTime.now().date());
        String result4 = baf_ObjectHelper.ConvertToDateTimeForSoql(DateTime.now());
        String result5 = baf_ObjectHelper.ConvertToStringForSoql(99);

        Test.stopTest();
    }
}