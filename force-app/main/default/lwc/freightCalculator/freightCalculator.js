import { LightningElement,track,wire,api } from 'lwc';
import getProductsfromQuoteLine from '@salesforce/apex/FreightCalculatorController.getProductsfromQuoteLine';
import getFreightPrice from '@salesforce/apex/FreightCalculatorController.getFreightPrice';
import getVehicleCapacities from '@salesforce/apex/FreightCalculatorController.getVehicleCapacities';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Custom_Quote from '@salesforce/schema/SBQQ__Quote__c';
import Vehicle_1 from '@salesforce/schema/SBQQ__Quote__c.Vehicle_1__c';
import Vehicle_2 from '@salesforce/schema/SBQQ__Quote__c.Vehicle_2__c';
import Vehicle_3 from '@salesforce/schema/SBQQ__Quote__c.Vehicle_3__c';
import Vehicle_4 from '@salesforce/schema/SBQQ__Quote__c.Vehicle_4__c';
import STATE_FIELD from '@salesforce/schema/SBQQ__Quote__c.SBQQ__ShippingState__c';
import CITY_FIELD from '@salesforce/schema/SBQQ__Quote__c.SBQQ__ShippingCity__c';
import { getRecord } from 'lightning/uiRecordApi';
import updatingQuote from '@salesforce/apex/FreightCalculatorController.updatingQuote';
import Freight_Calculated_On_State__c from '@salesforce/schema/SBQQ__Quote__c.Freight_Calculated_On_State__c';
import Freight_Calculated_On_City__c from '@salesforce/schema/SBQQ__Quote__c.Freight_Calculated_On_City__c';
import { NavigationMixin } from 'lightning/navigation';


const FIELDS = [STATE_FIELD, CITY_FIELD];
export default class FreightCalculator extends NavigationMixin(LightningElement)  {
    @api recordId;
    @track products;
    @track freightMetadata;
    @track vehicleOneOption;
    @track vehicleTwoOption;
    @track vehicleThreeOption;
    @track vehicleFourOption;
    @track vehicleOne;
    @track vehicleTwo;
    @track vehicleThree;
    @track vehicleFour;
    @track capacityUtilisation = 0;
    @track TotalArea =0;
    @track VehicleOneCapacity = 0;
    @track VehicleTwoCapacity = 0;
    @track VehicleThreeCapacity = 0;
    @track VehicleFourCapacity = 0;
    @track TotalCapacity;
    @track TotalCapacityUtilisation;
    @track TotalCapacityUtilisationPercentage;
    @track ModelAreaMap = new Map();
    @track freightPrice = 0;
    @track VehicleOnePrice = 0;
    @track vehicleTwoPrice = 0;
    @track vehicleThreePrice = 0;
    @track vehicleFourPrice = 0;
    @track priceList;
    @track leftArea;
    @track VehicleOneCapacityUtilization;
    @track VehicleTwoCapacityUtilization;
    @track VehicleThreeCapacityUtilization;
    @track VehicleFourCapacityUtilization;
    @track vehicleCapacities = {};
    @track shippingCityStateError = false;
    @track stateOptions = [];
    @track cityOptions = [];
    @track allCityOptions = [];
    @track allCityOptionsData = [];
    @track selectedState = 'KARNATAKA';
    @track selectedCity;
    @track priceListNotFound = false;
    
    columns = [
        { label: 'Name', fieldName: 'productName', type: 'text', sortable: true },
        { label: 'Model', fieldName: 'Model', type: 'text', sortable: true },
        { label: 'Area Feet', fieldName: 'areaFeet', type: 'text', sortable: true },
        { label: 'Quantity', fieldName: 'quantity', type: 'number', sortable: true }
    ];

    @wire(getObjectInfo, { objectApiName: Custom_Quote})
    objectInfo;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Vehicle_1 })
    VehicleValue({ error, data }) {
        if (data) {
            this.vehicleOneOption = data.values;
            
        } else if (error) {
            console.error('Error fetching picklist values:', error);
            this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Vehicle_2 })
    VehicleValueTwo({ error, data }) {
        if (data) {
            this.vehicleTwoOption = data.values;
        } else if (error) {
            console.error('Error fetching picklist values:', error);
            this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Vehicle_3 })
    VehicleValueThree({ error, data }) {
        if (data) {
            this.vehicleThreeOption = data.values;
        } else if (error) {
            console.error('Error fetching picklist values:', error);
            this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Vehicle_4 })
    VehicleValueFour({ error, data }) {
        if (data) {
            this.vehicleFourOption = data.values;
        } else if (error) {
            console.error('Error fetching picklist values:', error);
            this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
        }
    }
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.state = data.fields.SBQQ__ShippingState__c.value;
            this.city = data.fields.SBQQ__ShippingCity__c.value;
            if(this.state == null && this.city == null){
                this.shippingCityStateError = true; 
                this.showToast('Warning', 'Shipping State and City are not filled. Please select Shipping State and City here to calculate freight. ', 'warning');
            }else{
               this.selectedCity =  data.fields.SBQQ__ShippingCity__c.value;
               this.selectedState = data.fields.SBQQ__ShippingState__c.value;
            }
        } else if (error) {
            console.error('Error fetching record:', error);
            this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
        }
    }
    
    

    connectedCallback() {
        console.log('fetching products');
        this.fetchProductFromQuoteLines();
        
        getVehicleCapacities()
        .then(result => {
            this.vehicleCapacities = result;
        })
        .catch(error => {
            console.error('Error fetching vehicle capacities:', error);
            this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
        });
       
    }
    fetchProductFromQuoteLines() {
        getProductsfromQuoteLine({ recordId: this.recordId })
            .then(result => {
                this.products = result;
                console.log('result'+JSON.stringify(result));
                console.log('product List'+JSON.stringify(this.products));
                result.forEach(productLine => {
                    const productSize = parseFloat(productLine.areaFeet) || 0;
                    const productQuantity = parseFloat(productLine.quantity) || 0;
                    // Calculate the area for the current product line
                    const lineArea = productSize * productQuantity;
    
                    // Add the line area to the total area
                    this.TotalArea += lineArea;
                });
                
            })
            .catch(error => {
                console.error('Error fetching products:', error);
                this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
            });
    }
    handleInputChange(event){
        let label = event.target.dataset.label;
        let quantity = event.target.value;
        let Area = parseFloat(event.target.dataset.area);
 
        this.ModelAreaMap.set(label,Area*quantity);
     }
    
     handleVehicleChange(event){
         
         
         let label = event.target.dataset.label;
         let value = event.target.value;
         console.log(label);
         console.log(value);
         
 
         if (label === 'Vehicle 1') {
             this.vehicleOne = value;
         } else if (label === 'Vehicle 2') {
             this.vehicleTwo = value;
         } else if (label === 'Vehicle 3') {
             this.vehicleThree = value;
         } else if (label === 'Vehicle 4') {
             this.vehicleFour = value;
         }
         this.calculateLeftArea(this.vehicleCapacities);
         
     }
     calculateLeftArea(vehicleCapacities) {
         this.leftArea = this.TotalArea - 
             (vehicleCapacities[this.vehicleOne] || 0) - 
             (vehicleCapacities[this.vehicleTwo] || 0) - 
             (vehicleCapacities[this.vehicleThree] || 0) - 
             (vehicleCapacities[this.vehicleFour] || 0);
         
         console.log('Left Area:', this.leftArea);
     }
     handleSave(){
         console.log(this.selectedState);
         console.log(this.selectedCity);
         getFreightPrice({
             state: this.selectedState,
             city: this.selectedCity
         })
         .then(result => {
             if(result != null){
                this.priceList = result;
                console.log(this.priceList.Tata_Ace__c+'getting price list from metadata');
                // Assuming result contains the freight prices
                console.log(this.vehicleOne+'vehicle one');
                if (this.vehicleOne === 'Tata Ace') {
                    this.vehicleOnePrice = this.priceList.Tata_Ace__c;
                    console.log(this.vehicleOnePrice);
                } else if (this.vehicleOne === '14') {
                    this.vehicleOnePrice = this.priceList.X14__c;
                } else if (this.vehicleOne === '17') {
                    this.vehicleOnePrice = this.priceList.X17__c;
                } else if (this.vehicleOne === '19') {
                    this.vehicleOnePrice = this.priceList.X19__c;
                } else if (this.vehicleOne === '22') {
                    this.vehicleOnePrice = this.priceList.X22__c;
                }
        
                if (this.vehicleTwo === 'Tata Ace') {
                    this.vehicleTwoPrice = this.priceList.Tata_Ace__c;
                } else if (this.vehicleTwo === '14') {
                    this.vehicleTwoPrice = this.priceList.X14__c;
                } else if (this.vehicleTwo === '17') {
                    this.vehicleTwoPrice = this.priceList.X17__c;
                } else if (this.vehicleTwo === '19') {
                    this.vehicleTwoPrice = this.priceList.X19__c;
                } else if (this.vehicleTwo === '22') {
                    this.vehicleTwoPrice = this.priceList.X22__c;
                }
        
                if (this.vehicleThree === 'Tata Ace') {
                    this.vehicleThreePrice = this.priceList.Tata_Ace__c;
                } else if (this.vehicleThree === '14') {
                    this.vehicleThreePrice = this.priceList.X14__c;
                } else if (this.vehicleThree === '17') {
                    this.vehicleThreePrice = this.priceList.X17__c;
                } else if (this.vehicleThree === '19') {
                    this.vehicleThreePrice = this.priceList.X19__c;
                } else if (this.vehicleThree === '22') {
                    this.vehicleThreePrice = this.priceList.X22__c;
                }
        
                if (this.vehicleFour === 'Tata Ace') {
                    this.vehicleFourPrice = this.priceList.Tata_Ace__c;
                } else if (this.vehicleFour === '14') {
                    this.vehicleFourPrice = this.priceList.X14__c;
                } else if (this.vehicleFour === '17') {
                    this.vehicleFourPrice = this.priceList.X17__c;
                } else if (this.vehicleFour === '19') {
                    this.vehicleFourPrice = this.priceList.X19__c;
                } else if (this.vehicleFour === '22') {
                    this.vehicleFourPrice = this.priceList.X22__c;
                }
                if(this.TotalArea>0){
                    this.TotalCapacity = (100-((this.leftArea*100)/this.TotalArea)).toFixed(2);
                }else{
                    this.TotalCapacity = 0;
                }
                this.freightPrice = this.vehicleOnePrice+this.vehicleTwoPrice+this.vehicleThreePrice+this.vehicleFourPrice;
             }else{
                this.priceListNotFound = true;
                this.selectedState = null;
                this.selectedCity = null;
                this.showToast('Warning', 'Price list mapping not found for this Shipping State and City. Please try another. ', 'warning');
             }
         })
         .catch(error => {
             console.error('Error fetching freight price:', error);
             this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
         });
         
     }
     UpdateQuote(){
         updatingQuote({
             quoteId: this.recordId,
             vehicle1: this.vehicleOne,
             vehicle2: this.vehicleTwo,
             vehicle3: this.vehicleThree,
             vehicle4: this.vehicleFour,
             capacity: this.TotalCapacity,
             freightPrice: this.freightPrice,
             TotalArea: this.TotalArea,
             freightCity: this.selectedCity,
             freightState: this.selectedState
         })
         .then(result => {
             // Handle success - maybe show a toast message or something
             console.log('Quote updated successfully');
             //this.dispatchEvent(new CustomEvent('close'));
             this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    actionName: 'view'
                }
            });
             
         })
         .catch(error => {
             // Handle error
             console.error('Error updating quote:', error);
             this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
         });
     }
    formatNumber(number) {
        return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
    
    get formattedFreightPrice() {
        return this.formatNumber(this.freightPrice);
    }
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Freight_Calculated_On_State__c })
    stateValues({ error, data }) {
        if (data) {
            this.stateOptions = data.values;
        } else if (error) {
            console.error('Error fetching picklist values:', error);
            this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
        }
    }

    @wire(getPicklistValues, {recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName : Freight_Calculated_On_City__c})
    cityValues({error,data}){
        if (data) {
           
            this.allCityOptionsdata = data;
            this.allCityOptions = data.values;
        } else if (error) {
            console.error('Error fetching picklist values:', error);
            this.showToast('Error', 'There was an error processing your request. Please contact your administrator.', 'error');
        }
    }

    handleStateChange(event) {
        this.selectedState = event.detail.value;
        let key = this.allCityOptionsdata.controllerValues[event.target.value];
        this.cityOptions = this.allCityOptions.filter(opt => opt.validFor.includes(key));
    }

    handleCityChange(event) {
        this.selectedCity = event.detail.value;
    }

    get disableSaveButton(){
        return  this.freightPrice == 0 ;
    }
    get disableCalculateButton(){
        return this.selectedCity == null || this.vehicleOne == null;
    }
    get disablevehiclPicklist(){
        return this.selectedCity == null;
    }
    get showCityAndStatePicklist(){
        return this.shippingCityStateError || this.priceListNotFound;
    }
    handleClose() {
        const closeEvent = new CustomEvent('close');
        this.dispatchEvent(closeEvent);
    }
   
    
}