@IsTest
private class baft_SelectorCoverage {
    private static Account testAcct(String name) {
        Account acct = new Account();
        acct.Name = name;
        return acct;
    }

    @IsTest
    private static void regressionCoverage() {
        Test.startTest();
        AccountSelector selector = new AccountSelector();
        Account acct1 = testAcct('Tom & Jerry');
        insert acct1;

        List<Account> results1 = selector.GetById(new Set<Id>{acct1.Id});
        List<Account> results2 = selector.GetByName(acct1.Name);
        List<Account> results3 = selector.GetAll();
        List<Account> results4 = selector.GetSome(10);

        Test.stopTest();
    }

    private class AccountSelector extends baf_SObjectSelector {
        public AccountSelector() {
            super(Account.SObjectType);
        }

        public override Set<SObjectField> GetDefaultFields() {
            return new Set<SObjectField>{
                    Account.Id,
                    Account.Name
            };
        }

        public List<Account> GetById(Set<Id> idSet) {
            return (List<Account>) queryById(idSet);
        }

        public List<Account> GetByName(String name) {
            return (List<Account>) queryByName(name);
        }

        public List<Account> GetAll() {
            return (List<Account>) queryAll();
        }

        public List<Account> GetSome(Integer rowLimit) {
            return (List<Account>) querySome(rowLimit);
        }
    }
}