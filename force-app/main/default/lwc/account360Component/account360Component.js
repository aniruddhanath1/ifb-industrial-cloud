import { LightningElement, track, wire, api } from 'lwc';
import getCustomerDetails from '@salesforce/apex/Account360Controller.getAccountData';
import chcekComplaints from '@salesforce/apex/Account360Controller.checkComp';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Account360Component extends LightningElement {
    @api recordId;
    @track customer = {};
    @track error;
    @track showSpinner = true;
    @track redAccount = false;
    @track error;

    @wire(getCustomerDetails, { accountId: '$recordId' })
    getCustomerDetail({ error, data }) {
        if (data) {
            this.customer = data;
            this.error = undefined;
        } else if (error) {
            console.log('error', error);
            this.error = error;
            this.customer = {};
            this.showErrorToast();
        }
        
    }
    connectedCallback() {

        
        // Simulate a delay to show the spinner
        setTimeout(() => {
            this.loading = false;
            this.showSpinner = false;
        }, 10000);
        setTimeout(() => {
            this.checkRedAccount();
        }, 7000);
        
    }

    checkRedAccount(){
        if (!this.customer || !this.customer.complaints || this.customer.complaints.length === 0) {
        console.log('No complaints found.');
        return;
    }

        // Extract complaints list
        const complaintList = this.customer.complaints.map(complaint => {
            return {
                callType: complaint.callType,
                dateOfComplaint: complaint.dateOfComplaint,
                periodOfComplaint: complaint.periodOfComplaint,
                status: complaint.status
            };
        });
        console.log('Complaint List:', JSON.stringify(complaintList));
        chcekComplaints({accountId:this.recordId,compList:complaintList})
            .then((result)=>{
                this.redAccount = result;
            })
            .catch((error)=>{
                this.error = error;
            })
    }

    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'There is some error in retrieving the customer information, Please reach out to your admin.',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}