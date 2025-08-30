import { LightningElement, api, wire, track } from 'lwc';
import oppRecord from '@salesforce/apex/OpportunityIDWTableComponentController.getOppRecord';

import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from "lightning/platformShowToastEvent"; 

import saveRecord from '@salesforce/apex/OpportunityIDWTableComponentController.saveRecord';
import { CurrentPageReference } from 'lightning/navigation';
export default class OpportunityIDWComponent extends LightningElement {    @api recordId;
    @track oppRecord;

    @track defaultValue1;
    @track defaultValue2;
    @track defaultValue3;
    @track defaultValue4;
    @track defaultValue5;
    @track defaultValue6;
    @track defaultValue7;
    @track defaultValue8;
    @track defaultValue9;
    @track defaultValue10;
    @track currentLoginUserName;
    @track currentDateNow = new Date().toJSON().slice(0, 10);
    @track currentOppName;
    
    get options() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' }
        ];
    }
   

    connectedCallback() {
        console.log(this.recordId);
        oppRecord({ oppRecordId: this.recordId})
            .then(result => {
                console.log('result fetching metadata:', result);
                this.oppRecord = result;
                
                this.oppRecord = JSON.parse(JSON.stringify(this.oppRecord));
                console.log(' fieldApiName ',this.oppRecord.Machine_Dimensions_w_d_h_Space_Req__c);
                this.fillExistingValueAsADefault();
            })
            .catch(error => {
                console.error('Error fetching metadata:', error);
            });
    }

    fillExistingValueAsADefault(){
        this.defaultValue1 = this.oppRecord.Machine_Dimensions_w_d_h_Space_Req__c; 
        this.defaultValue2 = this.oppRecord.Total_Power_Req_Connected_Load__c; 
        this.defaultValue3 = this.oppRecord.Electric_Connection_Incoming_Supp_Vol__c; 
        this.defaultValue4 = this.oppRecord.MCB_Rating__c; 
        this.defaultValue5 = this.oppRecord.Required_Power_Cable_Size_Rating__c; 
        this.defaultValue6 = this.oppRecord.Water_Hardness__c; 
        this.defaultValue7 = this.oppRecord.Required_Intel_Water_Pressure__c; 
        this.defaultValue8 = this.oppRecord.Water_Intel_Size_With_Ball_Value_M_T_S__c; 
        this.defaultValue9 = this.oppRecord.Drain_Outlet_Size_Gravity_Drain_Req__c;
        this.defaultValue10 = this.oppRecord.Model__c; 
        this.currentOppName = this.oppRecord.Name;
        this.currentLoginUserName = this.oppRecord.Owner.Name;
    }


    handleChange(event) {
        this.value = event.detail.value;
        let fieldApiName  = event.target.dataset.fieldapiname;
        console.log(' value ',this.value);
        console.log(' fieldApiName ',this.oppRecord);
        this.oppRecord[fieldApiName] = this.value;

        console.log(' this.oppRecord ',this.oppRecord);
    }

    handleSave(){
        saveRecord({oppRecordFromLwc : this.oppRecord})
        .then( result => {
            this.showNotification('Success','Your record save successfully','success');
        }).catch( error => {
            this.showNotification('Error',error,'error');
        });
    }

    closeAction(){
        const event = new CustomEvent('callparentmethod', {
            detail: { message: 'Hello from Child Component!' }
        });
        this.dispatchEvent(event);
    }

    showNotification(titleMessage,messageText,variant) {
        const evt = new ShowToastEvent({
        title: titleMessage,
        message: messageText,
        variant: variant,
        });
        this.dispatchEvent(evt);
        this.closeAction(); 

  }
}