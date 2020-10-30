trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete) {
    new baf_SObjectDomain(new baf_TriggerRequest(Account.getSObjectType())).ExecuteTriggerActions();
}