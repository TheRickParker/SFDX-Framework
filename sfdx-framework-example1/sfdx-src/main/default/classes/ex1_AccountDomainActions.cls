public with sharing class ex1_AccountDomainActions {
    public class UpdateDescription extends baf_DomainActionBase {
        public override void ProcessAction(baf_TriggerRequest request) {
            // kick out if this is a delete operation, or an AFTER operation
            if (!request.isBefore || request.isDelete) { return; }
            // arbitrary update to descr field, just to show trigger operation in action
            for (Account record : (List<Account>) request.newRecords) {
                record.Description = record.Name + ' updated on ' + String.valueOf(DateTime.now());
            }
        }
    }
}
