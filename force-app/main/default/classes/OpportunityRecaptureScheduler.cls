global class OpportunityRecaptureScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        OpportunityRecaptureBatch batchJob = new OpportunityRecaptureBatch();
        Database.executeBatch(batchJob, 200);
    }
}