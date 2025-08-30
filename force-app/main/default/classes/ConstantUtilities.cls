public with sharing class ConstantUtilities {
    
    public static final String LEAD_TRIGGER_NAME = 'LeadSetting';
    public static final String CONTACT_TRIGGER_NAME = 'ContactSetting';
    public static final String ACCOUNT_TRIGGER_NAME = 'AccountSetting';
    public static final String PROFORMA_INVOICELINEITEM_TRIGGERNAME = 'ProformaLineItemSetting';
    public static final String INVOICELINEITEM_TRIGGERNAME = 'InvoiceLineItemSetting';
    public static final String EXPENSELINEITEM_TRIGGERNAME = 'ExpenseLineItemSetting';
    public static final String OPPORTUNITY_TRIGGER_NAME = 'Opportunity_Settings';
    public static final String CUSTOM_QUOTELINE_TRIGGER_NAME = 'QuoteLine_Setting';
    public static final Integer DAILY_HOUR = 18;
    public static final Integer WEEKLY_HOUR = 16;
    public static final Integer MONTHLY_HOUR = 9;
    public static final Integer MINUTE_HOUR = 15;
    public static final String LEAD_STATUS = 'Converted';
    public static final String OPPORTUNITY_ILM = 'ILM';
    public static final String OPPORTUNITY_IDW = 'IDW';
    public static final String OPPORTUNITY_BOTH = 'Both';
    public static final String OPPORTUNITY_STAGE = 'Qualification';
    public static final String  OPPORTUNITY_lOAD_STAGE= 'load Calculation';
    public static final Integer NUMBER_NEGATIVE_30 = -30;
    public static final Integer NUMBER_NEGATIVE_45 = -45;
    public static final String IDW_PRODUCT_RACK_CONVEYOR_DISHWASHERS = 'Rack-Conveyor Dishwashers';
    public static final String PRODUCT_LOAD_FIELDS_WASH_LOAD_CAPACITY = 'Wash_Load_capacity__c';
    public static final String PRODUCT_LOAD_FIELDS_IRON_LOAD_CAPACITY = 'Iron_Load_capacity__c';
    public static final String PRODUCT_LOAD_FIELDS_DRY_LOAD_CAPACITY = 'Dry_load_capacity__c';
    public static final String TOTAL_WASH_LOAD_CAPACITY = 'TotalWashLoadCapacity';
    public static final String TOTAL_IRON_LOAD_CAPACITY = 'TotalIronLoadCapacity';
    public static final String TOTAL_DRY_LOAD_CAPACITY = 'TotalDryLoadCapacity';
    public static final String OPPORTUNITY_VERTICAL_GUEST ='Guest laundry';
    public static final String ILM_PRICEBOOK_NAME ='Industrial Washing Machine';
    public static final String IDW_PRICEBOOK_NAME ='Industrial Dishwasher';
    public static final String PROVISIONAL_ACCOUNT = 'Provisional_Account';
    public static final String PRICING_METHOD_COST = 'Cost';
    public static final String LEAD_TYPE_OF_CUSTOMER = 'Type_of_Customer__c';
    public static final String LEAD_LASTNAME  = 'LastName';
    public static final String LEAD_FIRSTNAME = 'FirstName';
    public static final String LEAD_COMPANY = 'Company';
    public static final String LEAD_BILL_TO_NAME = 'Bill_To_Name__c';
    public static final String LEAD_BILL_TO_STREET = 'Billing_Street__s';
    public static final String LEAD_BILL_TO_CITY = 'Billing_City__s';
    public static final String LEAD_BILL_TO_STATE = 'Billing_State__s';
    public static final String LEAD_BILL_TO_POSTAL_CODE = 'Billing_PostalCode__s';
    public static final String LEAD_BILL_TO_COUNTRY = 'Billing_Country__s';
    public static final String LEAD_SHIP_TO_NAME = 'Ship_to_Name__c';
    public static final String LEAD_SHIP_TO_STREET = 'Shipping_Street__s';
    public static final String LEAD_SHIP_TO_CITY = 'Shipping_City__s';
    public static final String LEAD_SHIP_TO_STATE = 'Shipping_State__s';
    public static final String LEAD_SHIP_TO_POSTAL_CODE = 'Shipping_PostalCode__s';
    public static final String LEAD_SHIP_TO_COUNTRY = 'Shipping_Country__s';
    public static final String LEAD_IS_SAME_SHIPPING_ADDRESS_AS_BILLING = 'IsSameLocation';
    public static final String LEAD_STREET  = 'Street';
    public static final String LEAD_COUNTRY  = 'Country';
    public static final String LEAD_CITY   = 'City';
    public static final String LEAD_STATE  = 'State';
    public static final String LEAD_POSTALCODE  = 'PostalCode';
    public static final String LEAD_PRODUCT_CATEGORY  = 'Product_Category__c';
    public static final String LEAD_DESCRIPTION  = 'Description';
    public static final String LEAD_EMPLOYEENAME  = 'EmployeeName__c';
    public static final String LEAD_PHONE  = 'Phone';
    public static final String LEAD_EMAIL  = 'Email';
    public static final String PARTNER_EMAIL = 'Partner_Email__c';
    public static final String LEAD_CALL_CENTRE_REMARKS  = 'Call_Centre_Remarks__c';
    public static final String LEAD_EMPLOYEEID  = 'EmployeeID__c';
    public static final String ISSAMELOCATION = 'IsSameLocation';
    public static final String SHIPPING_STREET = 'Shipping__Street__s';
    public static final String SHIPPING_CITY  = 'Shipping__City__s';
    public static final String SHIPPING_STATECODE  = 'Shipping__StateCode__s';
    public static final String SHIPPING_POSTALCODE  = 'Shipping__PostalCode__s';
    public static final String SHIPPING_COUNTRYCODE  = 'Shipping__CountryCode__s';
    public static final String SECTOR = 'Sector__c';
    public static final String RECOMMENDATION_PRODUCT='product';
    public static final String RECOMMENDATION_QUANTITY='quantity';
    public static final String Status_Converted_to_Opportunity = 'Validated';
    public static final String CUSTOMER_SEGMENT_VERTICALS = 'Customer_Segment_Vertical__c';
    public static final String LEADSOURCE  = 'LeadSource';
    public static final String LEAD_SUB_SOURCE  = 'Lead_Sub_Source__c';
    public static final String LEAD_SUB_SOURCE_PHONE  = 'Sub_Source_Phone_number__c';
    public static final String NEXT_FOLLOWUP_DATETIME  = 'Next_Follow_up_Date_Time__c';
    public static final String CUSTOMER_SEGMENT_VERTICAL  = 'Customer__c';
    public static final String ACCOUNTTYPE  = 'accountType';
    public static final String ACCOUNTTYPE_CALL_CENTER_TEAM = 'callCenterTeam';
    public static final String ACCOUNTTYPE_PARTNERS = 'Partners';
    public static final String LEADSOURCE_EXISTING_EMAIL = 'Existing Email';
    public static final String DOMESTIC_CALL_CENTER_TEAM = 'Domestic Call Centre Team';
    public static final String BomasandraAddress = '3b/3c, Ifb Industries Ltd, Bommasandra Industrial Area, Anekal Taluk, Bengaluru  560099';
    public static final String ShareType = 'V';
    public static final String Visibility = 'AllUsers';
    public static final String RES_STATUS_SUCCESS = 'SUCCESS';
    public static final String OPPORTUNITY_LINE_ITEM_TRIGGERNAME = 'Opportunity_Line_Item_Settings';
    Public static final String GUESTUSER_PARTNERFORM = 'Partner&Service';
    Public static final String GUESTUSER_CUSTOMERFORM = 'CustomerPortals';
    Public static final String GUESTUSER_CUSTOMERQUOTEFORM = 'CustomerQuote';
    Public static final String GUESTUSER_CUSTOMER = 'Customer';

    
    public static final String ACCOUNTTYPE_CUSTOMER = 'customer';
    public static final Integer TATA_ACE= 32;
    public static final Integer VEHICLE14 = 76;
    public static final Integer VEHICLE17 = 92;
    public static final Integer VEHICLE19 = 103;
    public static final Integer VEHICLE22 = 149;
    public static final Integer VEHICLE_NONE = 0;
    public static final String TATA = 'Tata Ace';
    public static final String FOUR = '14';
    public static final String SEVEN = '17';
    public static final String NINE = '19';
    public static final String TWO = '22';
    public static final String NONE = 'None';
    public static final string LEAD_STATUS_UNVALIDATED = 'Unvalidated'; 
    public static final String LEADSTATUS_VALIDATED = 'Validated';
    public static final string CUSTOMER_CATEGORY_DOMESTIC = 'Domestic'; 
    public static final string APIType_LeadStatusSync = 'Lead Status Sync Request'; 
    public static final string APIType_LeadSyncRequest = 'Lead Sync Request'; 
    public static final string APIType_ExpenseSyncRequest = 'Expense Sync Request'; 
    public static final String OPERATION_PARAKRAM = 'Operation_Parakram__c';
    
    public static final string FREQUENCY_WEEKLY = 'Weekly'; 
    public static final string FREQUENCY_DAILY = 'Daily'; 
    public static final string FREQUENCY_MONTHLY = 'Monthly'; 
    public static final string FREQUENCY_QUARTERLY = 'Quarterly'; 
    public static final string TYPE_OF_LEAD_STRATEGIC = 'Strategic Lead'; 
    public static final string FREQUENTLY_NOTIFICATION = 'Frequently_Notification_to_Owner'; 
    public static final string LabelAccount360Request = 'Account360Request';
    public static final string LabelStockAvailabilityRequest = 'StockAvailabilityRequest';
    public static final string STATUS_PO_APPROVED = 'PO Approved';
    public static final String EVENT_TYPE_LEAVE = 'Leave'; 
    public static final String EVENT_TYPE_HOLIDAY = 'Holiday'; 
    public static final String EVENT_LEAVE_STATUS = 'Accepted';
    public static final String PUNCH_IN_NOTIFICATION_DATA = 'Punch_In_Notification';
    public static final String LEAD_VISIT_REMINDER_NOTIFICATION = 'Lead_Visit_Reminder';
    
    public static final String REMINDER_30_DAYS_MANAGER = 'ReminderFor30DaysManager';
    public static final String REMINDER_30_DAYS = 'ReminderFor30Days';
    public static final String LEAD_INACTIVE_30_DAYS_MANAGER = 'Lead_Inactive_30_days_Manager';
    public static final String LEAD_INACTIVE_30_DAYS_USER = 'Lead_Inactive_30_days_User';
    public static final Integer DEFAULT_BATCH_SIZE = 200;
    public static final String SYSTEM_ADMIN = 'System Administrator';
    
    public static final String RECAPTURE_SUBJECT = 'Follow up on Recapture Opportunity';
    public static final String RECAPTURE_STATUS = 'Not Started';
    public static final String RECAPTURE_PRIORITY = 'Normal';
    
    public static final List<string> ILM_MATERIALSUBGROUP = new List<String>{'All','ILW','ILV','ILH','ILTD','ILF','ILO','ILDC','ILBP','ILWH','EL','ILB'};
    public static final List<string> IDW_MATERIALSUBGROUP =  new List<String>{'All','ID','INDWACC'};
    public static final String PO_SUCCESS_MESSAGE = 'Order has gone for approval.';
    public static final String PO_APPROVED_MESSAGE = 'Order has been approved.';
    public static final String ERROR_ORDER_ID_MISSING = 'Order ID is missing.';
    public static final String ERROR_INVALID_ORDER_ID = 'Invalid Order ID.';
    public static final String ERROR_ORDER_NOT_FOUND = 'Order not found.';
    public static final String ERROR_PO_NOT_RECEIVED = 'PO not received.';
    public static final String ERROR_CREDIT_APPROVAL_REQUIRED = 'Credit approval check required.';
    public static final String ERROR_GST_CERTIFICATE_NOT_PROVIDED = 'GST Certificate not provided.';
    public static final String ERROR_TCS_DECLARATION_NOT_PROVIDED = 'TCS Declaration Form not provided.';
    public static final String ERROR_PAN_CARD_NOT_PROVIDED = 'PAN Card not provided.';
    public static final String ERROR_ADVANCE_NOT_PROVIDED = 'Advanced not provided.';
    public static final String ERROR_GST_NO_NOT_PROVIDED = 'GST Number not provided.';
    public static final String ERROR_PAN_NO_NOT_PROVIDED = 'PAN Number not provided.';
    public static final String ERROR_CIN_NO_NOT_PROVIDED = 'CIN Number not provided.';
    public static final String ERROR_PAYMENT_TERMS_MISMATCH = 'Advance Payment terms do not match.';
    public static final String ERROR_WARRANTY_TERMS_MISMATCH = 'Warranty terms do not match.';
    public static final String ERROR_FREIGHT_TERMS_MISMATCH = 'Freight terms do not match.';
    public static final String ERROR_INSTALLATION_TERMS_MISMATCH = 'Installation terms do not match.';
    public static final String ERROR_DELIVERY_TERMS_MISMATCH = 'Delivery terms do not match.';
    public static final String ERROR_QUOTE_NOT_FOUND = 'Associated Quote not found.';
    public static final String PO_APPROVAL_COMMENT = 'Submitting the order for approval as few terms are matching with the agreed terms.';
    public static final String PO_APPROVAL_PROCESS_NAME = 'Order_Quote_Deviation_Approval';
    public static final String PHONE_ERROR_MSG ='Enter a Valid Landline Number Or Phone Number';
    public static final String PHONE_REGEX = '^[05-9][0-9]{9}$';
    public static final String PHONE_NUMBER_ONLY_REGEX = '^[0-9]+$';
    public static final String SOURCE_EXPORT_AGENCY = 'Export Agency';
    Public static final String PHONE_FIRSTDIGITZERO = '0';
    public static final String PHONE_FIRSTDIGIT_PLUS = '+';
    Public static final String PHONE_FIRSTDIGITFIVE = '5';
    Public static final String PHONE_FIRSTDIGITSIX = '6';
    Public static final String PHONE_FIRSTDIGITSEVEN = '7';
    Public static final String PHONE_FIRSTDIGITEIGHT = '8';
    Public static final String PHONE_FIRSTDIGITNINE = '9'; 
    public static final String LEAD_EMAIL_SUBJECT ='A lead has been assigned to you Business DAY SLA.';
    public static final String LEAD_EMAIL_SUBJECTEVERYDAY ='Everyday Notification.';
    public static final String QUOTE_EMAIL_SUBJECT = 'All Your Open Quotes';
    public static final String QUOTE_APPROVED ='Approved';
    public static final String QUOTE_REJECTED = 'Rejected';
    public static final String QUOTE_CUSTOMER_ACCEPTED = 'Accepted';
    public static final String LEAD_EMIAL_SUBJECT_FOR7DAYS = 'Email Notification for 7-days.';
    public static final String SOBJECT_NAME_OPPORTUNITY = 'Opportunity';
    public static final String OPPORTUNITY_FIELD_APINAME = 'Name';
    public static final String OPPORTUNITY_EMAIL_SUBJECT ='A Opportunity has been assigned to you.';
    public static final String ORDER_STATUS = 'On Hold';
    public static final String ORDER_EMAIL_SUBJECT ='Pending Amount Orders';
    public static final String IFB_TAX_INVOICE = 'TAX INVOICE';
    public static final String IFB_DELIVERY_CHALLAN = 'Delivery Challan';
    public static final String LEAVE_UPDATE = 'LeaveUpdate';
    public static final String ADOBE_LEAD_SYNC='AdobeLeadSync';
    public static final String LEAVE = 'Leave';
    public static final String FROM_DATE = 'fromdate';
    public static final String TO_DATE = 'todate';
    public static final String DATE_STRING = 'Date';
    public static final String INTEGER_STRING = 'Integer';
    public static final String DATA = 'Data';
    public static final String EMP_CODES = 'empcodes';
    public static final String DAY_SUN = 'Sun';
    public static final String  IDW_BRANCH_NAME_OF_CONSIGNOR = 'IFB INDUSTRIES LTD. Chennai Hub';
    public static final String  IFB_INDUSTRIES_LIMITED = 'IFB Industries Limited';
    public static final String  IDW_BRANCH_NAME_OF_CONSIGNOR_ADDRESS ='C/o N.D.R WAREHOUSING PRIVATE LIMITED Survey o. 10/2E,2B of Poochiathipet Village, Uthukottai Taluk Thiruvallur, Chennai 600052 INDIA';
    public static final String IDW_HUB_NAME_OF_CONSIGNOR_ADDRESS ='RACAIM,LOTOULIM C/o NDR GOA SPACE PVT LTD AUTULE ,SURVEY NO 258/1 Salcette, Goa 403718 INDIA';
    public static final String ILM_CONSIGNOR_ADDRESS ='ANEKAL TALUK BANGALORE 3B/3C BANGALORE 560099 Karnataka India';
    public static final String IDW_BRANCH_GSTIN = 'GSTIN : 33AAACI6561R1Z4';
    public static final String IDW_HUB_GSTIN = 'GSTIN : 30AAACI6561R1ZA';
    public static final String ILM_PDF_PAN_GSTIN = 'PAN No : AAACI6561R GSTIN/UIN : 29AAACI6561R4ZQ';                                         
    public static final String  STATE_NAME_CODE ='State Name & Code: Tamil Nadu 33';
    public static final String IFB_ADDRESS ='Regd Office: 14,TARATOLLA ROAD , KOLKATA - 700088 INDIA';
    public static final String IFB_PHONE ='0832-3044800/801';
    public static final String IFB_FAX = '0832-3044802';
    public static final String IBF_WEBSITE_EMAIL ='www.ifbappliances.com verna@ifbglobal.com';
    public static final String IFB_PAN_NO = 'AAACI6561R';
    public static final String IBF_CIN = 'L51109WB1974PLC029637';
    public static final String IDW_BRANCH_STATENAME_CODE = 'Tamil Nadu 33';
    public static final String IDW_HUB_STATENAME_CODE = 'Goa 30';
    public static final String ILM_PDF_STATENAME_CODE ='Karnataka 29';
    Public static final String IFB ='IFB INDUSTRIES LIMITED';
    public static final String PLACE_OF_SUPPLY = 'Place of Supply: Karnataka 29';
    public static final String OPP_STAGE_CLOSED_LOST = 'Closed Lost';
    public static final String OPP_STAGE_QUALIFICATION =  'Qualification';
    public static final String OPP_STAGE_SITE_VISIT =  'Site Visit';
    public static final String OPP_STAGE_LOAD_CALCULATION =  'Load Calculation';
    public static final Set<String> RECAPTURE_OPP_CLOSEDLOST_REASONS = new Set<String>{
        'Past Experience', 'Decision makers choice', 'Budget restriction', 
            'Warranty Terms', 'Price', 'AMC Terms not agreed'
            };
    
    
    public static final Integer NUM_HALF_YEARLY = 2;
    public static final Integer NUM_QUARTERLY = 4;
    public static final Integer NUM_MONTHLY = 12;
    public static final String YEARLY_TYPE = 'Yearly';
    public static final String HALF_YEARLY_TYPE = 'Half Yearly';
    public static final String QUARTERLY_TYPE = 'Quarterly';
    public static final String MONTHLY_TYPE = 'Monthly';
    public static final List<String>  THOUSANDS_LIST = new List<String>{'', 'Thousand', 'Million', 'Billion'};
    public static final List<String> TENS_LIST = new List<String>{'', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'};
    public static final List<String> BELOW_TWENTY = new List<String>{'', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'};
    public static final String PAISE_ONLY   ='PAISE ONLY'; 
    public static final String ONLY =' ONLY';
    public static final String Zero ='Zero';
    public static final String RUPEES = ' RUPEES';
    public static final String HUNDRED = ' Hundred';
    public static final String SINGLE_ZERO = '0';
    public static final String DOUBLE_ZERO ='00';
    public static final String COUNTRY_CODE_IN = 'IN';
    public static final String PHONE = 'Phone';
    public static final String ACCOUNT_SOURCE ='AccountSource';
    public static final String PAGE_ATTENDANCE = '{"type": "standard__navItemPage", "attributes": {"apiName": "Attendance_Screen"}}';
    public static final String LEAD_VALIDATED  ='Validated';
    public static final String LEAD_CONTACTED  ='Contacted';
    public static final String LEAD_NURTURING  ='Nurturing';
    public static final String EXPENSELINEITEM  ='Expense_Line_Item__c';
    public static final String ORDER  ='Order';
    public static final String OTHER = 'Other';
    public static final String ORDERINSTALLMENT  ='Order_Installment__c';
    public static final String OPPORTUNITY_CLOSEWON  ='Closed Won';
    public static final String OPPORTUNITY_CLOSEWON_ERROR  ='Unable to mark the Opportunity as Closed Won. A valid Quote was not found. Please ensure that the Quote is primary, approved, not expired, and accepted by the client.';
    public static final String RACK_SIZE35 = '35 x 35' ;
    public static final String RACK_SIZE40 = '40 x 40' ;
    public static final String RACK_SIZE50 = '50 x 50' ;
    public static final String RACK_SIZE60 = '50 x 60' ;
    public static final String INDUSTRIAL_DISHWASHER_PRODUCT_TYPE_GLASS = 'Glass' ;
    public static final String ELECTRIC_CONNECTION_ISV_3P40050N = '3P/400/50/N' ;
    public static final String FAMILY_INDUSTRIAL_GLASSWASHER = 'Industrial Glasswasher' ;
    public static final Map<String,Integer> ILM_SEQUENCE_MAP  = new Map<String,Integer>{'BOQ_Machine_List__c'=>1,'BOQ_Machine_List_Remarks__c'=>2,
        'Heating_Type__c' => 3,'Heating_Type_Remarks__c' => 4,'Laundry_Set_up__c' => 5 , 'Laundry_Set_up_Remarks__c' => 6, 'Site_Details__c' => 7,
        'Site_Details_Remarks__c' => 8, 'If_To_be_built_please_share_details__c' => 9 , 'If_To_be_built_detail_Remarks__c'=> 10, 'Clear_Passage_for_Vehicle__c' => 11,
        'Clear_Passage_for_Vehicle_Remarks__c' => 12, 'Space_for_Machine_movement__c' => 13 , 'Space_for_Machine_Movement_Remarks__c' => 14, 'Check_Room_Height__c'=> 15,
        'Check_Room_Height_Remarks__c' => 16, 'Installation_Except_GF_LB__c' => 17 ,'Installation_Except_GF_LB_Remarks__c' => 18, 'Machine_Installation_Floor_Level__c' => 19,
        'Machine_Installation_Floor_Level_Remarks__c'=> 20, 'Check_Utility_Connection_Availability__c' => 21, 'Check_Utility_Remarks__c' => 22,
        'Water__c' => 23, 'Water_Remarks__c' => 24 ,'Electrical_Provision__c'=> 25, 'Electrical_Provision_Remarks__c'=> 26,'Steam_Provision__c' => 27,
        'Steam_Provision_Remarks__c' => 28, 'Drainage__c' => 29,'Drainage_Remarks__c'=> 30 ,'Air_Line_Provision__c'=> 31, 'Air_Line_Provision_Remarks__c'=> 32,
        'Check_Water_Pressure__c'=> 33, 'Check_Water_Pressure_Remarks__c'=> 34 , 'Check_Water_Hardness__c'=> 35,'Check_Water_Hardness_Remarks__c'=> 36,
        'Check_Hot_Air_Exhaust_Provision__c'=> 37, 'Check_Hot_Air_Exhaust_Provision_Remarks__c'=> 38, 'Check_Provision_for_Ventilation_in_Room__c'=> 39,
        'Check_Provision_for_Ventilation_Remarks__c'=> 40};
            
            public static final Map<String,String> ILM_REMARKS_MAP  = new Map<String,String> {'BOQ_Machine_List__c'=>'BOQ_Machine_List_Remarks__c','Heating_Type__c'=> 'Heating_Type_Remarks__c',
                'Laundry_Set_up__c'=> 'Laundry_Set_up_Remarks__c','Site_Details__c'=> 'Site_Details_Remarks__c','If_To_be_built_please_share_details__c'=>'If_To_be_built_detail_Remarks__c',
                'Clear_Passage_for_Vehicle__c'=> 'Clear_Passage_for_Vehicle_Remarks__c','Space_for_Machine_movement__c'=> 'Space_for_Machine_Movement_Remarks__c',
                'Check_Room_Height__c'=> 'Check_Room_Height_Remarks__c','Installation_Except_GF_LB__c'=> 'Installation_Except_GF_LB_Remarks__c',
                'Machine_Installation_Floor_Level__c'=> 'Machine_Installation_Floor_Level_Remarks__c','Check_Utility_Connection_Availability__c'=>'Check_Utility_Remarks__c',
                'Water__c' =>'Water_Remarks__c','Electrical_Provision__c'=> 'Electrical_Provision_Remarks__c','Steam_Provision__c'=>'Steam_Provision_Remarks__c',
                'Drainage__c'=>'Drainage_Remarks__c','Air_Line_Provision__c'=>'Air_Line_Provision_Remarks__c','Check_Water_Pressure__c'=>'Check_Water_Pressure_Remarks__c',
                'Check_Water_Hardness__c'=>'Check_Water_Hardness_Remarks__c', 'Check_Hot_Air_Exhaust_Provision__c'=>'Check_Hot_Air_Exhaust_Provision_Remarks__c',
                'Check_Provision_for_Ventilation_in_Room__c'=>'Check_Provision_for_Ventilation_Remarks__c'};
                    
                    public static final Map<String,String> ILM_DEFAULT_REMARKSMAP  = new Map<String,String>{'BOQ_Machine_List__c'=>'Attach list and enter machine wise line items.','BOQ_Machine_List_Remarks__c'=> '',
                        'Heating_Type__c'=> '','Heating_Type_Remarks__c'=> '','Laundry_Set_up__c'=>'Kindly provide laundry room / layout  sizes (width, depth, height and door position)','Laundry_Set_up_Remarks__c'=>'',
                        'Site_Details__c'=> '','Site_Details_Remarks__c'=>'','If_To_be_built_please_share_details__c'=>'','If_To_be_built_detail_Remarks__c'=>'',
                        'Check_Room_Height__c' =>'Suggested room height - machine height + minimum 600mm.','Check_Room_Height_Remarks__c'=>'','Machine_Installation_Floor_Level__c'=> 'If any other floor, please mention floor level.',
                        'Machine_Installation_Floor_Level_Remarks__c' => '','Check_Utility_Connection_Availability__c'=> 'If Yes, please specify utility connection points, in customer drawing.','Check_Utility_Remarks__c'=> '',
                        'Water_Remarks__c'=> '','Water_Remarks__c'=> '','Electrical_Provision__c'=> 'If Yes, please specify utility connection points, in customer drawing.','Electrical_Provision_Remarks__c'=>'',
                        'Steam_Provision__c'=> 'If Yes, please specify utility connection points, in customer drawing.'};
                            
                            
                            
                            
                            public static final Map<String, String> CATEGORY_TO_PRICEBOOK_NAME_MAP = new Map<String, String>{
                                'ILM' => 'Industrial Washing Machine',
                                    'IDW' => 'Industrial Dishwasher'
                                    };
                                        
                                        
                                        public static final Id ProductILM_RECORDTYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('Industrial_Washing_Machine').getRecordTypeId();  
    public static Id RECORDTYPE(String DeveloperName){
        
        Id QuoteRecordtype = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByDeveloperName().get(DeveloperName).getRecordTypeId(); 
        
        return QuoteRecordtype;
    }  
    
}