@isTest
private class baft_StringHelper {
    @isTest
    private static void regressionCoverage() {
        String base = 'This is test ';
        String scenario1 = base + '1 scenario';
        String scenario2 = base + '2 scenario';
        String scenario1Answer = '1';
        Boolean scenario2Answer = true;
        Boolean scenario2Answer2 = false;
        String rightSelectionSource = 'This Is Tom';

        Test.startTest();

        String result1 = baf_StringHelper.CharAt(scenario1, base.length());
        Boolean result2 = baf_StringHelper.Contains(scenario2, '2');
        Boolean result3 = baf_StringHelper.Contains(scenario2, 'hello world');
        String result4 = baf_StringHelper.Right(rightSelectionSource, 3);
        String parmForResult = baf_StringHelper.ParamFor(Account.Id);
        String rando = baf_StringHelper.SelectRandom(new List<String> {
                'Hi',
                'Hello',
                'Howdy',
                'Yo'
                });

        Test.stopTest();

        System.assertEquals(result1, scenario1Answer);
        System.assertEquals(result2, scenario2Answer);
        System.assertEquals(result3, scenario2Answer2);
        System.assertEquals('Tom', result4);
    }
}