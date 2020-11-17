/**
 * BASE class for all Actions that must take place in response to data changing on any SObject, via Triggers.
 * 
 * Please note that AFTER triggers CAN be configured, in the baf_DomainActionBinding__mdt custom-metadata type
 * to run ASYNC. However, you must keep in mind that Futures have their own limitations.
 * 
 * You do NOT need to do anything special to your code to make it run as a future, as that is handled
 * by baf_SObjectDomain on your behalf.
 */
public inherited sharing abstract class baf_DomainActionBase implements baf_iDomainAction {
    public baf_ServiceResponse Execute(baf_ServiceRequest request) {
        baf_ServiceResponse response = new baf_ServiceResponse(request);
        try {
            baf_TriggerRequest triggerRequest = baf_TriggerRequest.FromSvcRequest(request);
            ProcessAction(triggerRequest);
            response.Status = baf_RequestStatus.SUCCESS;
        } catch (Exception ex) {
            response.Status = baf_RequestStatus.ERROR;
            response.ThrownException = ex;
        }
        return response;
    }

    public abstract void ProcessAction(baf_TriggerRequest request);
}

/*<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 *<> EXAMPLE, MULTI-ACTION PARENT CLASS WITH SEVERAL NESTED CHILD CLASSES FOR EACH ACTION <>
 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

public inherited sharing class XXXX_AccountTriggers {
    public class FixName extends baf_DomainActionBase {
        public override void ProcessAction(baf_TriggerRequest request) {
            // safety check request.isBefore/isAfter and the other trigger properties to be sure this is proper
            // do stuff here for/with name
        }
    }

    public class FixEmail extends baf_DomainActionBase {
        public override void ProcessAction(baf_TriggerRequest request) {
            // safety check request.isBefore/isAfter and the other trigger properties to be sure this is proper
            // do stuff here for/with email
        }
    }
}

 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
 *<> EXAMPLE, MULTI-ACTION PARENT CLASS WITH SEVERAL NESTED CHILD CLASSES FOR EACH ACTION <>
 *<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>*/