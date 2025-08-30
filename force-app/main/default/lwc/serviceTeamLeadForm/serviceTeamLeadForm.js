import {LightningElement, api, track} from 'lwc';
import logo from '@salesforce/resourceUrl/ifblogo';

export default class ServiceTeamLeadForm extends LightningElement {
    logo = logo;
    @track selectedOption;
    @track showheader = true;
    @track showParent = true;
    @track showChild = false;
    @track hasError = false;
    @track errorMessage = 'Select Your Team';
    accountOptions = [
        {
            label: 'Channel Partner',
            value: 'Partners',
            description: 'Standard lead qualification and conversion process.'
        },
        {label: 'Institutional Sales', value: 'InstitutionalSales'},
        {label: 'Domestic Sales team', value: 'DomesticSalesTeam'},
        {label: 'Domestic Service Team', value: 'DomesticServiceTeam'},
        {label: 'Industrial Service Team', value: 'serviceTeam'},
        {label: 'Call Center Team', value: 'callCenterTeam'}
    ];

    handleOptionChange(event) {
        this.selectedOption = event.detail.value;
        console.log('OUTPUT : ', this.selectedOption);
    }

    handleNext() {
        // Hide the parent component and show the child component
        if (this.selectedOption) {
            this.showParent = false;
            this.showChild = true;
            this.hasError = false;
        } else {
            this.hasError = true;
        }
    }


    // Method to set the error
    handleError(error) {
        this.hasError = true;
        this.errorMessage = error.message;
    }

    handleBack() {
        console.log('handleBack : ');
        // Hide the child component and show the parent component
        this.showChild = false;
        this.showParent = true;
    }
}