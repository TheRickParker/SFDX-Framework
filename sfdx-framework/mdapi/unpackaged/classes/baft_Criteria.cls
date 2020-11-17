@isTest
private class baft_Criteria {
    @isTest
    private static void regressionCoverage() {
        Schema.SObjectField idField = Account.Id;
        Schema.SObjectField dateField = Contact.Birthdate;
        Schema.SObjectField dateTimeField = Contact.CreatedDate;
        Schema.SObjectField numberField = Account.NumberOfEmployees;
        Schema.SObjectField booleanField = Contact.DoNotCall;
        Schema.SObjectField stringField = Contact.Name;
        String idFieldName = idField.getDescribe().getName();
        String dateFieldName = dateField.getDescribe().getName();
        String dateTimeFieldName = dateTimeField.getDescribe().getName();
        String numberFieldName = numberField.getDescribe().getName();
        String booleanFieldName = booleanField.getDescribe().getName();
        String stringFieldName = stringField.getDescribe().getName();

        Id testAccountId = baf_SchemaHelper.GenerateIdFor(Account.getSObjectType());
        Date testDate = System.Date.today();
        DateTime testDateTime = System.DateTime.now();
        Integer testNumber = 3;
        Boolean testBoolean = false;
        String testNameOne = 'Tom';
        Set<String> stringSet = new Set<String> {
                testNameOne, 'Brenda', 'Alice'
        };
        Set<Id> idSet = new Set<Id> {
                baf_SchemaHelper.GenerateIdFor(Account.getSObjectType()),
                baf_SchemaHelper.GenerateIdFor(Account.getSObjectType())
        };
        Set<Date> dateSet = new Set<Date> {
                testDate, testDate.addDays(-1)
        };
        Set<DateTime> dateTimeSet = new Set<DateTime> {
                testDateTime, testDateTime.addDays(-2)
        };
        Set<Decimal> decimalSet = new Set<Decimal> {
                0.1, 1.1, 2.1
        };
        Set<Integer> integerSet = new Set<Integer> {
                1, 2, 3, 5, 8
        };
        List<String> stringList = new List<String>(stringSet);
        List<Id> idList = new List<Id>(idSet);
        List<Date> dateList = new List<Date>(dateSet);
        List<DateTime> dateTimeList = new List<DateTime>(dateTimeSet);
        List<Decimal> decimalList = new List<Decimal>(decimalSet);
        List<Integer> integerList = new List<Integer>(integerSet);
        Set<Object> objectSet = new Set<Object>();
        for (String str : stringSet) {
            objectSet.add((Object)str);
        }
        List<Object> objectList = new List<Object>(objectSet);

        Test.startTest();

        System.assertEquals( baf_Criteria.AndCriterias( new List<baf_iCriteria> {
                baf_Criteria.Equals( idField, testAccountId )
                , baf_Criteria.Equals( stringField, testNameOne )
        } ).ForSoql()
                , '(' + idFieldName + ' = \'' + testAccountId + '\' AND ' + stringFieldName + ' = \'' + testNameOne + '\')' );

        System.assertEquals( baf_Criteria.OrCriterias( new List<baf_iCriteria> {
                baf_Criteria.Equals( stringField, 'Bob' )
                , baf_Criteria.Equals( stringField, testNameOne )
        } ).ForSoql()
                , '(' + stringFieldName + ' = \'Bob\' OR ' + stringFieldName + ' = \'' + testNameOne + '\')' );

        System.assertEquals( baf_Criteria.Equals( stringField, (Object) stringList[0] ).ForSoql()
                , stringFieldName + ' = ' + baf_SoqlHelper.FormatForSoql( stringField, (Object) stringList[0] ) );

        System.assertEquals( baf_Criteria.Equals( idField, idList[0] ).ForSoql()
                , idFieldName + ' = ' + baf_SoqlHelper.FormatForSoql( idField, idList[0] ) );

        System.assertEquals( baf_Criteria.Equals( stringField, stringList[0] ).ForSoql()
                , stringFieldName + ' = ' + baf_SoqlHelper.FormatForSoql( stringField, stringList[0] ) );

        System.assertEquals( baf_Criteria.Equals( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' = ' + baf_SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( baf_Criteria.Equals( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' = ' + baf_SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( baf_Criteria.Equals( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' = ' + baf_SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( baf_Criteria.Equals( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' = ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.NotEquals( stringField, (Object) stringList[0] ).ForSoql()
                , stringFieldName + ' != ' + baf_SoqlHelper.FormatForSoql( stringField, stringList[0] ) );

        System.assertEquals( baf_Criteria.NotEquals( idField, idList[0] ).ForSoql()
                , idFieldName + ' != ' + baf_SoqlHelper.FormatForSoql( idField, idList[0] ) );

        System.assertEquals( baf_Criteria.NotEquals( stringField, stringList[0] ).ForSoql()
                , stringFieldName + ' != ' + baf_SoqlHelper.FormatForSoql( stringField, stringList[0] ) );

        System.assertEquals( baf_Criteria.NotEquals( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' != ' + baf_SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( baf_Criteria.NotEquals( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' != ' + baf_SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( baf_Criteria.NotEquals( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' != ' + baf_SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( baf_Criteria.NotEquals( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' != ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.GreaterThan( numberField, (Object) integerList[0] ).ForSoql()
                , numberFieldName + ' > ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.GreaterThan( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' > ' + baf_SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( baf_Criteria.GreaterThan( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' > ' + baf_SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( baf_Criteria.GreaterThan( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' > ' + baf_SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( baf_Criteria.GreaterThan( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' > ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.LessThan( numberField, (Object) integerList[0] ).ForSoql()
                , numberFieldName + ' < ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.LessThan( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' < ' + baf_SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( baf_Criteria.LessThan( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' < ' + baf_SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( baf_Criteria.LessThan( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' < ' + baf_SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( baf_Criteria.LessThan( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' < ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.GreaterThanOrEquals( numberField, (Object) integerList[0] ).ForSoql()
                , numberFieldName + ' >= ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.GreaterThanOrEquals( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' >= ' + baf_SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( baf_Criteria.GreaterThanOrEquals( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' >= ' + baf_SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( baf_Criteria.GreaterThanOrEquals( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' >= ' + baf_SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( baf_Criteria.GreaterThanOrEquals( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' >= ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.LessThanOrEquals( numberField, (Object) integerList[0] ).ForSoql()
                , numberFieldName + ' <= ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.LessThanOrEquals( dateField, dateList[0] ).ForSoql()
                , dateFieldName + ' <= ' + baf_SoqlHelper.FormatForSoql( dateField, (Object) String.valueOf(dateList[0]) ) );

        System.assertEquals( baf_Criteria.LessThanOrEquals( dateTimeField, dateTimeList[0] ).ForSoql()
                , dateTimeFieldName + ' <= ' + baf_SoqlHelper.FormatForSoql( dateTimeField, (Object) String.valueOf(dateTimeList[0]) ) );

        System.assertEquals( baf_Criteria.LessThanOrEquals( numberField, decimalList[0] ).ForSoql()
                , numberFieldName + ' <= ' + baf_SoqlHelper.FormatForSoql( numberField, decimalList[0] ) );

        System.assertEquals( baf_Criteria.LessThanOrEquals( numberField, integerList[0] ).ForSoql()
                , numberFieldName + ' <= ' + baf_SoqlHelper.FormatForSoql( numberField, integerList[0] ) );

        System.assertEquals( baf_Criteria.ValueIn( stringField, objectSet ).ForSoql()
                , stringFieldName + ' IN ' + convertToString( stringField, objectSet ) );

        System.assertEquals( baf_Criteria.ValueIn( idField, idSet ).ForSoql()
                , idFieldName + ' IN ' + convertToString( idField, idSet ) );

        System.assertEquals( baf_Criteria.ValueIn( stringField, stringSet ).ForSoql()
                , stringFieldName + ' IN ' + convertToString( stringField, stringSet ) );

        System.assertEquals( baf_Criteria.ValueIn( dateField, dateSet ).ForSoql()
                , dateFieldName + ' IN ' + convertToString( dateField, dateSet ) );

        System.assertEquals( baf_Criteria.ValueIn( dateTimeField, dateTimeSet ).ForSoql()
                , dateTimeFieldName + ' IN ' + convertToString( dateTimeField, dateTimeSet ) );

        System.assertEquals( baf_Criteria.ValueIn( numberField, decimalSet ).ForSoql()
                , numberFieldName + ' IN ' + convertToString( numberField, decimalSet ) );

        System.assertEquals( baf_Criteria.ValueIn( numberField, integerSet ).ForSoql()
                , numberFieldName + ' IN ' + convertToString( numberField, integerSet ) );

        System.assertEquals( baf_Criteria.ValueIn( stringField, objectList ).ForSoql()
                , stringFieldName + ' IN ' + convertToString( stringField, objectList ) );

        System.assertEquals( baf_Criteria.ValueIn( idField, idList ).ForSoql()
                , idFieldName + ' IN ' + convertToString( idField, idList ) );

        System.assertEquals( baf_Criteria.ValueIn( stringField, stringList ).ForSoql()
                , stringFieldName + ' IN ' + convertToString( stringField, stringSet ) );

        System.assertEquals( baf_Criteria.ValueIn( dateField, dateList ).ForSoql()
                , dateFieldName + ' IN ' + convertToString( dateField, dateList ) );

        System.assertEquals( baf_Criteria.ValueIn( dateTimeField, dateTimeList ).ForSoql()
                , dateTimeFieldName + ' IN ' + convertToString( dateTimeField, dateTimeList ) );

        System.assertEquals( baf_Criteria.ValueIn( numberField, decimalList ).ForSoql()
                , numberFieldName + ' IN ' + convertToString( numberField, decimalList ) );

        System.assertEquals( baf_Criteria.ValueIn( numberField, integerList ).ForSoql()
                , numberFieldName + ' IN ' + convertToString( numberField, integerList ) );

        System.assertEquals( baf_Criteria.ValueNotIn( stringField, objectSet ).ForSoql()
                , stringFieldName + ' NOT IN ' + convertToString( stringField, objectSet ) );

        System.assertEquals( baf_Criteria.ValueNotIn( idField, idSet ).ForSoql()
                , idFieldName + ' NOT IN ' + convertToString( idField, idSet ) );

        System.assertEquals( baf_Criteria.ValueNotIn( stringField, stringSet ).ForSoql()
                , stringFieldName + ' NOT IN ' + convertToString( stringField, stringSet ) );

        System.assertEquals( baf_Criteria.ValueNotIn( dateField, dateSet ).ForSoql()
                , dateFieldName + ' NOT IN ' + convertToString( dateField, dateSet ) );

        System.assertEquals( baf_Criteria.ValueNotIn( dateTimeField, dateTimeSet ).ForSoql()
                , dateTimeFieldName + ' NOT IN ' + convertToString( dateTimeField, dateTimeSet ) );

        System.assertEquals( baf_Criteria.ValueNotIn( numberField, decimalSet ).ForSoql()
                , numberFieldName + ' NOT IN ' + convertToString( numberField, decimalSet ) );

        System.assertEquals( baf_Criteria.ValueNotIn( numberField, integerSet ).ForSoql()
                , numberFieldName + ' NOT IN ' + convertToString( numberField, integerSet ) );

        System.assertEquals( baf_Criteria.ValueNotIn( stringField, objectList ).ForSoql()
                , stringFieldName + ' NOT IN ' + convertToString( stringField, objectList ) );

        System.assertEquals( baf_Criteria.ValueNotIn( idField, idList ).ForSoql()
                , idFieldName + ' NOT IN ' + convertToString( idField, idList ) );

        System.assertEquals( baf_Criteria.ValueNotIn( stringField, stringList ).ForSoql()
                , stringFieldName + ' NOT IN ' + convertToString( stringField, stringSet ) );

        System.assertEquals( baf_Criteria.ValueNotIn( dateField, dateList ).ForSoql()
                , dateFieldName + ' NOT IN ' + convertToString( dateField, dateList ) );

        System.assertEquals( baf_Criteria.ValueNotIn( dateTimeField, dateTimeList ).ForSoql()
                , dateTimeFieldName + ' NOT IN ' + convertToString( dateTimeField, dateTimeList ) );

        System.assertEquals( baf_Criteria.ValueNotIn( numberField, decimalList ).ForSoql()
                , numberFieldName + ' NOT IN ' + convertToString( numberField, decimalList ) );

        System.assertEquals( baf_Criteria.ValueNotIn( numberField, integerList ).ForSoql()
                , numberFieldName + ' NOT IN ' + convertToString( numberField, integerList ) );

        System.assertEquals( baf_Criteria.BeginsWith( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' LIKE \'' + testNameOne + '%\'' );

        System.assertEquals( baf_Criteria.Contains( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' LIKE \'%' + testNameOne + '%\'' );

        System.assertEquals( baf_Criteria.EndsWith( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' LIKE \'%' + testNameOne + '\'' );

        System.assertEquals( baf_Criteria.DoesNotBeginWith( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' NOT LIKE \'' + testNameOne + '%\'' );

        System.assertEquals( baf_Criteria.DoesNotContain( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' NOT LIKE \'%' + testNameOne + '%\'' );

        System.assertEquals( baf_Criteria.DoesNotEndWith( stringField, testNameOne ).ForSoql()
                , stringFieldName + ' NOT LIKE \'%' + testNameOne + '\'' );

        System.assertEquals( baf_Criteria.IsNull( stringField ).ForSoql()
                , stringFieldName + baf_Criteria.EQUAL_TO + baf_Criteria.NULL_TXT
                , 'Distance between strings should be 0. Actual is: '
                        + baf_Criteria.IsNull( stringField ).ForSoql()
                        .getLevenshteinDistance(stringFieldName + baf_Criteria.EQUAL_TO + baf_Criteria.NULL_TXT));

        System.assertEquals( baf_Criteria.IsNotNull( stringField ).ForSoql()
                , stringFieldName + baf_Criteria.NOT_EQUAL + baf_Criteria.NULL_TXT
                , 'Distance between strings should be 0. Actual is: '
                        + baf_Criteria.IsNotNull( stringField ).ForSoql()
                        .getLevenshteinDistance(stringFieldName + baf_Criteria.NOT_EQUAL + baf_Criteria.NULL_TXT));

        Test.stopTest();
    }

    private static String convertToString(Schema.SObjectField field, Set<Id> values) {
        List<Object> objects = new List<Object>();
        for (Id value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<Object> values) {
        List<Object> objects = new List<Object>();
        for (Object value : values) { objects.add(value); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<String> values) {
        List<Object> objects = new List<Object>();
        for (String value : values) { objects.add((Object) value); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<Date> values) {
        List<Object> objects = new List<Object>();
        for (Date value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<DateTime> values) {
        List<Object> objects = new List<Object>();
        for (DateTime value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<Decimal> values) {
        List<Object> objects = new List<Object>();
        for (Decimal value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, Set<Integer> values) {
        List<Object> objects = new List<Object>();
        for (Integer value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }

    private static String convertToString(Schema.SObjectField field, List<Id> values) {
        List<Object> objects = new List<Object>();
        for (Id value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<Object> values) {
        return baf_SoqlHelper.FormatListForMatching( field, values );
    }
    private static String convertToString(Schema.SObjectField field, List<String> values) {
        List<Object> objects = new List<Object>();
        for (String value : values) { objects.add((Object) value); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<Date> values) {
        List<Object> objects = new List<Object>();
        for (Date value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<DateTime> values) {
        List<Object> objects = new List<Object>();
        for (DateTime value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<Decimal> values) {
        List<Object> objects = new List<Object>();
        for (Decimal value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
    private static String convertToString(Schema.SObjectField field, List<Integer> values) {
        List<Object> objects = new List<Object>();
        for (Integer value : values) { objects.add((Object) String.valueOf(value)); }
        return baf_SoqlHelper.FormatListForMatching( field, objects );
    }
}