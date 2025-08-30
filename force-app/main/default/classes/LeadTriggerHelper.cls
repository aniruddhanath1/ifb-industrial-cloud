public without sharing class LeadTriggerHelper {
    public static void opportunityCreation(List<Lead> leadList,Map<String,Account> accountMap){
        try{
            List<Lead> newLeads = [select Id,Company,PostalCode,validationBypassDate__c,Budgetary_Quote__c,Type_of_Setup__c,Operation_Parakram__c,Export_Agency_Name__c,Name_and_Place_of_the_Event__c,Name_of_Customer__c,Rating,Infrastructure_completed_in_30_days__c,Space_Availability__c,Site_Suitability__c,Budget_Availablility_Budget_Source__c,Purchase_Timeline__c from lead where Id in: leadList];
            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            List<Opportunity> newOpportunityList = new List<Opportunity>();
            for (Lead lead : newLeads) {
                String key = lead.Company + ':' + lead.PostalCode;
                lead.validationBypassDate__c = System.now();
                if(accountMap.containsKey(key)){
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(lead.Id);
                    lc.setDoNotCreateOpportunity(true);
                    lc.setConvertedStatus(ConstantUtilities.LEAD_STATUS);
                    lc.setAccountId(accountMap.get(key).Id);
                    handleProductCategoryForOpportunity(lead,accountMap.get(key).Id);
                    leadConverts.add(lc);
                } 
            }
            if (!leadConverts.isEmpty()) {    
            }   
        }
        catch(Exception e){
            ExceptionHandler.logException('LeadTriggerHelper', 'ConvertingLeadIfAccountAlreadyExist', e	);
        }
    }
    
    
    Public static List<Lead> leadsMergeMethod(Set<String> leadCompanyNameSet,Set<String>leadProductSet,Set<String> leadShippingPostalSet){
        List<Lead> mergedList = new List<Lead>(); 
        Map<String,List<Lead>> leadsMap = new Map<String,List<Lead>>();
        List<Event> eventsToUpdate = new List<Event>();
        List<Task> tasksToUpdate = new List<Task>();
        List<Contact> contactToUpdate = new List<Contact>();
        List<Lead> leadsToDelete = new List<Lead>();
        List<Lead> masterLeadToUpdte = new List<Lead>(); 
        try{
            List<Lead> leadRecords = new List<Lead>([SELECT Id,MergeRecordId__c,Company,Status,FirstName,Phone,LastName,Name,Product_Category__c,PostalCode,Createddate,Title,Email,Rating,Next_Follow_up_Date_Time__c,
                                                     Type_of_Customer__c,Lead_Created_By__c,EmployeeName__c,EmployeeID__c,Alternative_Phone_Number__c,Industry,Query__c,Remark__c,Call_Centre_Remarks__c,AnnualRevenue,Reason_for_Disqualification__c,
                                                     Multiple_Enquiries__c,Most_Recent_Enquiry_Date__c,Sub_Source_Name__c,Sub_Source_Phone_number__c,IsPrimaryContact__c,Customer_Category__c,Urgent__c,Type_of_Lead__c,
                                                     Customer_Segment_Vertical__c,Name_and_Place_of_the_Event__c,Name_of_Customer__c,Customer_Sub_segment_Sub_Vertical__c,Type_of_Setup__c,Customer_Department__c,Customer_Designation__c,Is_our_contact_a_Key_Decision_Maker__c,NumberOfEmployees,
                                                     Type__c,Purchase_Timeline__c,Budget_Availablility_Budget_Source__c,Space_Availability__c,Site_Suitability__c,Export_Agency_Name__c,Infrastructure_completed_in_30_days__c,Other_Locations__c,Other_Business__c,Operation_Parakram__c,Owner.Name,Partner_Email__c,
                                                     (SELECT Id, WhoId FROM Tasks),(SELECT ID FROM Contacts__r), (SELECT Id, WhoId FROM Events) FROM Lead 
                                                     Where  Company IN: leadCompanyNameSet AND Product_Category__c IN : leadProductSet 
                                                     AND PostalCode IN: leadShippingPostalSet order by Createddate DESC]);
            if(leadRecords.size() > 0){
                for( Lead lead : leadRecords ) {
                    String leadComanyLoactionAndProduct = '';
                    leadComanyLoactionAndProduct = lead.Company +''+lead.PostalCode+''+lead.Product_Category__c;
                    if( !leadsMap.containsKey( lead.Company+''+lead.PostalCode+''+lead.Product_Category__c ) ) {
                        leadsMap.put( leadComanyLoactionAndProduct, new List<Lead>() );
                    }
                    leadsMap.get(leadComanyLoactionAndProduct ).add( lead );
                }
            }
            if(!leadsMap.isEmpty()){
                String finalStatus = '';
                for( String key : leadsMap.keySet() ) {
                    List<Lead> leadsToMerge = leadsMap.get( key );
                    if( leadsToMerge.size() > 0) {
                        Lead masterLead = leadsToMerge[0];
                        String currentStatus = leadStatusCheck(masterLead.Status) ;
                        if(currentStatus != null){
                            finalStatus  = currentStatus;   
                        }
                        for( Integer i = 1; i < leadsToMerge.size(); i++ ) {
                            Lead mergedLead = leadsToMerge[i];
                            String currentStatusMergeLead = leadStatusCheck(mergedLead.Status) ;
                            if(currentStatusMergeLead != null){
                                finalStatus  = currentStatusMergeLead;
                            }
                            String leadMergDetail = '';
                            leadMergDetail = mergedLead.Lead_Created_By__c != null ? mergedLead.Lead_Created_By__c +',': '';
                            if(String.isNotBlank(finalStatus)){
                                masterLead.Status = finalStatus; 
                            }
                            masterLead.Phone =  masterLead.Phone != null ?  masterLead.Phone : mergedLead.Phone;
                            masterLead.Title = masterLead.Title != Null ?  masterLead.Title : mergedLead.Title;
                            masterLead.Email = masterLead.Email != Null ?  masterLead.Email : mergedLead.Email;
                            masterLead.Rating = masterLead.Rating != Null ?  masterLead.Rating : mergedLead.Rating;
                            masterLead.Type_of_Customer__c =  masterLead.Type_of_Customer__c != null ?  masterLead.Type_of_Customer__c : mergedLead.Type_of_Customer__c;
                            masterLead.EmployeeName__c = masterLead.EmployeeName__c  != Null ?  masterLead.EmployeeName__c : mergedLead.EmployeeName__c;
                            masterLead.EmployeeID__c = masterLead.EmployeeID__c != Null ?  masterLead.EmployeeID__c : mergedLead.EmployeeID__c;
                            masterLead.Partner_Email__c = masterLead.Partner_Email__c != Null ? masterLead.Partner_Email__c : mergedLead.Partner_Email__c;
                            masterLead.Alternative_Phone_Number__c =  masterLead.Alternative_Phone_Number__c != null ?  masterLead.Alternative_Phone_Number__c : mergedLead.Alternative_Phone_Number__c;
                            masterLead.Industry  = masterLead.Industry  != Null ?  masterLead.Industry : mergedLead.Industry;
                            masterLead.Query__c = masterLead.Query__c != Null ?  masterLead.Query__c : mergedLead.Query__c;  
                            masterLead.Remark__c =  masterLead.Remark__c != null ?  masterLead.Remark__c : mergedLead.Remark__c;
                            masterLead.Call_Centre_Remarks__c  = masterLead.Call_Centre_Remarks__c != Null ?  masterLead.Call_Centre_Remarks__c : mergedLead.Call_Centre_Remarks__c;
                            masterLead.Next_Follow_up_Date_Time__c = masterLead.Next_Follow_up_Date_Time__c  != Null ?  masterLead.Next_Follow_up_Date_Time__c : mergedLead.Next_Follow_up_Date_Time__c;
                            masterLead.AnnualRevenue = masterLead.AnnualRevenue != Null ?  masterLead.AnnualRevenue : mergedLead.AnnualRevenue;
                            masterLead.Reason_for_Disqualification__c =  masterLead.Reason_for_Disqualification__c != null ?  masterLead.Reason_for_Disqualification__c : mergedLead.Reason_for_Disqualification__c;
                            masterLead.Multiple_Enquiries__c =  true;
                            masterLead.Most_Recent_Enquiry_Date__c = system.today();
                            masterLead.Sub_Source_Name__c = masterLead.Sub_Source_Name__c != Null ?  masterLead.Sub_Source_Name__c : mergedLead.Sub_Source_Name__c;
                            masterLead.Sub_Source_Phone_number__c  = masterLead.Sub_Source_Phone_number__c  != Null ?  masterLead.Sub_Source_Phone_number__c : mergedLead.Sub_Source_Phone_number__c;
                            masterLead.IsPrimaryContact__c = masterLead.IsPrimaryContact__c != true ?  masterLead.IsPrimaryContact__c : mergedLead.IsPrimaryContact__c;
                            masterLead.Customer_Category__c  =  masterLead.Customer_Category__c != null ? masterLead.Customer_Category__c :  mergedLead.Customer_Category__c;
                            masterLead.Type_of_Lead__c = masterLead.Type_of_Lead__c != null ? masterLead.Type_of_Lead__c :mergedLead.Type_of_Lead__c;
                            masterLead.Customer_Segment_Vertical__c = masterLead.Customer_Segment_Vertical__c != null ? masterLead.Customer_Segment_Vertical__c : mergedLead.Customer_Segment_Vertical__c;
                            masterLead.Customer_Sub_segment_Sub_Vertical__c = masterLead.Customer_Sub_segment_Sub_Vertical__c != null ? masterLead.Customer_Sub_segment_Sub_Vertical__c : mergedLead.Customer_Sub_segment_Sub_Vertical__c;
                            masterLead.Type_of_Setup__c = masterLead.Type_of_Setup__c  != null ? masterLead.Type_of_Setup__c :  mergedLead.Type_of_Setup__c;
                            masterLead.Customer_Department__c =   masterLead.Customer_Department__c != null ? masterLead.Customer_Department__c : mergedLead.Customer_Department__c;
                            masterLead.Customer_Designation__c =  masterLead.Customer_Designation__c != null ? masterLead.Customer_Designation__c : mergedLead.Customer_Designation__c;
                            masterLead.Is_our_contact_a_Key_Decision_Maker__c  =  masterLead.Is_our_contact_a_Key_Decision_Maker__c != null ? masterLead.Is_our_contact_a_Key_Decision_Maker__c :  mergedLead.Is_our_contact_a_Key_Decision_Maker__c;
                            masterLead.Type__c = masterLead.Type__c != null ? masterLead.Type__c :  mergedLead.Type__c;		
                            masterLead.Purchase_Timeline__c =   masterLead.Purchase_Timeline__c != null ?   masterLead.Purchase_Timeline__c :  mergedLead.Purchase_Timeline__c;
                            masterLead.Budget_Availablility_Budget_Source__c =  masterLead.Budget_Availablility_Budget_Source__c != NULL ? masterLead.Budget_Availablility_Budget_Source__c :  mergedLead.Budget_Availablility_Budget_Source__c;
                            masterLead.Space_Availability__c = masterLead.Space_Availability__c != null ? masterLead.Space_Availability__c : mergedLead.Space_Availability__c;
                            masterLead.Site_Suitability__c = masterLead.Site_Suitability__c != null ? masterLead.Site_Suitability__c : mergedLead.Site_Suitability__c;
                            masterLead.Infrastructure_completed_in_30_days__c = masterLead.Infrastructure_completed_in_30_days__c != Null ? masterLead.Infrastructure_completed_in_30_days__c : mergedLead.Infrastructure_completed_in_30_days__c;
                            masterLead.Other_Locations__c =  masterLead.Other_Locations__c != null ? masterLead.Other_Locations__c :  mergedLead.Other_Locations__c;
                            masterLead.Other_Business__c = masterLead.Other_Business__c != null ? masterLead.Other_Business__c :  mergedLead.Other_Business__c;
                            leadMergDetail = leadMergDetail +'Name: '+mergedLead.Name+' '+'Email: '+mergedLead.Email+' '+'CreatedDate:'+mergedLead.CreatedDate;
                            masterLead.Lead_Created_By__c = leadMergDetail ;
                            masterLead.MergeRecordId__c = mergedLead.Id;
                            masterLead.validationBypassDate__c = System.now();
                            masterLeadToUpdte.add(masterLead);  
                            
                            if(mergedLead.Contacts__r.size() > 0){
                                for( Contact contact : mergedLead.Contacts__r ) {
                                    contact.lead__c = masterLead.Id;
                                    contact.Primary_Contact__c = false;
                                    contactToUpdate.add(contact);
                                }  
                            }
                            
                            if(mergedLead.Tasks.size() > 0){
                                for( Task t : mergedLead.Tasks ) {
                                    t.WhoId = masterLead.Id;
                                    tasksToUpdate.add( t );
                                }  
                            }
                            
                            if(mergedLead.Events.size() > 0){
                                for( Event e : mergedLead.Events ) {
                                    e.WhoId = masterLead.Id;
                                    eventsToUpdate.add( e );
                                }
                            }
                            leadsToDelete.add( mergedLead );  
                        }
                    }
                }
                if(masterLeadToUpdte.size() > 0){
                    Update masterLeadToUpdte;
                    mergedList.addAll(masterLeadToUpdte); 
                }
                if( contactToUpdate.size() > 0 ) update contactToUpdate;
                if( eventsToUpdate.size() > 0 ) update eventsToUpdate;
                if( tasksToUpdate.size() > 0 ) update tasksToUpdate;
                
                if( leadsToDelete.size() > 0 ){
                    User user = [select Id , Profile.Name from User where Profile.Name =:ConstantUtilities.SYSTEM_ADMIN AND IsActive = true limit 1 ];
                    delete as user leadsToDelete;
                }   
            }    
        }catch(DmlException e){
            ExceptionHandler.logException('LeadTriggerHelper', 'LeadMergedMethods', e);
        }
        return mergedList;
    }
    public static void handleProductCategoryForOpportunity(Lead lead,Id AccountIds) {
        try{
            Account acc = [select Id,ShippingCountryCode,ShippingCity,ShippingStateCode,ShippingStreet,ShippingPostalCode from Account where Id =: AccountIds];
            acc.ShippingCity = lead.Shipping__City__s;
            acc.ShippingCountryCode = lead.Shipping__CountryCode__s;
            acc.ShippingStateCode = lead.Shipping__StateCode__s;
            acc.ShippingStreet = lead.Shipping__Street__s;
            acc.ShippingPostalCode = lead.Shipping__PostalCode__s;
            update acc;
            List<Opportunity> opportunityList = new List<Opportunity>();
            if(lead.Product_Category__c == ConstantUtilities.OPPORTUNITY_ILM || lead.Product_Category__c == ConstantUtilities.OPPORTUNITY_BOTH){
                Date today = Date.today();
                String currentDate = DateTime.newInstance(today.year(), today.month(), today.day()).format('MMM d');
                Opportunity newOpportunity = new Opportunity();
                newOpportunity.AccountId = AccountIds;
                newOpportunity.Name = lead.Company + ' - ' + ConstantUtilities.OPPORTUNITY_ILM + ' - ' + currentDate;
                newOpportunity.Purchase_timeline__c = lead.Purchase_Timeline__c;
                newOpportunity.Budget__c = lead.Budget_Availablility_Budget_Source__c;
                newOpportunity.Site__c = lead.Site_Suitability__c;
                newOpportunity.Space_availability__c = lead.Space_Availability__c;
                newOpportunity.Infrastructure_completed_in_30_days__c = lead.Infrastructure_completed_in_30_days__c;
                newOpportunity.Rating__c = lead.Rating;
                newOpportunity.Product_category__c = ConstantUtilities.OPPORTUNITY_ILM;
                newOpportunity.StageName = ConstantUtilities.OPPORTUNITY_STAGE;
                newOpportunity.CloseDate = System.today().addMonths(1);
                newOpportunity.CurrentValidationTime__c = System.now();
                newOpportunity.Operation_Parakram__c = lead.Operation_Parakram__c;
                newOpportunity.Type_of_Setup__c = lead.Type_of_Setup__c;
                newOpportunity.LeadIDText__c = lead.Id;
                newOpportunity.Budgetary_Quote__c = lead.Budgetary_Quote__c;
                if(lead.Export_Agency_Name__c!=null){
                    newOpportunity.Export_Agency_Name__c = lead.Export_Agency_Name__c;
                }
                if(lead.Name_and_Place_of_the_Event__c!=null){
                    newOpportunity.Name_and_Place_of_the_Event__c = lead.Name_and_Place_of_the_Event__c;
                }
                if(lead.Name_of_Customer__c!=null){
                    newOpportunity.Name_of_Customer__c = lead.Name_of_Customer__c;
                }
                if(lead.LeadSource==ConstantUtilities.OTHER){
                    newOpportunity.LeadSource = lead.Lead_Source_Direct_Lead__c;
                }else{
                    newOpportunity.LeadSource = lead.LeadSource;
                }
                opportunityList.add(newOpportunity);
            }
            if(lead.Product_Category__c == ConstantUtilities.OPPORTUNITY_IDW || lead.Product_Category__c == ConstantUtilities.OPPORTUNITY_BOTH){
                Date today = Date.today();
                String currentDate = DateTime.newInstance(today.year(), today.month(), today.day()).format('MMM d');
                Opportunity newOpportunity = new Opportunity();
                newOpportunity.AccountId = AccountIds;
                newOpportunity.Name = lead.Company + ' - ' + ConstantUtilities.OPPORTUNITY_IDW + ' - ' + currentDate;
                newOpportunity.Purchase_timeline__c = lead.Purchase_Timeline__c;
                newOpportunity.Budget__c = lead.Budget_Availablility_Budget_Source__c;
                newOpportunity.Site__c = lead.Site_Suitability__c;
                newOpportunity.Space_availability__c = lead.Space_Availability__c;
                newOpportunity.Infrastructure_completed_in_30_days__c = lead.Infrastructure_completed_in_30_days__c;
                newOpportunity.Rating__c = lead.Rating;
                newOpportunity.Product_category__c = ConstantUtilities.OPPORTUNITY_IDW;
                newOpportunity.StageName = ConstantUtilities.OPPORTUNITY_STAGE;
                newOpportunity.CloseDate = System.today().addMonths(1);
                newOpportunity.CurrentValidationTime__c = System.now();
                newOpportunity.Operation_Parakram__c = lead.Operation_Parakram__c;
                newOpportunity.Type_of_Setup__c = lead.Type_of_Setup__c;
                newOpportunity.LeadIDText__c = lead.Id;
                newOpportunity.Budgetary_Quote__c = lead.Budgetary_Quote__c;
                if(lead.Export_Agency_Name__c!=null){
                    newOpportunity.Export_Agency_Name__c = lead.Export_Agency_Name__c;
                }
                if(lead.Name_and_Place_of_the_Event__c!=null){
                    newOpportunity.Name_and_Place_of_the_Event__c = lead.Name_and_Place_of_the_Event__c;
                }
                if(lead.Name_of_Customer__c!=null){
                    newOpportunity.Name_of_Customer__c = lead.Name_of_Customer__c;
                }
                if(lead.LeadSource==ConstantUtilities.OTHER){
                    newOpportunity.LeadSource = lead.Lead_Source_Direct_Lead__c;
                }else{
                    newOpportunity.LeadSource = lead.LeadSource;
                }
                opportunityList.add(newOpportunity);
            }
            insert opportunityList;   
        }
        catch(Exception e){
            ExceptionHandler.logException('LeadTriggerHelper', 'LeadMergedMethods',e);
        }
    }
    private static string leadStatusCheck(String status){
        String leadStatusValidated =  ConstantUtilities.LEAD_VALIDATED;
        String leadStatusContacted =  ConstantUtilities.LEAD_CONTACTED;
        String leadStatusNurturing =  ConstantUtilities.LEAD_NURTURING;
        if(status == leadStatusValidated ||status == leadStatusContacted || status == leadStatusNurturing){
            return status;   
        }else{
            return null;  
        } 
    }
}