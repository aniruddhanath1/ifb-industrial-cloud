import { LightningElement, wire, track, api } from 'lwc';
import { getRecord, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
// import generatePDF from '@salesforce/apex/BlueSheetPDFController.generatePDF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import ID_FIELD from '@salesforce/schema/Opportunity.Id';
import SALES_PERSON_FIELD from '@salesforce/schema/Opportunity.Sales_Person_Involved__c';
import SALES_PERSON_NAME_FIELD from '@salesforce/schema/Opportunity.Sales_Person_Involved_Name__c';
import CURRENT_VOLUME_FIELD from '@salesforce/schema/Opportunity.CurrentVolume__c';
import TOTAL_POTENTIAL_VOLUME_FIELD from '@salesforce/schema/Opportunity.TotalPotentialVolume__c';
import ADEQUACY_CURRENT_POSITION_FIELD from '@salesforce/schema/Opportunity.Adequacy_of_current_position__c';
import IDEAL_CUSTOMER_FIELD from '@salesforce/schema/Opportunity.Ideal_Customer_Criteria__c';
import SALES_REVENUE_FIELD from '@salesforce/schema/Opportunity.SalesRevenueUnits__c';
import COMPETITOR_TYPE_FIELD from '@salesforce/schema/Opportunity.Competition_Type__c';
import MY_POSITION_FIELD from '@salesforce/schema/Opportunity.My_Position_vs_Competition__c';
import SPECIFY_COMPETITOR_FIELD from '@salesforce/schema/Opportunity.Specify_Cometitor_s__c';
import SALES_TUNNEL_FIELD from '@salesforce/schema/Opportunity.Place_in_Sales_Funnel__c';
import TIMING_PRIORITIES_FIELD from '@salesforce/schema/Opportunity.Timing_for_Priorities__c';
import ROLE_FIELD from '@salesforce/schema/Opportunity.Role__c';
import DEGREE_INFLUENCE_FIELD from '@salesforce/schema/Opportunity.Degree_of_Influence__c';
import MODE_FIELD from '@salesforce/schema/Opportunity.Mode__c';
import SUMMARY_POSITION_FIELD from '@salesforce/schema/Opportunity.Summary_of_Position__c';
import POSSIBLE_ACTION_FIELD from '@salesforce/schema/Opportunity.Possible_Actions__c';
import BEST_ACTION_PLAN_FIELD from '@salesforce/schema/Opportunity.Best_Action_Plan__c';
import AMOUNT_FIELD from '@salesforce/schema/Opportunity.Amount';
import WHO_FIELD from '@salesforce/schema/Opportunity.Who__c';
import WHO_NAME_FIELD from '@salesforce/schema/Opportunity.Who_Name__c';
import WHAT_FIELD from '@salesforce/schema/Opportunity.What__c';
import WHEN_FIELD from '@salesforce/schema/Opportunity.When__c';
import PRODUCT_SERVICE from '@salesforce/schema/Opportunity.Product_Service__c';
import  BLUESHEET_LASTMODIFIEDDATE from '@salesforce/schema/Opportunity.Blue_Sheet_Last_Modified_Date__c';
import BLUESHEET_CREATEDDATE from '@salesforce/schema/Opportunity.Blue_Sheet_Created_Date__c';
import BLUESHEET_FIELD from '@salesforce/schema/Opportunity.Blue_Sheet__c';
import findRecords from '@salesforce/apex/genericRecordClass.getUserDetails';
import findContactRecords from '@salesforce/apex/genericRecordClass.getContactDetails';

import saveTableData from '@salesforce/apex/blueSheetController.saveblueSheetData';
import getBluesheetData from '@salesforce/apex/blueSheetController.getBlueSheetData';
import strengthIcon from '@salesforce/resourceUrl/RedFlag';
import redFlagIcon from '@salesforce/resourceUrl/Strengths';

import modal from '@salesforce/resourceUrl/QucikActionSize';
import { loadStyle } from 'lightning/platformResourceLoader';

//const fields = [AMOUNT_FIELD, RED_FLAG_FIELD];
const fields = [SALES_PERSON_FIELD, CURRENT_VOLUME_FIELD, TOTAL_POTENTIAL_VOLUME_FIELD, ADEQUACY_CURRENT_POSITION_FIELD, COMPETITOR_TYPE_FIELD, MY_POSITION_FIELD,
    SPECIFY_COMPETITOR_FIELD, SALES_TUNNEL_FIELD, TIMING_PRIORITIES_FIELD, IDEAL_CUSTOMER_FIELD, SALES_REVENUE_FIELD, ROLE_FIELD, DEGREE_INFLUENCE_FIELD, MODE_FIELD, SUMMARY_POSITION_FIELD,
    POSSIBLE_ACTION_FIELD, BEST_ACTION_PLAN_FIELD, AMOUNT_FIELD, WHEN_FIELD, WHAT_FIELD, WHO_FIELD,WHO_NAME_FIELD,SALES_PERSON_NAME_FIELD,PRODUCT_SERVICE,BLUESHEET_LASTMODIFIEDDATE, BLUESHEET_CREATEDDATE
];

export default class GenericBlueSheetsCmp extends LightningElement {
    @api recordId;
    @api hasParentCall;
    searchKey = '';
    searchWhoKey = '';
    @track selectedValue = false;
    @track selectedWhoValue;
    selectedRecordId;
    @track recordsList;
    @track recordsWhoList;
    @track message;
    @track redFlags;
    @track strengths;
    @track salesPersonInvolved;
    @track currentVolume;
    @track totalPotentialVolume;
    @track adequacyOfCurrentPosition;
    @track competitorDetails;
    @track idealCustomerCriteria;
    @track salesRevenueUnit;
    @track role;
    @track degreeOfInfluence;
    @track mode;
    @track summaryOfPosition;
    @track possibleActions;
    @track isSummary = false;
    // @track bestActionPlan;
    @track roleOptions;
    @track modeOption;
    @track degreeOption;
    @track adequacyOption;
    // @track IdealCustomerOption;
    @track CompetitorOptions;
    @track myPositionOption;
    @track salesTunnelOption;
    @track timingPrioritiesOption;
    @track showSpinner = false;
    @track showWhoSpinner = false;
    @track showDropDown = false;
    @track showWhoDropDown = false;
    @track message = "";
    @track whoMessage = "";
    @track notifyName;
    @track notifyWhoName;
    @track userId;
    @track whoUserId;
    @track amount;
    @track myPositionVsCompetition;
    @track placeInSalesFunnel;
    @track timingForPriorities;
    @track specifyCompetitor;
    @track who;
    @track what;
    @track when;
    @track productService;
    @track lastModifyDate;
    @track createdDate;
    @track listofBuyingInfluence = [];
    @track listOfEvidence = [];
    @track listOfIdealCustomer = [];
    type;
    strengthImage = strengthIcon;
    redFlagImage = redFlagIcon;

    @wire(getRecord, { recordId: '$recordId', fields })
    wiredOpportunity({ error, data }) {
        if (data) {
        loadStyle(this, modal);
            this.salesPersonInvolved = data.fields.Sales_Person_Involved__c.value;
            this.notifyName = data.fields.Sales_Person_Involved_Name__c.value;
            if(this.notifyName != null){
                this.selectedValue = true;
            }
            
            this.currentVolume = data.fields.CurrentVolume__c.value;
            this.totalPotentialVolume = data.fields.TotalPotentialVolume__c.value;
            this.adequacyOfCurrentPosition = data.fields.Adequacy_of_current_position__c.value;
            this.idealCustomerCriteria = data.fields.Ideal_Customer_Criteria__c.value;
            this.salesRevenueUnit = data.fields.SalesRevenueUnits__c.value;
            this.role = data.fields.Role__c.value;
            this.degreeOfInfluence = data.fields.Degree_of_Influence__c.value;
            this.mode = data.fields.Mode__c.value;
            this.competitorDetails= data.fields.Competition_Type__c.value;
            this.myPositionVsCompetition=data.fields.My_Position_vs_Competition__c.value;
            this.placeInSalesFunnel=data.fields.Place_in_Sales_Funnel__c.value;
            this.timingForPriorities=data.fields.Timing_for_Priorities__c. value;
            this.specifyCompetitor = data.fields.Specify_Cometitor_s__c.value;
            this.productService = data.fields.Product_Service__c.value;
            this.createdDate = data.fields.Blue_Sheet_Created_Date__c.value;
            this.lastModifyDate = data.fields.Blue_Sheet_Last_Modified_Date__c.value;
        } else if (error) {
            console.error('Error fetching opportunity record:', error);
        }
    }

    @wire(getBluesheetData, { opportunityId: '$recordId' })
    wiredBlueSheetData({ error, data }) {
        if (data) {
            console.log('**data',JSON.stringify(data));
            this.tableData = data.filter(item => item.type == 'Buying Influences Involved').map((item, index) => ({
            // this.tableData = data.map((item, index) => ({
                id: index,
                recId: item.Ids,
                type: item.type,
                buyingInfluences: item.buyingInfluences || '',
                buyingInfluenceName: item.buyingInfluenceName || '',
                selectedValue:item.selectedValue||false,
                role: item.role || '',
                degreeOfInfluence: item.degreeOfInfluence || '',
                mode: item.mode || '',
                winResult: item.winResult || '',
                evidence: item.evidence || '',
                rating: item.rating || '',
                flag: item.flag || '',
                cstnBtn: index > 0
            }));

            this.tableData3 = data.filter(item => item.type == 'Ideal Customer Criteria').map((item, index) => ({
            // this.tableData3 = data.map((item, index) => ({
                id: index,
                recId: item.Ids,
                type: item.type,
                idealCustomerCriteria: item.idealCustomerCriteria || '',
                matchCriteria: item.matchCriteria || '',
                flag: item.flag || '',
                cstnBtn: index > 0
            }));
            this.tableData4 = data.filter(item => item.type == 'Strength').map((item, index) => ({
                // this.tableData3 = data.map((item, index) => ({
                    id: index,
                    recId: item.Ids,
                    type: item.type,
                    summryOfMyPosition: item.summryOfMyPosition || '',
                    possibleActions: item.possibleActions || '',
                    whenDate: item.whenDate || '',
                    what: item.what || '',
                    who: item.who || '',
                    notifyName: item.notifyName || '',
                    selectedValue:item.selectedValue||false,
                    cstnBtn: index > 0
                }));
                this.tableData5 = data.filter(item => item.type == 'Red Flag').map((item, index) => ({
                    // this.tableData3 = data.map((item, index) => ({
                        id: index,
                        recId: item.Ids,
                        type: item.type,
                        summryOfMyPosition: item.summryOfMyPosition || '',
                        possibleActions: item.possibleActions || '',
                        informationNeeded: item.informationNeeded || '',
                        fromWhom: item.fromWhom || '',
                        notifyName: item.notifyName || '',
                        selectedValue:item.selectedValue||false,
                        cstnBtn: index > 0
                    }));

            // Ensure there's always at least one row in each table
            if (this.tableData.length === 0) {
                this.addInitialRow('tableData');
            }
            if (this.tableData3.length === 0) {
                this.addInitialRow('tableData3');
            }
            if (this.tableData4.length === 0) {
                this.addInitialRow('tableData4');
            }
            if (this.tableData5.length === 0) {
                this.addInitialRow('tableData5');
            }
        } else if (error) {
            console.error('Error fetching data:', error);
        }

        // if (!this.tableData.length) {
        //     this.tableData.push({
        //         id: 0,
        //         recId: '',
        //         buyingInfluences: '',
        //         role: '',
        //         degreeOfInfluence: '',
        //         mode: '',
        //         winResult: '',
        //         cstnBtn: false // The delete button is not visible for the first row
        //     });
        // }
    }

    addInitialRow(tableName) {
        this[tableName] = [{ id: 0, cstnBtn: false }];
        if (tableName === 'tableData') {
            this[tableName][0].recId = '';
            this[tableName][0].type = 'Buying Influences Involved';
            this[tableName][0].buyingInfluences = '';
            this[tableName][0].role = '';
            this[tableName][0].degreeOfInfluence = '';
            this[tableName][0].mode = '';
            this[tableName][0].winResult = '';
            this[tableName][0].evidence = '';
            this[tableName][0].rating = '';
            this[tableName][0].flag = '';
        } else if (tableName === 'tableData3') {
            this[tableName][0].recId = '';
            this[tableName][0].type = 'Ideal Customer Criteria';
            this[tableName][0].idealCustomerCriteria = '';
            this[tableName][0].matchCriteria = '';
            this[tableName][0].flag = '';
        }
        else if (tableName === 'tableData4') {
            this[tableName][0].recId = '';
            this[tableName][0].type = 'Strength';
            this[tableName][0].summryOfMyPosition = '';
            this[tableName][0].possibleActions = '';
            this[tableName][0].what = '';
            this[tableName][0].who = '';
            this[tableName][0].whenDate = '';
        }
        else if (tableName === 'tableData5') {
            this[tableName][0].recId = '';
            this[tableName][0].type = 'Red Flag	';
            this[tableName][0].summryOfMyPosition = '';
            this[tableName][0].possibleActions = '';
            this[tableName][0].informationNeeded = '';
            this[tableName][0].fromWhom = '';
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: ROLE_FIELD })
    wiredRolePickValue({ error, data }) {
        if (data) {
            this.roleOptions = data.values;
        } else if (error) {
            this.roleOptions = [];
            console.error('Error fetching role picklist values:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: COMPETITOR_TYPE_FIELD })
    wiredCompetitorPickValue({ error, data }) {
        if (data) {
            this.CompetitorOptions = data.values;
        } else if (error) {
            this.CompetitorOptions = [];
            console.error('Error fetching role picklist values:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: MODE_FIELD })
    wiredModePickValue({ error, data }) {
        if (data) {
            this.modeOption = data.values;
        } else if (error) {
            this.modeOption = [];
            console.error('Error fetching Mode picklist values:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: DEGREE_INFLUENCE_FIELD })
    wiredDegreePickValue({ error, data }) {
        if (data) {
            this.degreeOption = data.values;
        } else if (error) {
            this.degreeOption = [];
            console.error('Error fetching Degree picklist values:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: ADEQUACY_CURRENT_POSITION_FIELD })
    wiredAdequacyPickValue({ error, data }) {
        if (data) {
            this.adequacyOption = data.values;
        } else if (error) {
            this.adequacyOption = [];
            console.error('Error fetching adequacy picklist values:', error);
        }
    }

    // @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: IDEAL_CUSTOMER_FIELD })
    // wiredIdealCustomerPickValue({ error, data }) {
    //     if (data) {
    //         this.IdealCustomerOption = data.values;
    //     } else if (error) {
    //         this.IdealCustomerOption = [];
    //         console.error('Error fetching ideal customer option picklist values:', error);
    //     }
    // }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: MY_POSITION_FIELD })
    wiredPositionCustomerPickValue({ error, data }) {
        if (data) {
            this.myPositionOption = data.values;
        } else if (error) {
            this.myPositionOption = [];
            console.error('Error fetching My Position option picklist values:', error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: SALES_TUNNEL_FIELD })
    wiredsalesPickValue({ error, data }) {
        if (data) {
            this.salesTunnelOption = data.values;
        } else if (error) {
            this.salesTunnelOption = [];
            console.error('Error fetching place in sales tunnel option picklist values:', error);
        }
    }    

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: TIMING_PRIORITIES_FIELD })
    wiredTimingPickValue({ error, data }) {
        if (data) {
            this.timingPrioritiesOption = data.values;
        } else if (error) {
            this.timingPrioritiesOption = [];
            console.error('Error fetching place in sales tunnel option picklist values:', error);
        }
    }

    handleChange(event) {
        const field = event.target.name;
        this[field] = event.target.value;
    }

    handleKeyChange(event) {
        this.searchKey = event.target.value;

        if (this.searchKey.length > 1) {
            this.showDropDown = true;
            this.getLookupResult();
        } else {
            this.showDropDown = false
        }
    }
/*
    handleWhoKeyChange(event) {
        this.searchWhoKey = event.target.value;

        if (this.searchWhoKey.length > 1) {
            this.showWhoDropDown = true;
            this.getLookupResult();
        } else {
            this.showWhoDropDown = false
        }
    }
*/
    handleWhoKeyChange(event) {
        const rowIndex = event.target.dataset.index; // Assuming 'index' is a data attribute representing the row
        const searchKey = event.target.value;
        this.tableData4[rowIndex].searchWhoKey = searchKey; 
        if (searchKey.length > 1) {
            this.tableData4[rowIndex].showWhoDropDown = true;
            this.getWhoLookupResult(rowIndex);
        } else {
            this.tableData4[rowIndex].showWhoDropDown = false;
        }
    }
    handleWhomKeyChange(event) {
        const rowIndex = event.target.dataset.index; // Assuming 'index' is a data attribute representing the row
        const searchKey = event.target.value;
    
        this.tableData5[rowIndex].searchWhomKey = searchKey; // Update the specific row's searchWhoKey
    
        if (searchKey.length > 1) {
            this.tableData5[rowIndex].showWhomDropDown = true;
            this.getWhomLookupResult(rowIndex);
        } else {
            this.tableData5[rowIndex].showWhomDropDown = false;
        }
    }
    handleBuyKeyChange(event) {
        const rowIndex = event.target.dataset.index; 
        const searchKey = event.target.value;
        this.tableData[rowIndex].searchBuyKey = searchKey; 
        if (searchKey.length > 1) {
            this.tableData[rowIndex].showBuyDropDown = true;
            this.getBuyLookupResult(rowIndex);
        } else {
            this.tableData[rowIndex].showBuyDropDown = false;
        }
    }

    handleRemovePill() {
        this.selectedValue = false;
        this.userId = '';
        this.showDropDown = false;
    }

    handleRemoveWhoPill(event) {
        const index = event.target.dataset.index;
        this.tableData4[index].selectedValue = false;
        this.tableData4[index].notifyName = '';
        this.tableData4[index].searchWhoKey = '';
        this.tableData4[index].whoUserId = '';
        this.tableData4[index].showWhoDropDown = false;
    }
    handleRemoveWhomPill(event) {
        const index = event.target.dataset.index;
        this.tableData5[index].selectedValue = false;
        this.tableData5[index].notifyWhomName = '';
        this.tableData5[index].searchWhomKey = '';
        this.tableData5[index].whomUserId = '';
        this.tableData5[index].showWhomDropDown = false;
    }
    handleRemoveBuyPill(event) {
        const index = event.target.dataset.index;
        this.tableData[index].selectedValue = false;
        this.tableData[index].buyingInfluenceName = '';
        this.tableData[index].searchBuyKey = '';
        this.tableData[index].buyingInfluences = '';
        this.tableData[index].showBuyDropDown = false;
    }


    onSelect(event) {
        this.userId = event.currentTarget.dataset.id;
        this.selectedValue = true;
        this.notifyName = event.currentTarget.dataset.name;
        this.salesPersonInvolved = this.userId;
        console.log('notifyName : '+ this.notifyName);
        this.notifyRecId = this.userId;
        this.showDropDown = false;
      }

      onWhoSelect(event) {
        const index = event.currentTarget.dataset.index;
        const userId = event.currentTarget.dataset.id;
        const userName = event.currentTarget.dataset.name;
        this.tableData4[index].whoUserId = userId;
        this.tableData4[index].selectedValue = true;
        this.tableData4[index].notifyName = userName;
        this.tableData4[index].showWhoDropDown = false;
        this.tableData4[index].who = userId;
        this.tableData4[index].nitifyWhoRecId = userId;
      }
      onWhomSelect(event) {
        const index = event.currentTarget.dataset.index;
        const userId = event.currentTarget.dataset.id;
        const userName = event.currentTarget.dataset.name;
        this.tableData5[index].whomUserId = userId;
        this.tableData5[index].selectedValue = true;
        this.tableData5[index].notifyName = userName;
        this.tableData5[index].showWhomDropDown = false;
        this.tableData5[index].fromWhom = userId;
        this.tableData5[index].nitifyWhomRecId = userId;
      }
      OnBuySelect(event) {
        const index = event.currentTarget.dataset.index;
        const userId = event.currentTarget.dataset.id;
        const userName = event.currentTarget.dataset.name;
        console.log('**BuyName'+userName);
        this.tableData[index].buyingInfluences = userId;
        this.tableData[index].selectedValue = true;
        this.tableData[index].buyingInfluenceName = userName;
        this.tableData[index].showBuyDropDown = false;
      }

    objectName = 'User';
    getWhoLookupResult(rowIndex) {
        const row = this.tableData4[rowIndex];
        if (row.showWhoDropDown) {
            row.showWhoSpinner = true;
            row.whoMessage = '';
    
            findRecords({ searchKey: row.searchWhoKey, objectName: this.objectName })
            .then((result) => {
                console.log('**result',result);
                row.recordsWhoList = result;
                row.whoMessage = result.length === 0 ? "No Records Found" : "";
                row.error = undefined;
                row.showWhoSpinner = false;
            })
            .catch((error) => {
                row.error = error;
                row.recordsWhoList = undefined;
                console.log('**error',row.error);
            });
        }
    }
    getWhomLookupResult(rowIndex) {
        const row = this.tableData5[rowIndex];
    
        if (row.showWhomDropDown) {
            row.showWhomSpinner = true;
            row.whomMessage = '';
    
            findRecords({ searchKey: row.searchWhomKey, objectName: this.objectName })
            .then((result) => {
                row.recordsWhomList = result;
                row.whomMessage = result.length === 0 ? "No Records Found" : "";
                row.error = undefined;
                row.showWhomSpinner = false;
            })
            .catch((error) => {
                row.error = error;
                row.recordsWhomList = undefined;
            });
        }
    }
    getBuyLookupResult(rowIndex) {
        const row = this.tableData[rowIndex];
        if (row.showBuyDropDown) {
            row.showBuySpinner = true;
            row.buyMessage = '';
    
            findContactRecords({ searchKey: row.searchBuyKey, opportunityId: this.recordId })
            .then((result) => {
                console.log('**result',result);
                row.recordsBuyList = result;
                row.buyMessage = result.length === 0 ? "No Records Found" : "";
                row.error = undefined;
                row.showBuySpinner = false;
            })
            .catch((error) => {
                row.error = error;
                row.recordsBuyList = undefined;
                console.log('**error',row.error);
                row.showBuySpinner = false;
            });
        }
    }
    getLookupResult() {
        if(this.showDropDown){
            this.showSpinner = true;
            this.message = '';
            findRecords({ searchKey: this.searchKey, objectName: this.objectName })
            .then((result) => {
                this.recordsList = result;
                this.message = result.length === 0 ? "No Records Found" : "";
                this.error = undefined;
                this.showSpinner = false;
            })
            .catch((error) => {
                this.error = error;
                this.recordsList = undefined;
            });
        }
        if(this.showWhoDropDown){
            this.showWhoSpinner = true;
            this.whoMessage = ''
            findRecords({ searchKey: this.searchWhoKey, objectName: this.objectName })
            .then((result) => {
                this.recordsWhoList = result;
                this.whoMessage = result.length === 0 ? "No Records Found" : "";
                this.error = undefined;
                this.showWhoSpinner = false;
            })
            .catch((error) => {
                this.error = error;
                this.recordsWhoList = undefined;
            });
        }
        
    }

    @api handleSave() {
        // Retrieve all input fields within the component
        const inputFields = this.template.querySelectorAll('lightning-input, lightning-combobox, lightning-textarea');
    
        // Validate input fields
        let allValid = true;
        inputFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                allValid = false;
            }
        });

        // If all fields are valid, proceed with the record update
        if (allValid) {
            console.log(':::::',allValid);
            const fields = {};
            fields[ID_FIELD.fieldApiName] = this.recordId;
            fields[SALES_PERSON_FIELD.fieldApiName] = this.userId;
            fields[CURRENT_VOLUME_FIELD.fieldApiName] = this.currentVolume;
            fields[TOTAL_POTENTIAL_VOLUME_FIELD.fieldApiName] = this.totalPotentialVolume;
            fields[ADEQUACY_CURRENT_POSITION_FIELD.fieldApiName] = this.adequacyOfCurrentPosition;
            fields[SALES_REVENUE_FIELD.fieldApiName] = this.salesRevenueUnit;
            fields[COMPETITOR_TYPE_FIELD.fieldApiName] = this.competitorDetails;
            fields[MY_POSITION_FIELD.fieldApiName] = this.myPositionVsCompetition;
            fields[SPECIFY_COMPETITOR_FIELD.fieldApiName] = this.specifyCompetitor;
            fields[SALES_TUNNEL_FIELD.fieldApiName] = this.placeInSalesFunnel;
            fields[TIMING_PRIORITIES_FIELD.fieldApiName] = this.timingForPriorities;
            /*fields[POSSIBLE_ACTION_FIELD.fieldApiName] = this.possibleActions;
           fields[WHO_FIELD.fieldApiName] = this.whoUserId;
            fields[WHAT_FIELD.fieldApiName] = this.what;
            fields[WHEN_FIELD.fieldApiName] = this.when;*/
            fields[BLUESHEET_FIELD.fieldApiName] = true;
            fields[PRODUCT_SERVICE.fieldApiName] = this.productService;
            if(this.createdDate == null){
                fields[BLUESHEET_CREATEDDATE.fieldApiName] = new Date().toISOString();;
            }
            
            fields[BLUESHEET_LASTMODIFIEDDATE.fieldApiName] = new Date().toISOString();;


            const recordInput = { fields };
            console.log('recordInput ::', JSON.stringify(recordInput));
            updateRecord(recordInput)
            .then(() => {
                // Prepare the payload to send to Apex
                const payload = {
                    opportunityId: this.recordId,
                    buyingInfluenceList: JSON.stringify(this.tableData),
                    idealCustomerList: JSON.stringify(this.tableData3),
                    strengthList: JSON.stringify(this.tableData4),
                    redFlagList: JSON.stringify(this.tableData5),
                };
                console.log('*S',JSON.stringify(payload));
                // Call Apex method to save table data
                return saveTableData({ payload: JSON.stringify(payload) });
            })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Success",
                        message: "Blue Sheet updated and table data saved",
                        variant: "success",
                    })
                    
                );
                const saveEvent = new CustomEvent('savecompleted', {
                    detail: {
                        disableExport: false 
                    }
                });
                this.dispatchEvent(saveEvent);
                this.dispatchEvent(new CustomEvent('saveevent', {
                    detail: false
                }));
                this.dispatchEvent(new CustomEvent('save', {
                    detail: false
                }));
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error updating bluesheet",
                        message: error.body.message,
                        variant: "error",
                    })
                );
            });
        }
    }

    get ratingOptions() {
        return [
            { label: '+5', value: '+5' },
            { label: '+4', value: '+4' },
            { label: '+3', value: '+3' },
            { label: '+2', value: '+2' },
            { label: '+1', value: '+1' },
            { label: '0', value: '0' },
            { label: '-1', value: '-1' },
            { label: '-2', value: '-2' },
            { label: '-3', value: '-3' },
            { label: '-4', value: '-4' },
            { label: '-5', value: '-5' },
        ];
    }
    get flagOptions() {
        return [
            { label: 'Red Flag', value: 'Red Flag'},
            { label: 'Strength', value: 'Strength'}
           
        ];
    }
    @track tableData = [];
    @track tableData3 = [];
    @track tableData4 = [];
    @track tableData5 = [];

    keyIndex = 0;
    keyIndex2 = 0;
    keyIndex3 = 0;

    // updated
    addRow() {
        const newId = this.tableData.length + 1;
        const newItem = {
            id: newId,
            type: 'Buying Influences Involved',
            recId: '',
            buyingInfluences: '',
            role: '',
            degreeOfInfluence: '',
            mode: '',
            winResult: '',
            evidence: '',
            rating: '',
            flag:'',
            cstnBtn: newId > 0 // Show delete button for new rows
        };
        this.tableData = [...this.tableData, newItem];
    }
   
    addRow3() {
        const newId = this.tableData3.length + 1;
        const newItem = {
            id: newId,
            recId: '',
            type: 'Ideal Customer Criteria',
            idealCustomerCriteria: '',
            matchCriteria: '',
            flag:'',
            cstnBtn: newId > 0
        };
        this.tableData3 = [...this.tableData3, newItem];
    }
    addRow4() {
        const newId = this.tableData4.length + 1;
        const newItem = {
            id: newId,
            recId: '',
            type: 'Strength',
            summryOfMyPosition: '',
            possibleActions: '',
            what:'',
            who:'',
            whenDate:'',
            recordsWhoList:[],
            cstnBtn: newId > 0
        };
        this.tableData4 = [...this.tableData4, newItem];
    }
    addRow5() {
        const newId = this.tableData5.length + 1;
        const newItem = {
            id: newId,
            recId: '',
            type: 'Red Flag',
            summryOfMyPosition: '',
            possibleActions: '',
            informationNeeded: '',
            fromWhom: '',
            cstnBtn: newId > 0
        };
        this.tableData5 = [...this.tableData5, newItem];
    }

    // Delete row from the table
    deleteRow(event) {
        if(this.tableData.length >= 2){
            this.tableData = this.tableData.filter(function(element){
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
            
        }
        
    }

    // Delete row from the table
    deleteRow3(event) {
        if(this.tableData3.length >= 2){
            this.tableData3 = this.tableData3.filter(function(element){
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
           
        }
       
    }
    // Delete row from the table
    deleteRow4(event) {
        if(this.tableData4.length >= 2){
            this.tableData4 = this.tableData4.filter(function(element){
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
           
        }
       
    }
    // Delete row from the table
    deleteRow5(event) {
        if(this.tableData5.length >= 2){
            this.tableData5 = this.tableData5.filter(function(element){
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
           
        }
       
    }

    handleFieldChange(event, field) {
        const value = event.detail.value;
        const rowId = event.currentTarget.dataset.id;
        const tableName = event.currentTarget.dataset.table;

        this[tableName] = this[tableName].map(row => {
            if (row.id === parseInt(rowId, 10)) {
                return { ...row, [field]: value };
            }
            return row;
        });

        console.log(`${tableName}`, JSON.stringify(this[tableName]));
    }

    buyingInfluences;
    rowId;
    handleBuyingInfluence(event) {
        this.handleFieldChange(event, 'buyingInfluences');

    }

    handleRole(event) {
        this.handleFieldChange(event, 'role');

    }

    handleDegreeOfInfluence(event){
        this.handleFieldChange(event, 'degreeOfInfluence');

    }

    handleMode(event){
        this.handleFieldChange(event, 'mode');
       

    }

    winResult;
    handleWinResults(event){
        this.handleFieldChange(event, 'winResult');
        // this.winResult = event.detail.value;
        // this.rowId = event.currentTarget.dataset.id;

        // let customList = {
        //     "id": this.rowId,
        //     "winResult": this.winResult
        // }
        // if(this.listofBuyingInfluence.length >0){
        //     const objectToReplace = this.listofBuyingInfluence.find(arrayItem => arrayItem.id === customList.id);
        //     if(objectToReplace) {
        //         Object.assign(objectToReplace, customList);
        //     }else{
        //         this.listofBuyingInfluence.push(customList);
        //     }
        // }else{
        //     this.listofBuyingInfluence.push(customList);
        // }
        // console.log('listofBuyingInfluence',JSON.stringify(this.listofBuyingInfluence));

    }

    evidence;
    rowId2;
    handleEvidence(event){
        this.handleFieldChange(event, 'evidence');
    }

    rating;
    handleRating(event){
        this.handleFieldChange(event, 'rating');

    }

    rowId3;
    handleIdeal(event){
        this.handleFieldChange(event, 'idealCustomerCriteria');

    }

    matchCriteria;
    handleMatchRating(event){
        this.handleFieldChange(event, 'matchCriteria');
    }
    flag;
    handleFlagChange(event){
        this.handleFieldChange(event, 'flag');
    }
    summryOfMyPosition;
    handlesummryOfMyPosition(event) {
        this.handleFieldChange(event, 'summryOfMyPosition');

    }
    possibleActions;
    handlepossibleActions(event) {
        this.handleFieldChange(event, 'possibleActions');

    }
    what;
    handlewhat(event) {
        this.handleFieldChange(event, 'what');

    }

    whenDate;
    handlewhen(event) {
        this.handleFieldChange(event, 'whenDate');
    }
    informationNeeded;
    handleinformationNeeded(event){
        this.handleFieldChange(event, 'informationNeeded');
    }
    get formattedCreatedDate() {
        if (this.createdDate) {
            let gmtDate = new Date(this.createdDate);
            return gmtDate.toLocaleString('en-IN', {
                timeZone: 'Asia/Kolkata',
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: 'numeric',
                minute: '2-digit',
                hour12: true
            });
        }
        return '';
    }
    get formattedLastModifiedDate() {
        if (this.lastModifyDate) {
            let gmtDate = new Date(this.lastModifyDate);
            return gmtDate.toLocaleString('en-IN', {
                timeZone: 'Asia/Kolkata',
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: 'numeric',
                minute: '2-digit',
                hour12: true
            });
        }
        return '';
    }
    
    
}