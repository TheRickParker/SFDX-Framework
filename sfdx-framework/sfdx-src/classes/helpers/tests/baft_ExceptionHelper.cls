@isTest
private class baft_ExceptionHelper {
    @isTest
    private static void regressionCoverage() {

        Test.startTest();

        String test1 = baf_ExceptionHelper.Format(new baf.CriteriaException('test 1'));
        String test2 = baf_ExceptionHelper.FormatVerbose(new baf.CriteriaException('test 2'));

        Test.stopTest();
    }
}