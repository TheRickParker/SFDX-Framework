@IsTest
private class baft_LogHandler {
    @IsTest
    private static void regressionCoverage() {
        baf.App.Logger.Log(System.LoggingLevel.INFO, 'test manual');
        baf.App.Logger.Debug('test Debug');
        baf.App.Logger.Error(new baf.CriteriaException('Exception log test'));
        baf.App.Logger.Warning('test Warning');
        baf.App.Logger.Info('test Info');
    }
}