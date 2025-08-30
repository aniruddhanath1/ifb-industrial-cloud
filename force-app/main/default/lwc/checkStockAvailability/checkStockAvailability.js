import { LightningElement,wire ,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOptionWrapper from '@salesforce/apex/CheckStockAvailabilityController.getOptionWrapper';
import getStockAvailability from '@salesforce/apex/CheckStockAvailabilityController.getStockAvailability';

export default class CheckStockAvailability extends LightningElement {
    @track displayData =[];
    columns = [
        { label: 'Plant Name', fieldName: 'plantName', type: 'text' },
        { label: 'Plant Code', fieldName: 'plantCode', type: 'text' },
        { label: 'Part Name', fieldName: 'partName', type: 'text' },
        { label: 'Material Code', fieldName: 'materialCode', type: 'text' },
        { label: 'Material Group', fieldName: 'materialGroup', type: 'text' },
        { label: 'Material Group', fieldName: 'materialSubGroup', type: 'text' },
        { label: 'Quantity', fieldName: 'quantity', type: 'text' },
        { label: 'InTransit', fieldName: 'inTransit', type: 'text' },
        { label: 'Booked Stock', fieldName: 'bookedStock', type: 'text' },
        { label: 'Free Stock', fieldName: 'freeStock', type: 'text'}
    ];
    @track plantValue = 'ALL';
    @track materialValue = 'ALL';
    @track materialGroup = 'ALL';
    @track materialSubGroup = 'ALL';
    @track plantOptions = [];
    @track materialOptions = [];
    @track materialSubGroupOptions = [];
    @track plantCode = 'ALL';
    @track materialCode = 'ALL';
    @track showSpinner = false;
    @track idwSubGroupOptions =[];
    @track ilmSubGroupOptions =[];
    @track FieldNoshow = true;

    get materialGroupOptions() {
        return [
            { label: 'All', value: 'ALL' },
            { label: 'Industrial Laundry Machine', value: 'ILM' },
            { label: 'Industrial Dishwasher', value: 'IDW' },
            { label: 'Industrial Laundry Machine Essentails', value: 'ILM ESS' },
            { label: 'Industrial Laundry Machine Accessory', value: 'ILM ACC' },
            { label: 'Industrial Dishwasher Essentails', value: 'IDW ESS' },
            { label: 'Industrial Dishwasher Accessory', value: 'IDW ACC' }

            
        ];
    }
    materialSubGroupOptionAll() {
        return [
            { label: 'All', value: 'ALL' }
        ];
    }
    handlematerialGroupChange(event) {
        this.materialGroup = event.detail.value;
        if(event.detail.value == 'ILM'){
            this.materialSubGroup = 'ALL';
            this.materialSubGroupOptions = this.ilmSubGroupOptions;
        }
        else if(event.detail.value == 'IDW'){
            this.materialSubGroup = 'ALL';
            this.materialSubGroupOptions = this.idwSubGroupOptions;
        }else{
            this.materialSubGroup = 'ALL';
            this.materialSubGroupOptions = this.materialSubGroupOptionAll();
        }
    }

    handlePlantChange(event) {
        console.log('**event.detail.value',event.detail.value);
        if (!event.detail.value || event.detail.value === 'none') {
            return; 
        }else{
            this.plantCode = event.detail.value;
            this.plantValue = event.detail.value;
          
        }
        /*
         if (!event.detail.value || event.detail.value === 'none') {
            console.log('No valid plant selected.');
            return; 
        }
    
        const selectedPlant = this.plantOptions.find(plant => plant.value === event.detail.value);
        if (selectedPlant) {
            this.plantCode = event.detail.value;
            this.plantValue = selectedPlant.label;
        }
        */
    }
    handleMaterialChange(event){
        console.log('**event.detail.value',event.detail.value);
        if (!event.detail.value || event.detail.value === 'none') {
            return; 
        }else{
            this.materialCode = event.detail.value;
            if(this.materialCode =='ALL'){
                this.FieldNoshow=true;
                this.materialGroup = 'ALL';
                this.materialSubGroup = 'ALL';
            }
            else {
                this.FieldNoshow=false;
            }
            this.materialValue = event.detail.value;
          
        }
        /*
        if (!event.detail.value || event.detail.value === 'none') {
            console.log('No valid materialCode selected.');
            return; 
        }
        
        
        const selectedMaterial = this.materialOptions.find(material => material.value === event.detail.value);
        if (selectedMaterial) {
            this.materialCode = event.detail.value;
            this.materialValue = selectedMaterial.label;
        }
        */
    }
    handlematerialSubGroupChange(event){
        this.materialSubGroup = event.detail.value;
    }

    handleSearch(){
        this.showSpinner = true;
        this.fetchStockAvailability();
        
    }

   @wire(getOptionWrapper)
    wiredOptions({ error, data }) {
        if (data) {
            console.log("wiredOptions",data);
            this.materialOptions = data.productOptions.map(product => ({
                label: product.label,
                value: product.id
            }));
            this.plantOptions = data.plantOptions.map(plant => ({
                label: plant.label,
                value: plant.id
            }));
            this.idwSubGroupOptions = data.idwSubGroupOptions.map(idwgroup => ({
                label: idwgroup.label,
                value: idwgroup.id
            }));
            this.ilmSubGroupOptions = data.ilmSubGroupOptions.map(ilmgroup => ({
                label: ilmgroup.label,
                value: ilmgroup.id
            }));
            this.materialSubGroupOptions = this.materialSubGroupOptionAll();
        } else if (error) {
            console.error('Error fetching options Wrapper:', error);
            this.showToast('Error', 'Error fetching options.', 'error');
        }
    }

    fetchStockAvailability() {
        console.log(this.plantCode,this.materialCode,this.materialGroup,this.materialSubGroup);
        getStockAvailability({
            plant: this.plantCode,
            material: this.materialCode,
            materialGroup: this.materialGroup,
            materialSubGroup: this.materialSubGroup
        })
        .then(result => {
            if(!JSON.parse(result)?.length ?? 0){
                this.displayData = [];
                this.showSpinner = false;
                this.showToast('Info', 'No records found with this search criteria.', 'info');
            }else{
                this.displayData = JSON.parse(result).map((item, index) => ({ ...item, id: index }));
                this.showSpinner = false;
            }
            console.log("result", JSON.stringify(this.displayData));
            
        })
        .catch(error => {
            console.error('Error fetching stock availability:', error);
            this.showToast('Error', 'Error fetching stock availability.', 'error');
            this.showSpinner = false;
        });
    }
    get dataSize(){
        return this.displayData?.length ?? 0;
    }

     showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }

}