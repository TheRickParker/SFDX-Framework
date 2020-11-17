/**
 * Request object generated and sent by all .trigger classes into baf_SObjectDomain
 * Wraps all Trigger context data, so that baf_SObjectDomain can be executed manually via Unit Tests
 * 
 * Use Fluent Methods to insert data when outside of Trigger context
 */
public without sharing class baf_TriggerRequest {
    public static final String SVC_REQUEST_KEY = 'baf_TriggerRequest';

    public SObjectType targetSObject { get; set; }

    private Boolean m_isBefore;
    public Boolean isBefore {
        get {
            return Trigger.isExecuting ? Trigger.isBefore : m_isBefore;
        }
        set {
            m_isBefore = value;
        }
    }

    private Boolean m_isAfter;
    public Boolean isAfter { 
        get {
            return Trigger.isExecuting ? Trigger.isAfter : m_isAfter;
        }
        set {
            m_isAfter = value;
        }
    }

    private Boolean m_isInsert;
    public Boolean isInsert {
        get {
            return Trigger.isExecuting ? Trigger.isInsert : m_isInsert;
        }
        set {
            m_isInsert = value;
        }
    }

    private Boolean m_isUpdate;
    public Boolean isUpdate {
        get {
            return Trigger.isExecuting ? Trigger.isUpdate : m_isUpdate;
        }
        set {
            m_isUpdate = value;
        }
    }

    private Boolean m_isDelete;
    public Boolean isDelete {
        get {
            return Trigger.isExecuting ? Trigger.isDelete : m_isDelete;
        }
        set {
            m_isDelete = value;
        }
    }

    private List<SObject> m_newRecords;
    public List<SObject> newRecords {
        get {
            return Trigger.isExecuting ? Trigger.new : m_newRecords;
        }
        set {
            m_newRecords = value;
        }
    }

    private List<SObject> m_oldRecords;
    public List<SObject> oldRecords {
        get {
            return Trigger.isExecuting ? Trigger.old : m_oldRecords;
        }
        set {
            m_oldRecords = value;
        }
    }

    private Map<Id, SObject> m_newRecordMap;
    public Map<Id, SObject> newRecordMap {
        get {
            return Trigger.isExecuting ? Trigger.newMap : m_newRecordMap;
        }
        set {
            m_newRecordMap = value;
        }
    }

    private Map<Id, SObject> m_oldRecordMap;
    public Map<Id, SObject> oldRecordMap {
        get {
            return Trigger.isExecuting ? Trigger.isInsert ? null : Trigger.oldMap : m_oldRecordMap;
        }
        set {
            m_oldRecordMap = value;
        }
    }

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

    public String forAsync() {
        this.isAfter = this.isAfter;
        this.isBefore = this.isBefore;
        this.isInsert = this.isInsert;
        this.isUpdate = this.isUpdate;
        this.isDelete = this.isDelete;
        this.newRecordMap = this.newRecordMap;
        this.newRecords = this.newRecords;
        this.oldRecordMap = this.oldRecordMap;
        this.oldRecords = this.oldRecords;
        return JSON.serialize(this);
    }
}