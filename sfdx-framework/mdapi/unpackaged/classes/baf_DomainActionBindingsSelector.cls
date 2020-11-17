/**
 * Executes SOQL against baf_DomainActionBinding__mdt
 */
public without sharing class baf_DomainActionBindingsSelector extends baf_SObjectSelector {
    public baf_DomainActionBindingsSelector() { super(baf_DomainActionBinding__mdt.SObjectType); }

    // implement required GetDefaultFields() method
    public override Set<Schema.SObjectField> GetDefaultFields() {
        return new Set<Schema.SObjectField> {
            baf_DomainActionBinding__mdt.TriggeredSObject__c,
            baf_DomainActionBinding__mdt.TriggerStage__c,
            baf_DomainActionBinding__mdt.TriggerChange__c,
            baf_DomainActionBinding__mdt.DomainAction__c,
            baf_DomainActionBinding__mdt.Sequence__c,
            baf_DomainActionBinding__mdt.IsAsync__c
        };
    }

    // implement required GetDefaultOrderBy() method
    public override List<baf_iOrderBy> GetDefaultOrderBy() {
        return new List<baf_iOrderBy> {
            baf_OrderBy.Ascending(baf_DomainActionBinding__mdt.IsAsync__c),
            baf_OrderBy.Ascending(baf_DomainActionBinding__mdt.Sequence__c),
            baf_OrderBy.Ascending(baf_DomainActionBinding__mdt.DomainAction__c)
        };
    }

    /**
     * Query for retrieving Trigger-specific DomainAction bindings
     * @param  targetSObject String     The SObject the Trigger is executing on
     * @param  process       stage      Before/After
     * @param  action        action     Insert/Update/Delete
     * @return  List of baf_DomainActionBinding__mdt entries
     */
    public List<baf_DomainActionBinding__mdt> GetForTrigger(String targetSObject, String stage, String change) {
        baf_iQueryFactory qf = GetQueryFactory()
            .WithCriteria(baf_Criteria.Equals(baf_DomainActionBinding__mdt.TriggeredSObject__c, targetSObject))
            .WithCriteria(baf_Criteria.Equals(baf_DomainActionBinding__mdt.TriggerStage__c, stage))
            .WithCriteria(baf_Criteria.Equals(baf_DomainActionBinding__mdt.TriggerChange__c, change));
        // THE PROCESS BELOW SHOULD ONLY BE REPEATED FOR CMDT SOBJECTS
        // YOU CAN NOT INSERT CMDT DURING A UNIT TEST, SO THIS HACK LETS THE UNIT TESTS HAPPEN
        // DO NOT REPEAT THIS PATTERN IN A NORMAL SOBJECT SELECTOR
        if (Test.isRunningTest()) {
            String sObjectName = Account.getSObjectType().getDescribe().getName();
            return new List<baf_DomainActionBinding__mdt>{
                new baf_DomainActionBinding__mdt(
                    TriggeredSObject__c = sObjectName,
                    TriggerStage__c = 'Before',
                    TriggerChange__c = 'Insert',
                    DomainAction__c = 'baft_SObjectDomain.testDomainActionOne',
                    Sequence__c = 10
                ),
                new baf_DomainActionBinding__mdt(
                    TriggeredSObject__c = sObjectName,
                    TriggerStage__c = 'Before',
                    TriggerChange__c = 'Insert',
                    DomainAction__c = 'baft_SObjectDomain.testDomainActionOnenTwo',
                    Sequence__c = 10
                )
            };
        } else {
            return (List<baf_DomainActionBinding__mdt>) qf.Execute();
        }
    }
}