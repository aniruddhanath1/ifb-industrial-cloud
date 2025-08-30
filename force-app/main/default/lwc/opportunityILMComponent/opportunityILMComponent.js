import { LightningElement, api, track, wire } from 'lwc';

import oppRecord from '@salesforce/apex/OpportunityILMTableComponentController.getOppRecord';
import saveRecord from '@salesforce/apex/OpportunityILMTableComponentController.saveRecord';

import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import { CurrentPageReference } from 'lightning/navigation';


export default class OpportunityILMComponent extends LightningElement {
    @api recordId;

    @track listOfWrapper = [];
    @track currentLoginUserName;
    @track currentDateNow = new Date().toJSON().slice(0, 10);
    @track currentOppName;



    connectedCallback() {
        console.log(this.recordId);
        oppRecord({ oppRecordId: this.recordId })
            .then(result => {
                this.currentLoginUserName = result.loginUserName;
                this.currentOppName = result.currentOppNameWrapper;
                let tempList = [];
                let tempMap = new Map();

                console.error('result fetching metadata:', result);
                result.childWrapperList.forEach(function (currentItem, index) {
                    tempMap.set(currentItem.sequenceNumber, currentItem);
                });

                console.log(' tempMap ', tempMap.keys());

                let tempArray = [];
                tempMap.forEach(function (currentItem, index) {
                    console.log(' currentItem currentItem ', currentItem);
                    tempArray.push(currentItem.sequenceNumber);
                });
                console.log(' tempArray 123 ', JSON.parse(JSON.stringify(tempArray)));
                tempArray = JSON.parse(JSON.stringify(tempArray));

                let myIndex = 1;
                tempArray.forEach(function (key, index) {
                    let tempData = JSON.parse(JSON.stringify(tempMap.get(myIndex)));
                    tempData.indexOfData = index + 1;
                    console.log(' tempData --> ', tempData);
                    tempList.push(tempData);
                    myIndex = myIndex + 2;
                });
                this.listOfWrapper = tempList;
                console.log(' this.listOfWrapper ', this.listOfWrapper);

            })
            .catch(error => {
                console.error('Error fetching metadata:', error);
            });
    }

    handleCombobox(event) {
        let sequenceNumber = parseInt(event.target.dataset.sequence);
        let tempObj = JSON.parse(JSON.stringify(this.listOfWrapper[sequenceNumber]));
        tempObj.fieldCurrentValue = event.target.value;
        this.listOfWrapper[sequenceNumber] = tempObj;
    }

    handleRemark(event) {
        let sequenceNumber = parseInt(event.target.dataset.sequenc);
        let tempObj = JSON.parse(JSON.stringify(this.listOfWrapper[sequenceNumber]));
        tempObj.remarkValue = event.target.value;
        this.listOfWrapper[sequenceNumber] = tempObj;
    }

    handleSave() {
        saveRecord({ childListForSave: this.listOfWrapper, opportunityId: this.recordId })
            .then(result => {
                this.showNotification('Success', 'Your record save successfully', 'success');
            }).catch(error => {
                this.showNotification('Error', error, 'error');
            });
    }

    closeAction() {
        const event = new CustomEvent('callparentmethod', {
            detail: { message: 'Hello from Child Component!' }
        });
        this.dispatchEvent(event);
    }

    showNotification(titleMessage, messageText, variant) {
        const evt = new ShowToastEvent({
            title: titleMessage,
            message: messageText,
            variant: variant,
        });
        this.dispatchEvent(evt);
        this.closeAction();

    }

}