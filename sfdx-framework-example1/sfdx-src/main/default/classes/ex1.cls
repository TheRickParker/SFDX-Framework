// each package should have its own base class like this, which extends the highest level package base class inherited
// for example, this package directly inherits/extends the base application framework, so this class extends baf
// the next package up the stack which depends on ex1, would extend ex1 class... etc
public inherited sharing class ex1 extends baf {
    // SINGLETON HANDLING
    // each implementation should repeat this pattern, for easier usage/coding
    public ex1() {}
    private static ex1 m_instance;
    public static ex1 Pkg {
        get {
            if (m_instance != null) { return m_instance; }
            m_instance = new ex1();
            return m_instance;
        }
    }

    // global binding, using generic base class, can be overridden by inheriting packages
    // this should always be virtual, and allow being overridden by inheriting packages
    // use an additional property (below) to cast the binding to the known local instance
    // note that this separation of binding & retrieval also allows for mocking (IE: replacing the instance during tests)
    public virtual baf_SObjectSelector AccountsSelector() {
        return (baf_SObjectSelector) bindingFor( Account.SObjectType, ex1_AccountsSelector.class );
    }

    // local binding, for use by any code inside this package
    // access example: ex1.Accounts.GetById(idSet);
    public static ex1_AccountsSelector Accounts { get { return (ex1_AccountsSelector) Pkg.AccountsSelector(); } }
}
