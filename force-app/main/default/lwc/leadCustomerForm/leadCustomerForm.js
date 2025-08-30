import { LightningElement,track } from 'lwc';
import logo from '@salesforce/resourceUrl/ifblogo';
export default class LeadCustomerForm extends LightningElement {
    logo = logo;
    // Set default value
    @track showheader = true;
    @track showParent = false; // Initially hide parent
    @track showChild = false;
    @track showSpinner = false; // Controls the spinner visibility
    @track hasError = false;
    
@track selectedOption = 'customer';
errorMessage = 'Select Your Team';
 lastSelectedOption;
   connectedCallback() {
        this.handleNext(); // Automatically trigger handleNext on initialization
    }

accountOptions = [
         { label: 'Customer', value:'customer' }
    ];
    
  
    // This will hold the last selected option when navigating back
    lastSelectedOption;

    connectedCallback() {
        this.handleNext(); // Automatically trigger handleNext on initialization
    }

    handleOptionChange(event) {
        this.selectedOption = event.detail.value;
        console.log('OUTPUT : ', this.selectedOption);
    }

    handleNext() {
        console.log('handleNext :');
        // Store the selected option
        this.lastSelectedOption = this.selectedOption;
        // Hide the parent component and show the child component
        this.showParent = false;
        this.showChild = true;
        this.hasError = false;
    }

    handleBack() {
        // Show spinner before navigating back
        this.showSpinner = true;
        setTimeout(() => {
            // Hide the spinner and show the parent component
            this.showSpinner = false;
            this.showChild = false;
            this.showParent = true;
            // Reapply the selected option and trigger the child component to be displayed again
            this.selectedOption = this.lastSelectedOption;
            // Automatically navigate to the child component again after hiding spinner
            setTimeout(() => {
                this.showParent = false;
                this.showChild = true;
            }, 0); // Use timeout to ensure DOM updates before re-showing child
        }, 2000); // Spinner display time
    }

    handleError(error) {
        this.hasError = true;
        this.errorMessage = error.message;
    }
}