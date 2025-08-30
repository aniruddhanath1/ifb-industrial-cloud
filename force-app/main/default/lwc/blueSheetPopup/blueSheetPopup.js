import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import RED_FLAG_FIELD from '@salesforce/schema/Opportunity.Red_Flags__c';
import AMOUNT_FIELD from '@salesforce/schema/Opportunity.Amount';

const fields = [AMOUNT_FIELD, RED_FLAG_FIELD];

export default class BlueSheetPopup extends LightningElement {
    @api recordId;
    @track modalPopup = false;

    @wire(getRecord, { recordId: "$recordId", fields })
    bluesheet({ error, data }) {
        if (data) {
            console.log('Wire Data:', JSON.stringify(data));
            this.amount = getFieldValue(data, AMOUNT_FIELD);
            let redflag = getFieldValue(data, RED_FLAG_FIELD);
            if (this.amount >= 2500000 && redflag == null) {
                this.modalPopup = true;
            }
        } else if (error) {
            console.error('Error:', error);
        }
    }

    handleSave() {
        const genericCmp = this.template.querySelector('c-generic-blue-sheets-cmp');
        if (genericCmp) {
            genericCmp.handleSave();
        }
    }

    handleSaveEvent(event) {
        console.log('Init');
        this.modalPopup = event.detail;
    }
}