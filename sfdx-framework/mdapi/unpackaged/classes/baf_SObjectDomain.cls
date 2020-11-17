/**
 * Domain core implementation.
 * This class executes on behalf of all triggers, mapping CMDT-bound DomainActions to the appropriate Trigger process.
 */
public with sharing class baf_SObjectDomain implements baf_iSObjectDomain {
    private baf_TriggerProcess triggerProcess;
    private baf_TriggerRequest request;
    private Boolean disableTrigger = false;

    public baf_SObjectDomain(baf_TriggerRequest triggerRequest) {
        request = triggerRequest;
        if (request == null) { disableTrigger = true; }
    }

    private Boolean TriggersDisabled() {
        if (disableTrigger) { return disableTrigger; }
        baf_TriggerConfig__c triggerConfig = baf_TriggerConfig__c.getInstance();
        return (triggerConfig != null && triggerConfig.DisableTriggers__c == true);
    }

    /**
     * Queries baf_DomainActionBinding__mdt to find all baf_DomainAction implementations
     * Then executes them in sequence, passing in the Trigger's state & data
     */
    public void ExecuteTriggerActions() {
        if (TriggersDisabled()) { return; }
        List<baf_DomainActionBinding__mdt> bindings = baf.App.DomainActionBindings().GetForTrigger(
            request.targetSObject.getDescribe().getName(), request.action, request.process
        );
        for (baf_DomainActionBinding__mdt binding : bindings) {
            String actionName = binding.DomainAction__c;
            if (String.isBlank(actionName)) { continue; }
            if (request.isAfter && binding.IsAsync__c == true) {
                ExecuteActionAsync(actionName, request.forAsync());
            } else {
                baf.Logger.Debug('[][] Domain Action Executing :: ' + actionName);
                try {
                    Type actionType = Type.forName(actionName);
                    baf_iDomainAction dynamicAction = (baf_iDomainAction) actionType.newInstance();
                    baf_ServiceResponse response = dynamicAction.Execute(
                        new baf_ServiceRequest(actionName, request.process + ' ' + request.action)
                            .WithParam(baf_TriggerRequest.SVC_REQUEST_KEY, request));
                    if (response.Status == baf_RequestStatus.ERROR) {
                        baf.Logger.Error(response.ThrownException);
                    }
                } catch(Exception ex) {
                    baf_LogHandler.Instance.Error(ex);
                    continue;
                }
            }
        }
    }

    @future
    private static void ExecuteActionAsync(String actionName, String serialRequest) {
        try {
            baf_TriggerRequest request = (baf_TriggerRequest) JSON.deserialize(serialRequest, baf_TriggerRequest.class);
            Type actionType = Type.forName(actionName);
            
            baf.Logger.Debug('[][] Domain Action Executing Async :: ' + actionName);

            baf_iDomainAction dynamicAction = (baf_iDomainAction) actionType.newInstance();
            baf_ServiceResponse response = dynamicAction.Execute(
                new baf_ServiceRequest(actionName, request.process + ' ' + request.action)
                    .WithParam(baf_TriggerRequest.SVC_REQUEST_KEY, request));
            if (response.Status == baf_RequestStatus.ERROR) {
                baf_LogHandler.Instance.Error(response.ThrownException);
            }
        } catch(Exception ex) {
            baf_LogHandler.Instance.Error(ex);
        }
    }
}