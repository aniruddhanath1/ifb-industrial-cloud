import {LightningElement, api, track} from 'lwc';
import createLead from '@salesforce/apex/LeadController.createLead'
import leadDuplicateCheck from '@salesforce/apex/LeadController.leadDuplicateCheck'
import {loadStyle} from "lightning/platformResourceLoader";
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class LeadCreationFormChild extends LightningElement {

    @track leadData = {
        accountType: '',
    };
    @track leadSources;
    @track isModalOpen = false;
    @track showSuccess = false;
    @track isduplicate = false;
    @track showError = false;
    @track leadSubSource = '';
    @track sector = '';
    @track customervertical = '';
    @track isComboboxBDisabled = false;
    @track isCUSTOMERComboboxBDisabled = false;
    @track isSameLocation = false;
    @track showspinner = false;
    @track duplicateRecords = [];
    @track shipToNameRequired = true;
    errorMessage;
    @track customerTypeOptions = [
        {label: 'New', value: 'New'},
        {label: 'Existing', value: 'Existing'}
    ];
    @track productCategoryOptions = [
        {label: 'Industrial Laundry Machine', value: 'ILM'},
        {label: 'Industrial Dishwasher', value: 'IDW'},
        {label: 'Both', value: 'Both'}
    ];

    @track operationParakramOptions = [
        {label: 'Yes', value: 'Yes'},
        {label: 'No', value: 'No'}
    ];

    @track sectoroption = [
        {label: 'Private', value: 'Private'},
        {label: 'Government', value: 'Government'}
    ];

    @track columns = [
        {label: 'Name', fieldName: 'Name', type: 'text'},
        {label: 'Company', fieldName: 'Company', type: 'text'},
        {label: 'Category', fieldName: 'Product_Category__c', type: 'text'},
        {label: 'Pincode', fieldName: 'PostalCode', type: 'text'}
    ];

    connectedCallback() {
        this.selectedOption;
    }

    _selectedOption;
    @api
    get selectedOption() {
        return this._selectedOption;
    }

    set selectedOption(value) {
        this._selectedOption = value;
        if (value === 'Partners') {
            this.leadSources = 'Partners';
            this.leadData.LeadSource = 'Partners';
        } else if (value === 'serviceTeam') {
            this.leadSources = 'Industrial Service Team';
            this.leadData.LeadSource = 'Industrial Service Team';
        } else if (value === 'DomesticSalesTeam') {
            this.leadSources = 'Domestic Sales Team';
            this.leadData.LeadSource = 'Domestic Sales Team';
        } else if (value === 'DomesticServiceTeam') {
            this.leadSources = 'Domestic Service Team';
            this.leadData.LeadSource = 'Domestic Service Team';
        } else if (value === 'InstitutionalSales') {
            this.leadSources = 'Institutional Sales';
            this.leadData.LeadSource = 'Institutional Sales';
        }

    }

    get customerSegmentOptions() {
        switch (this.sector) {
            case 'Private':
                return [
                    {label: 'Educational Institutions', value: 'Educational Institutions'},
                    {label: 'Partners', value: 'Partners'},
                    {label: 'Laundromats', value: 'Laundromats'},
                    {label: 'Organization/Entity', value: 'Organization/Entity'},
                    {label: 'Hospitality', value: 'Hospitality'},
                    {label: 'Non-Profit Organization/NGO', value: 'Non-Profit Organization/NGO'},
                    {label: 'Garment', value: 'Garment'},
                    {label: 'HNI', value: 'HNI'},
                    {label: 'Export', value: 'Export'},
                    {label: 'List Of Ministries', value: 'List Of Ministries'}
                ];
            case 'Government':
                return [

                    {label: 'Educational Institutions', value: 'Educational Institutions'},
                    {label: 'List Of Ministries', value: 'List Of Ministries'}
                ];
            default:
                return [];
        }
    }

    get isRequestforQuoteForm() {
        return this.selectedOption === 'RequestforQuoteForm';
    }

    get isPartner() {
        return this.selectedOption === 'Partners';
    }

    get isService() {
        return this.selectedOption == 'serviceTeam' || this.selectedOption == 'DomesticServiceTeam' || this.selectedOption == 'DomesticSalesTeam' || this.selectedOption == 'InstitutionalSales';
    }

    get isServiceTeamSelected() {
        return this.selectedOption == 'serviceTeam';
    }

    get isInstitutionalSales() {
        return this.selectedOption == 'serviceTeam' || this.selectedOption == 'DomesticServiceTeam' || this.selectedOption == 'DomesticSalesTeam' || this.selectedOption === 'Partners';
    }

    get isCustomer() {
        return this.selectedOption == 'Customer';
    }

    get iscallcenter() {
        return this.selectedOption == 'callCenterTeam';
    }

    get isServiceOrPartner() {
        return this.selectedOption === 'serviceTeam' || this.selectedOption === 'Partners' || this.selectedOption == 'DomesticServiceTeam' || this.selectedOption == 'DomesticSalesTeam' || this.selectedOption == 'InstitutionalSales';
    }

    get LeadSourceoptions() {
        if (this.selectedOption === 'serviceTeam') {
            const Options = [
                {label: 'Industrial Service Team', value: 'Industrial Service Team'}
            ];
            this.handeloption();
            return Options;
        }
        if (this.selectedOption === 'DomesticSalesTeam') {
            const Options = [
                {label: 'Domestic Sales Team', value: 'Domestic Sales Team'}
            ];
            this.handeloption();
            return Options;
        }
        if (this.selectedOption === 'DomesticServiceTeam') {
            const Options = [
                {label: 'Domestic Service Team', value: 'Domestic Service Team'}
            ];
            this.handeloption();
            return Options;
        }
        if (this.selectedOption === 'Partners') {
            const Options = [
                {label: 'Partners', value: 'Partners'}
            ];
            this.handeloption();
            return Options;
        }
        if (this.selectedOption === 'InstitutionalSales') {
            const Options = [
                {label: 'Institutional Sales', value: 'Institutional Sales'}
            ];
            this.handeloption();
            return Options;
        }
        return [];
    }

    get LeadSubSourceOption() {
        switch (this.leadSources) {
            case 'Industrial Service Team':
                return [
                    {label: 'Field Team', value: 'Field_Team'},
                    {label: 'Backend Team', value: 'Backend Team'}
                ];
            case 'Domestic Sales Team':
                return [
                    {label: 'CSR', value: 'CSR'},
                    {label: 'TSR', value: 'TSR'},
                    {label: 'Sales Executive', value: 'Sales Executive'},
                    {label: 'CR', value: 'CR'},
                    {label: 'Area Sales Manager', value: 'Area Sales Manager'},
                    {label: 'Business Manager', value: 'Business Manager'},
                    {label: 'Marketing', value: 'Marketing'},
                    {label: 'Branch Sales Manager', value: 'Branch Sales Manager'},
                    {label: 'Regional Sales Manager', value: 'Regional Sales Manager'},
                    {label: 'Zonal Sales Manager', value: 'Zonal Sales Manager'}
                ];
            case 'Domestic Service Team':
                return [
                    {label: 'Service Engineer', value: 'Service Engineer'},
                    {label: 'Service Franchise', value: 'Service Franchise'},
                    {label: 'Service Executives', value: 'Service Executives'},
                    {label: 'Service Engineer-Franchisee', value: 'Service Engineer-Franchisee'},
                    {label: 'Franchisee Owner', value: 'Franchisee Owner'},
                    {label: 'DSO Service Engineer', value: 'DSO Service Engineer'},
                    {label: 'Branch Service Manager', value: 'Branch Service Manager'},
                    {label: 'Regional Service Manager', value: 'Regional Service Manager'}

                ];
            case 'Partners':
                return [
                    {label: 'Dealers - Kitchen equipment supplier', value: 'Dealers - Kitchen equipment supplier'},
                    {label: 'Dealers - Medical equipment supplier', value: 'Dealers - Medical equipment supplier'},
                    {label: 'Dealers - Other equipment supplier', value: 'Dealers - Other equipment supplier'},
                    {label: 'Distributor', value: 'Distributor'},
                    {label: 'Foreigners', value: 'Foreigners'},
                    {label: 'Consultant - Design Consultant', value: 'Consultant - Design Consultant'},
                    {label: 'Consultant - Kitchen Consultant', value: 'Consultant - Kitchen Consultant'},
                    {label: 'Consultant - Laundry Consultant', value: 'Consultant - Laundry Consultant'},
                    {label: 'Consultant - Architect/PMC Consultant', value: 'Consultant - Architect/PMC Consultant'},
                    {label: 'Contractors - Building contractors', value: 'Contractors - Building contractors'},
                    {label: 'Contractors - Canteen contractors', value: 'Contractors - Canteen contractors'},
                    {label: 'Contractors - Laundry contractors', value: 'Contractors - Laundry contractors'},
                    {label: 'Contractors - MES contractors', value: 'Contractors - MES contractors'},
                    {label: 'Institutional dealers', value: 'Institutional dealers'},
                    {label: 'Facility Management Companies', value: 'Facility Management Companies'},
                    {label: 'Domestic Dealers', value: 'Domestic Dealers'},
                    {label: 'Domestic Distributors', value: 'Domestic Distributors'},
                    {
                        label: 'Institutional Partners - AC Dealer/Distributor',
                        value: 'Institutional Partners - AC Dealer/Distributor'
                    }
                ];


            default:
                return [];
        }
    }

    handlePostalChange(event) {
        const postalCodeField = event.target;
        const postalCodeValue = postalCodeField.value;

        const filteredValue = postalCodeValue.replace(/\D/g, '').slice(0, 6);

        postalCodeField.value = filteredValue;

        const postalCodePattern = /^[0-9]{6}$/;
        if (!postalCodePattern.test(filteredValue)) {
            postalCodeField.setCustomValidity("Invalid Pincode");
        } else {
            postalCodeField.setCustomValidity("");
        }

        postalCodeField.reportValidity();

        const {name, value} = event.target;
        this.leadData = {...this.leadData, [name]: value};

    }

    handleInputNameChange(event) {
        const Name = event.target;
        const Namevalue = Name.value;

        const specialCharPattern = /[^a-zA-Z\s]/;

        if (specialCharPattern.test(Namevalue)) {
            Name.setCustomValidity("Invalid Format");
        } else {
            Name.setCustomValidity("");
        }

        Name.reportValidity();

        const {name, value} = event.target;
        this.leadData = {...this.leadData, [name]: value};

    }

    handleEmailChange(event) {
        const Email = event.target;
        const Emailvalue = Email.value;
        const specialCharPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

        if (!specialCharPattern.test(Emailvalue)) {
            Email.setCustomValidity("Invalid Format");
        } else {
            Email.setCustomValidity("");
        }

        Email.reportValidity();
        const {name, value} = event.target;
        this.leadData = {...this.leadData, [name]: value};

    }

    handlePhoneInputChange(event) {
        const phoneField = event.target;
        let phoneValue = phoneField.value;

        phoneValue = phoneValue.replace(/\D/g, '');

        if (phoneValue.length > 10) {
            phoneValue = phoneValue.slice(0, 10);
        }

        phoneField.value = phoneValue;

        const phonePattern = /^[05-9][0-9]{9}$/;
        if (!phonePattern.test(phoneValue)) {
            phoneField.setCustomValidity("Phone number should be 10 digits long and start with 0, 5, 6, 7, 8, or 9.");
        } else {
            phoneField.setCustomValidity("");
        }

        phoneField.reportValidity();
        const {name, value} = event.target;
        this.leadData = {...this.leadData, [name]: value};

    }

    handelSourceInput(event) {
        this.leadSources = event.target.value;
        this.isComboboxBDisabled = this.leadSources === '';
        const {name, value} = event.target;
        this.leadData = {...this.leadData, [name]: value};

        this.leadSubSource = '';

    }

    handleSourceClick() {
        const combobox = this.template.querySelector('lightning-combobox[name="leadSource"]');
        combobox.value = 'Partners';
        this.leadData.leadSource = 'Partners';
    }

    handleSectorInput(event) {
        this.sector = event.target.value;

        this.isCUSTOMERComboboxBDisabled = this.sector === '';
        const {name, value} = event.target;
        this.leadData = {...this.leadData, [name]: value};

        this.customervertical = '';
    }

    handeloption(event) {

        if (this.selectedOption === 'serviceTeam') {
            this.selectedOption === 'serviceTeam' ? this.leadSources = 'Industrial Service Team' : this.leadSources = '';
        } else if (this.selectedOption === 'DomesticSalesTeam') {
            this.selectedOption === 'DomesticSalesTeam' ? this.leadSources = 'Domestic Sales Team' : this.leadSources = '';
        } else if (this.selectedOption === 'DomesticServiceTeam') {
            this.selectedOption === 'DomesticServiceTeam' ? this.leadSources = 'Domestic Service Team' : this.leadSources = '';
        } else if (this.selectedOption === 'Partners') {
            this.selectedOption === 'Partners' ? this.leadSources = 'Partners' : this.leadSources = '';
        } else if (this.selectedOption === 'InstitutionalSales') {
            this.selectedOption === 'InstitutionalSales' ? this.leadSources = 'Institutional Sales' : this.leadSources = '';
        }

    }

    handleCheckboxChange(event) {
        const {name, checked} = event.target;
        this.leadData = {...this.leadData, [name]: checked};
        this.isSameLocation = event.target.checked;
        // this.isSameLocation = !this.isSameLocation;
    }

    handleInputChange(event) {
        const {name, value} = event.target;
        this.leadData = {...this.leadData, [name]: value};


    }

    handleInputDateTime(event) {
        const {name, value} = event.target;
        const dateObject = new Date(value);
        console.log('dateObject---> : ', dateObject);

        // const dateObjectd=this.convertToUTC(dateObject);
        // // console.log('OUTPUTdateObjectd----> : ',dateObjectd);
        // const isoDateString = this.formatDateTimeForSalesforce(dateObject);
        // console.log('isoDateString---> : ',isoDateString);
        this.leadData = {...this.leadData, [name]: dateObject};

    }

    //     convertToUTC(dateTime) {
    //     if (dateTime) {
    //         // Create a date object from the input (which is in local time)
    //         const dateInIST = new Date(dateTime);

    //         // Convert to UTC
    //         const utcDate = new Date(dateInIST.getTime() - (5.5 * 60 * 60 * 1000));

    //         // Format it as an ISO string or whatever format you need
    //         return utcDate.toISOString();
    //     } 
    // }
    formatDateTimeForSalesforce(isoString) {
        // Create a Date object from the input string, which is in IST
        const dateInIST = new Date(isoString);

        // Extract the components directly in IST
        const year = dateInIST.getFullYear();
        const month = String(dateInIST.getMonth() + 1).padStart(2, '0'); // getMonth() is zero-based
        const day = String(dateInIST.getDate()).padStart(2, '0');
        const hours = String(dateInIST.getHours()).padStart(2, '0'); // getHours() gives local time
        const minutes = String(dateInIST.getMinutes()).padStart(2, '0');

        // Return the formatted date-time string for Salesforce
        return `${year}-${month}-${day} ${hours}:${minutes}:00 GMT+0530 (India Standard Time)`;
    }

    backToform() {
        this.isModalOpen = false;
        this.showSuccess = false;
        this.showError = false;
        this.handleBack();
    }

    handleBack() {
        const backEvent = new CustomEvent('back');
        this.dispatchEvent(backEvent);
        this.resetForm();
    }

    handleSave() {

        let isValid = true;
        let fields = this.template.querySelectorAll('lightning-input');
        fields.forEach(field => {
            if (!field.checkValidity()) {
                field.reportValidity();
                isValid = false;
            }
        });

        if (isValid) {

            leadDuplicateCheck({
                CompanyName: this.leadData.Company,
                ProductCategory: this.leadData.Product_Category__c,
                postalCode: this.leadData.Billing_PostalCode__s
            })
                .then(result => {
                    console.log('result' + JSON.stringify(result));
                    if (result && result.length > 0) {
                        console.log('resultduplicateRecords');
                        this.duplicateRecords = result;
                        this.isduplicate = true;
                    } else {
                        console.log('elseduplicateRecords');
                        this.isduplicate = false;
                        this.finalcreatelead();
                    }
                })
                .catch(error => {
                    // Handle error
                    console.error('Error:', error);

                });

        }
    }

    finalcreatelead() {
        this.showspinner = true;
        this.leadData.accountType = this.selectedOption;
        console.log(' this.leadData---> : ', JSON.stringify(this.leadData));
        createLead({ leadDataJson: JSON.stringify(this.leadData) }).then(result => {
                this.showspinner=false;
                 this.isduplicate = false;
                this.isModalOpen = true;
                this.showSuccess = true;
                this.showError = false;
            }).catch(error => {
                 this.isduplicate = false;
                this.showspinner=false;

                this.showSuccess = false;
                this.isModalOpen = true;
                this.showError = true;
                this.errorMessage=JSON.stringify(error);
            });
    }


    resetForm() {
        this.selectedOption = '';
        this.leadData = {};
        this.isSameLocation = false;
        this.clearInputFields();

    }

    clearInputFields() {
        // Example code, adjust selectors based on your HTML structure
        const inputFields = this.template.querySelectorAll('lightning-input');
        inputFields.forEach(field => {
            field.value = '';
        });
    }

    get isSaveDisabled() {

        return !this.isFormValid();
    }

    validateForm() {
        this.template.querySelector('lightning-button[label="Submit"]').disabled = !this.isFormValid();
    }


    isFormValid() {
        if (this.selectedOption == 'customer') {
            return this.isCustomerFormValid();
        } else if (this.selectedOption == 'serviceTeam') {
            return this.isServiceTeamFormValidForNonDomestic();
        } else if (this.selectedOption == 'DomesticSalesTeam') {
            return this.isServiceTeamFormValid();
        } else if (this.selectedOption == 'DomesticServiceTeam') {
            return this.isServiceTeamFormValid();
        } else if (this.selectedOption == 'InstitutionalSales') {
            return this.isInstitutionalSalesTeamFormValid();
        } else if (this.selectedOption == 'callCenterTeam') {
            return this.isCallCenterTeamFormValid();
        } else if (this.selectedOption == 'Partners') {
            return this.isPartnersValid();
        } else if (this.selectedOption == 'RequestforQuoteForm') {
            return this.isCallRequestforQuoteFormValid();
        }
        return false;
    }

    isCustomerFormValid() {

        return (
            this.leadData.Type_of_Customer__c &&
            this.leadData.LastName &&
            this.leadData.Phone &&
            this.leadData.Company &&
            this.leadData.Product_Category__c &&
            this.leadData.IsSameLocation || this.leadData.Billing_PostalCode__s
        );
    }

    isServiceTeamFormValid() {
        return (
            this.leadData.LeadSource &&
            this.leadData.Lead_Sub_Source__c &&
            this.leadData.Type_of_Customer__c &&
            this.leadData.FirstName &&
            this.leadData.LastName &&
            this.leadData.Phone &&
            this.leadData.Operation_Parakram__c &&
            this.leadData.Company &&
            this.leadData.Product_Category__c &&
            this.leadData.Sub_Source_Phone_number__c &&
            (this.leadData.IsSameLocation || this.leadData.Billing_PostalCode__s)
        );

    }

    isInstitutionalSalesTeamFormValid() {
        return (
            this.leadData.LeadSource &&

            this.leadData.Type_of_Customer__c &&
            this.leadData.FirstName &&
            this.leadData.LastName &&
            this.leadData.Phone &&
            this.leadData.Operation_Parakram__c &&
            this.leadData.Company &&
            this.leadData.Product_Category__c &&
            this.leadData.Sub_Source_Phone_number__c &&
            (this.leadData.IsSameLocation || this.leadData.Billing_PostalCode__s)
        );
    }

    isServiceTeamFormValidForNonDomestic() {
        return (
            this.leadData.LeadSource &&
            this.leadData.Lead_Sub_Source__c &&
            this.leadData.Type_of_Customer__c &&
            this.leadData.FirstName &&
            this.leadData.LastName &&
            this.leadData.Phone &&
            this.leadData.Company &&
            this.leadData.Product_Category__c &&
            this.leadData.Sub_Source_Phone_number__c &&
            (this.leadData.IsSameLocation || this.leadData.Billing_PostalCode__s)
        );
    }


    isCallCenterTeamFormValid() {

        return (
            this.leadData.Type_of_Customer__c &&
            this.leadData.LastName &&
            this.leadData.Phone &&
            this.leadData.Company &&
            this.leadData.Product_Category__c &&
            this.leadData.Call_Centre_Remarks__c &&
            (this.leadData.IsSameLocation || this.leadData.Billing_PostalCode__s));


    }

    isPartnersValid() {
        return (
            this.leadData.LeadSource &&
            this.leadData.Lead_Sub_Source__c &&
            this.leadData.Type_of_Customer__c &&
            this.leadData.FirstName &&
            this.leadData.LastName &&
            this.leadData.Phone &&
            this.leadData.Company &&
            this.leadData.Product_Category__c &&
            this.leadData.Partner_Name__c &&
            this.leadData.Partner_Email__c &&
            (
                (this.leadData.Lead_Sub_Source__c === 'Foreigners' && this.leadData.Billing_Country__s) ||
                (this.leadData.Lead_Sub_Source__c !== 'Foreigners' && this.leadData.Billing_PostalCode__s)
            )
        );
    }

    isCallRequestforQuoteFormValid() {
        return (
            this.leadData.LastName &&
            this.leadData.FirstName &&
            this.leadData.Company &&
            this.leadData.Billing_PostalCode__s &&
            this.leadData.Product_Category__c
        );

    }
}