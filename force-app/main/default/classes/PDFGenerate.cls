public class PDFGenerate {
    
    public Opportunity opportunity { get; set; }
    public List<Blue_Sheet__c> blueSheets { get; set; }
    
    public PDFGenerate() {
        Id oppId = ApexPages.currentPage().getParameters().get('id');
        if (oppId != null) {
            try {
                opportunity = [SELECT Id, Red_Flags__c, Strengths__c, Sales_Person_Involved__c, CurrentVolume__c, 
                                       TotalPotentialVolume__c, Adequacy_of_current_position__c, SalesRevenueUnits__c, 
                                       Competition_Type__c, My_Position_vs_Competition__c, Place_in_Sales_Funnel__c, 
                                       Timing_for_Priorities__c, Specify_Cometitor_s__c,CloseDate,Amount,
                                       Summary_of_Position__c, Possible_Actions__c , Account.Name, Name, Sales_Person_Involved_Name__c, Blue_Sheet_Last_Modified_Date__c, Blue_Sheet_Created_Date__c,Product_Service__c
                                FROM Opportunity 
                                WHERE Id = :oppId
                                LIMIT 1];
                
                blueSheets = [Select Id, Buying_Influence_Key_Win_Results__c,Buying_Influences_Involved__c,Buying_Influence_Name__c, Degree_Of_Influence__c, Evidence_to_support_your_Rating__c, Ideal_Customer_Criteria__c
                                                 , Match_to_Criteria_5_to_5__c, Mode__c, OpportunityId__c, Rating_5_to_5__c, Role__c,Type__c,Summary_Of_My_Position_Today__c,
                   Possible_Actions__c, What__c, Who__c, flag__c,When__c,Information_Needed__c,From_Whom__c, who_Name__c, Whom_Name__c from Blue_Sheet__c where OpportunityId__c =:oppId Order by createddate asc];
                Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+'Bluesheet_'+(opportunity.name).replace(' ','_')+String.valueOf(Date.today()).removeEnd(' 00:00:00')+'.pdf');
            } catch (Exception e) {
                ExceptionHandler.logException('PDFGenerate', 'PDFGenerate', e);
            }
        }
    } 
     public DateTime getBlueSheetCreatedDateIST() {
        return convertToIST(opportunity.Blue_Sheet_Created_Date__c);
    }

    public DateTime getBlueSheetLastModifiedDateIST() {
        return convertToIST(opportunity.Blue_Sheet_Last_Modified_Date__c);
    }

    private DateTime convertToIST(DateTime gmtDateTime) {
        if (gmtDateTime != null) {
            return gmtDateTime.addHours(5).addMinutes(30);
        }
        return null;
    }
}