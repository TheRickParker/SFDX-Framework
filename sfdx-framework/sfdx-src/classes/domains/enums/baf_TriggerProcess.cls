/**
 * Enum for easier tracking of which Trigger operation is in process
 */
public enum baf_TriggerProcess {
    BeforeInsert,
    AfterInsert,
    BeforeUpdate,
    AfterUpdate,
    BeforeDelete,
    AfterDelete,
    Unknown
}
