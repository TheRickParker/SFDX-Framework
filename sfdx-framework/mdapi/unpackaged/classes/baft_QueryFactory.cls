@isTest
private class baft_QueryFactory {
    @isTest
    private static void regressionCoverage() {
        Schema.SObjectType testSObject = Account.getSObjectType();
        Set<Schema.SObjectField> testFields = new Set<Schema.SObjectField> {
                Account.Id,
                Account.Name
        };
        List<Schema.SObjectField> testFieldList = new List<Schema.SObjectField>(testFields);
        List<baf_iOrderBy> testOrdering = new List<baf_iOrderBy> {
                baf_OrderBy.Ascending(Account.Name),
                baf_OrderBy.Descending(Account.Id)
        };
        Integer rowLimit = 10;
        String testAccountName = 'Tim "The Enchanter"';
        String soqlBase = 'SELECT Id, Name FROM Account';
        String soqlWhere = ' WHERE Name = \'' + testAccountName + '\'';
        String soqlOrder = ' ORDER BY Name ASC, Id DESC';
        String query1 = soqlBase + soqlOrder;
        String query2 = soqlBase + soqlWhere + soqlOrder;
        String query3 = query2 + ' LIMIT 10';

        Test.startTest();

        baf_QueryFactory qfOther = new baf_QueryFactory(Contact.getSObjectType());
        qfOther.withField(Contact.Id)
                .withField(Contact.Name)
                .orderAscending(Contact.Name)
                .orderDescending(Contact.Id);

        baf_QueryFactory qfWithoutFieldsOrSort = new baf_QueryFactory(testSObject);
        baf_QueryFactory qfWithoutSort = new baf_QueryFactory(testSObject, testFields);
        baf_QueryFactory qfWithoutFields = new baf_QueryFactory(testSObject, testOrdering);
        baf_QueryFactory qf = new baf_QueryFactory(testSObject, testFields, testOrdering);
        baf_QueryFactory qfWithRelatedFields = new baf_QueryFactory(Contract.getSObjectType()
                , new Set<Schema.SObjectField> {
                        Contract.Id,
                        Contract.AccountId,
                        Contract.Name
                }
                , new List<baf_iOrderBy> {
                        baf_OrderBy.Ascending(Contract.Name)
                });
        qfWithRelatedFields.WithRelatedField(Contract.AccountId, Account.Id);

        qfWithoutFieldsOrSort.WithFields(testFieldList).WithOrderBys(testOrdering);
        qfWithoutFields.WithFields(testFieldList);
        qfWithoutSort.WithOrderBys(testOrdering);

        String soql1 = qfWithoutFieldsOrSort.GenerateSoql();
        String soql2 = qfWithoutSort.GenerateSoql();
        String soql3 = qfWithoutFields.GenerateSoql();
        String soql4 = qf.GenerateSoql();
        String soql99 = qfWithRelatedFields.GenerateSoql();

        qfWithoutFieldsOrSort.withCriteria(baf_Criteria.Equals(Account.Name, testAccountName));
        qfWithoutSort.withCriteria(baf_Criteria.Equals(Account.Name, testAccountName));
        qfWithoutFields.withCriteria(baf_Criteria.Equals(Account.Name, testAccountName));
        qf.withCriteria(baf_Criteria.Equals(Account.Name, testAccountName));

        String soql5 = qfWithoutFieldsOrSort.GenerateSoql();
        String soql6 = qfWithoutSort.GenerateSoql();
        String soql7 = qfWithoutFields.GenerateSoql();
        String soql8 = qf.GenerateSoql();

        qfWithoutFieldsOrSort.WithRowLimit(rowLimit);
        qfWithoutSort.WithRowLimit(rowLimit);
        qfWithoutFields.WithRowLimit(rowLimit);
        qf.WithRowLimit(rowLimit);

        String soql9 = qfWithoutFieldsOrSort.GenerateSoql();
        String soql10 = qfWithoutSort.GenerateSoql();
        String soql11 = qfWithoutFields.GenerateSoql();
        String soql12 = qf.GenerateSoql();

        String soql13 = qf.WithChildQuery(qfOther.clearExistingOrder()).GenerateSoql();

        Test.stopTest();

        System.assertEquals(query1, soql1);
        System.assertEquals(query1, soql2);
        System.assertEquals(query1, soql3);
        System.assertEquals(query1, soql4);

        System.assertEquals(query2, soql5);
        System.assertEquals(query2, soql6);
        System.assertEquals(query2, soql7);
        System.assertEquals(query2, soql8);

        System.assertEquals(query3, soql9);
        System.assertEquals(query3, soql10);
        System.assertEquals(query3, soql11);
        System.assertEquals(query3, soql12);

        System.assertEquals(true, soql13.indexOf('Contact') > 0);
    }
}