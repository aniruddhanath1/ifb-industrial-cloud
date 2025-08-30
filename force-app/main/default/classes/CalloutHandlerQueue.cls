public class CalloutHandlerQueue Implements System.Queueable {
    List<Id> attendaceIds = new List<Id>();
    String actionType;
    public CalloutHandlerQueue(List<Id> attendaceIds,String actionType)
    {
        this.attendaceIds = attendaceIds;
        this.actionType=actionType;
    }
    public void execute(QueueableContext qc)
    {
        try{
            IntegrationHandler.sendObejectDataToIFBInternalSys(this.attendaceIds,this.actionType );
        }catch(Exception e){
            ExceptionHandler.logException('CalloutHandlerQueue', 'execute', e);
        } 
    }
}