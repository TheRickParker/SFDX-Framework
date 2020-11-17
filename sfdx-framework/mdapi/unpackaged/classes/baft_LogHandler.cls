@IsTest
private class baft_LogHandler {
    @IsTest
    private static void regressionCoverage() {
        baf.Logger.Log(System.LoggingLevel.INFO, 'test manual');
        baf.Logger.Debug('test Debug');
        baf.Logger.Error(new baf.CriteriaException('Exception log test'));
        baf.Logger.Warning('test Warning');
        baf.Logger.Info('test Info');
    }
}