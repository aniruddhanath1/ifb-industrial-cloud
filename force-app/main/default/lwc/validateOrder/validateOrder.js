import { LightningElement, api } from 'lwc';
import validatePO from '@salesforce/apex/POValidationService.validatePO';


export default class ValidateOrder extends LightningElement {
    @api recordId;
    validationErrors = [];
    successMessage;
    showApprovalPrompt = false;
   


    connectedCallback() {
        this.runValidation(false);
    }


    runValidation(submit) {

        console.log('runValidation-->',submit);
        validatePO({ orderId: this.recordId, submitForApproval: submit })
            .then((result) => {
                this.successMessage = result.successMessage;
                     console.log('result-->',result);
                    console.log('result-->',result.successMessage);
                if (!submit) {
                    this.validationErrors = result.validationErrors;
                } else {
                    this.validationErrors = [];
                   
                }
               
                this.showApprovalPrompt = (
                    result.successMessage ===''
                );
            })
            .catch((error) => {
                console.error(error);
                this.validationErrors = ['Error validating order.'];
            });
    }
   

    handleYesClick() {
        this.runValidation(true);


    }


    handleNoClick() {
        this.handleClose();
    }


    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }
   
}