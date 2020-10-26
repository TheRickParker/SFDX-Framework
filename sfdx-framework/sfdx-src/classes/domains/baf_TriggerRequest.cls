/**
 * Request object generated and sent by all .trigger classes into baf_SObjectDomain
 * Wraps all Trigger context data, so that baf_SObjectDomain can be executed manually via Unit Tests
 * 
 * Use Fluent Methods to insert data when outside of Trigger context
 */
public without sharing class baf_TriggerRequest {
    public static final String SVC_REQUEST_KEY = 'baf_TriggerRequest';

    public SObjectType targetSObject { get; set; }

    public Boolean isBefore { get; set; }
    public Boolean isAfter { get; set; }
    public Boolean isInsert { get; set; }
    public Boolean isUpdate { get; set; }
    public Boolean isDelete { get; set; }

    public List<SObject> newRecords { get; set; }
    public List<SObject> oldRecords { get; set; }

    public Map<Id, SObject> newRecordMap { get; set; }
    public Map<Id, SObject> oldRecordMap { get; set; }

    public String action { get { return isBefore ? 'Before' : 'After'; } }

    public String process {
        get {
            return isInsert ? 'Insert'
                    : isUpdate ? 'Update'
                    : isDelete ? 'Delete'
                    : 'Unknown';
        }
    }

    public baf_TriggerProcess triggerProcess {
        get {
            return isBefore
            ? isInsert ? baf_TriggerProcess.BeforeInsert 
                : isUpdate ? baf_TriggerProcess.BeforeUpdate
                : isDelete ? baf_TriggerProcess.BeforeDelete
                : baf_TriggerProcess.Unknown
            : isInsert ? baf_TriggerProcess.AfterInsert 
                : isUpdate ? baf_TriggerProcess.AfterUpdate
                : isDelete ? baf_TriggerProcess.AfterDelete
                : baf_TriggerProcess.Unknown;
        }
    }

    public baf_TriggerRequest(SObjectType target) {
        targetSObject = target;
        isBefore = false;
        isAfter = false;
        isInsert = false;
        isUpdate = false;
        isDelete = false;
        if (!Trigger.isExecuting) { return; }
        isBefore = Trigger.isBefore;
        isAfter = Trigger.isAfter;
        isInsert = Trigger.isInsert;
        isUpdate = Trigger.isUpdate;
        isDelete = Trigger.isDelete;
        newRecords = Trigger.new;
        newRecordMap = Trigger.newMap;
        if (Trigger.isInsert) { return; }
        oldRecords = Trigger.old;
        oldRecordMap = Trigger.oldMap;
    }

    public baf_TriggerRequest SetBefore(Boolean state) { isBefore = state; return this; }
    public baf_TriggerRequest SetAfter(Boolean state) { isAfter = state; return this; }
    public baf_TriggerRequest SetInsert(Boolean state) { isInsert = state; return this; }
    public baf_TriggerRequest SetUpdate(Boolean state) { isUpdate = state; return this; }
    public baf_TriggerRequest SetDelete(Boolean state) { isDelete = state; return this; }
    public baf_TriggerRequest SetNewRecords(List<SObject> data) { newRecords = data; return this; }
    public baf_TriggerRequest SetNewRecordMap(Map<Id, SObject> data) { newRecordMap = data; return this; }
    public baf_TriggerRequest SetOldRecords(List<SObject> data) { oldRecords = data; return this; }
    public baf_TriggerRequest SetOldRecordMap(Map<Id, SObject> data) { oldRecordMap = data; return this; }

    public static baf_TriggerRequest FromSvcRequest(baf_ServiceRequest svc) {
        if (!svc.Parameters.containsKey(SVC_REQUEST_KEY)) { return null; }
        Object val = svc.Parameters.get(SVC_REQUEST_KEY);
        if (val instanceOf baf_TriggerRequest) { return (baf_TriggerRequest) val; }
        return null;
    }
}
