public class POApprovalProcessQueueable implements Queueable {
    private Id orderId;
    
    public POApprovalProcessQueueable(Id orderId) {
        this.orderId = orderId;
    }
    
    public void execute(QueueableContext context) {
        try{
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments(ConstantUtilities.PO_APPROVAL_COMMENT);
            req.setObjectId(orderId);
            req.setProcessDefinitionNameOrId(ConstantUtilities.PO_APPROVAL_PROCESS_NAME); 
            req.setSkipEntryCriteria(true);
            Approval.ProcessResult result = Approval.process(req);
        }catch(exception e){
            Insert Utilities.getExceptionErrorLog('POApprovalProcessQueueable','execute',e);
        }
        
    }
}