import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import modal from "@salesforce/resourceUrl/QucikActionSize";
import PROCATEGORY_FIELD from '@salesforce/schema/Invoice__c.Product_Category__c';
const fields = [PROCATEGORY_FIELD];

export default class GenerateAndShowPDFVFPage extends LightningElement {
    @api recordId;
    productCategoryILM = false;
    productCategoryIDW = false;
    productILMType = '';
    productIDwType = '';
    
   // this picklist values for ILM Product Category
    ilmPdfOptions = [
        { label: 'ILM RGFE PDF', value: 'ILMRGFE' },
        { label: 'ILM EXPORT PDF', value: 'ILMEXPORT' },
        { label: 'ILM BRANCH PDF', value: 'ILMBRANCH' },
        { label: 'BILM CUSTOMER PDF', value: 'ILMCUSTOMER' },

    ];
    // this picklist values for IDW Product Category
    idwPdfOptions = [
        { label: 'IDW HUB PDF', value: 'IDWHUB' },
        { label: 'IDW BRANCH PDF', value: 'IDWBRANCH' },
    ];
    
    // this handlechange method is use for pick the change values of ILM
    handleILMPdfChange(event) {

        this.productILMType = event.target.value;
    }
    // this handlechange method is use for pick the change values of IDW
    handleIDWPdfChange(event) {

        this.productIDWType = event.target.value;
    }

    /*@wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        console.log(' currentPageReference currentPageReference ',currentPageReference);
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
            // this.openPage();
        }
    }*/ 

    // this wire method is use to check the product category of Invoice
    @wire(getRecord, { recordId: "$recordId", fields })
    lead({ error, data }) {
        if (error) {
            //this.error = error;
            console.log('error getRecord ', error);
        } else if (data) {
            console.log('data leadReject ', data);
            if (data.fields.Product_Category__c.value) {
                if (data.fields.Product_Category__c.value == 'IDW') {
                    this.productCategoryIDW = true;
                } else if (data.fields.Product_Category__c.value == 'ILM') {
                    this.productCategoryILM = true;
                }
            }
        }
    }
 
    // this openILMPage method is use to open the particular ILM Related Pdf
    openILMPage(event) {
        if (this.isInputValid()) {
            console.log(' recordId recordId ', JSON.stringify(event.target.title));
            console.log(' product type ', JSON.stringify(this.productType));
            let buttonTitle = event.target.title;
            if (this.productILMType == 'ILMRGFE') {
                window.open(window.location.origin + '/apex/ILMPdfGenerate?id=' + this.recordId + '&typeofpdf=ILM_RGFE');
            } else if (this.productILMType == 'ILMEXPORT') {
                window.open(window.location.origin + '/apex/ILMPdfGenerate?id=' + this.recordId + '&typeofpdf=ILM_EXPORT');
            } else if (this.productILMType == 'ILMBRANCH') {
                window.open(window.location.origin + '/apex/ILMPdfGenerate?id=' + this.recordId + '&typeofpdf=ILM_BRANCH');
            } else if (this.productILMType == 'ILMCUSTOMER') {
                window.open(window.location.origin + '/apex/ILMPdfGenerate?id=' + this.recordId + '&typeofpdf=ILM_CUSTOMER');
            }
            this.closeQuickActionModal();
        }
    }
   
    // this openILMPage method is use to open the particular IDW Related Pdf
    openIDWPage(event) {
        if (this.isInputValid()) {
            console.log(' recordId recordId ', JSON.stringify(event.target.title));
            console.log(' product type ', JSON.stringify(this.productIDWType));
            if (this.productIDWType == 'IDWHUB') {
                window.open(window.location.origin + '/apex/ILMPdfGenerate?id=' + this.recordId + '&typeofpdf=IDW_HUB');
            } else if (this.productIDWType == 'IDWBRANCH') {
                window.open(window.location.origin + '/apex/ILMPdfGenerate?id=' + this.recordId + '&typeofpdf=IDW_BRANCH');
            }
            this.closeQuickActionModal();
        }

    }


    // window.open(window.location.origin+'/apex/ILMPdfGenerate?id='+this.recordId+'&typeofpdf=ILM_RGFE');
    //window.open(window.location.origin+'/apex/ILMPdfGenerate?id='+this.recordId+'&typeofpdf=ILM_EXPORT');
    //window.open(window.location.origin+'/apex/ILMPdfGenerate?id='+this.recordId+'&typeofpdf=ILM_BRANCH');
    // window.open(window.location.origin+'/apex/ILMPdfGenerate?id='+this.recordId+'&typeofpdf=ILM_CUSTOMER');
    // window.open(window.location.origin+'/apex/ILMPdfGenerate?id='+this.recordId+'&typeofpdf=IDW_HUB');
    // window.open(window.location.origin+'/apex/ILMPdfGenerate?id='+this.recordId+'&typeofpdf=IDW_BRANCH');




   // this handlecloseclick method is use to close the model
    handlecloseClick() {
        this.closeQuickActionModal();
    }

    closeQuickActionModal(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
        window.location.reload()
    }
   
   // this isInputValid method is use to validate the picklist values select or not after the open pdf button click
    isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }   
        });
        return isValid;
    }

    
   /* closeActionModel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
        window.location.reload()
    }*/

}