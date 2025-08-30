import { LightningElement, api, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class BlueSheetCmp extends LightningElement {
    @api recordId;
    @track showPdf = false;
    @track disableExportButton = true;
    vfHost = '/apex/PDFgenerator';

    handleSave() {
        // Dispatch a custom event to the child component to trigger the save functionality
        this.template.querySelector('c-generic-blue-sheets-cmp').handleSave();
        
    }
    handlePDF() {
        this.vfHost = this.vfHost + '?id=' + this.recordId;
        this.showPdf = true;
    }
    handleSaveCompleted(event) {
        // Update the disableExportButton based on the event's detail
        this.disableExportButton = event.detail.disableExport;
    }

    handleSaveFromChild(event) {
        // Handle the save event from the child component if needed
       // console.log('Save event from child component:', event.detail);
        //this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleClose() {
        /*const closeEvent = new CustomEvent('close');
        this.dispatchEvent(closeEvent);
        */
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}