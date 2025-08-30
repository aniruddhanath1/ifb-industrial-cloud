import { LightningElement, api , track , wire } from 'lwc';
import productCategory from '@salesforce/apex/PreInstallationOpportunityController.getProductCategory';
import { CurrentPageReference } from 'lightning/navigation';
import modal from "@salesforce/resourceUrl/QucikActionSize";
import { loadStyle } from "lightning/platformResourceLoader";
import { CloseActionScreenEvent } from 'lightning/actions';

export default class PreInstallationParentComponent extends LightningElement {
     @api recordId;
    @track isILM = false;
    @track isIDW = false;

    @track isError = false;

 
    connectedCallback() {
        console.log('OppID',this.recordId)
         productCategory({ oppRecordId: this.recordId})
            .then(result => {
                console.log(' result --> ',result);
                if(result == 'ILM'){
                    this.isILM = true;
                }else if(result == 'IDW'){
                    this.isIDW = true;
                }else{
                    this.isError = true;
                }
            })
            .catch(error => {
                console.error('Error fetching metadata:', error);
            });
    }
    renderedCallback(){
        loadStyle(this, modal);
    }
    closeActionModel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
        window.location.reload()
    }
}