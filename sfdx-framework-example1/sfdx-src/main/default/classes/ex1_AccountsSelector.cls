public inherited sharing class ex1_AccountsSelector extends baf_SObjectSelector {
    public ex1_AccountsSelector() { super(Account.getSObjectType()); }
    
    public override Set<Schema.SObjectField> GetDefaultFields() {
        return new Set<Schema.SObjectField> {
            Account.Id,
            Account.Name,
            Account.Description
        };
    }

    public List<Account> GetById(Set<Id> idSet) {
        return (List<Account>) super.queryById(idSet);
    }

    public List<Account> GetByName(String name) {
        return (List<Account>) super.queryByName(name);
    }

    public List<Account> GetAll() {
        return (List<Account>) super.queryAll();
    }

    public List<Account> GetSome(Integer rowLimit) {
        return (List<Account>) super.querySome(rowLimit);
    }
}
