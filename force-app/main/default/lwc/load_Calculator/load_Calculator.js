import { LightningElement, track, wire, api } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import Vertical__c from '@salesforce/schema/Opportunity.Vertical__c';
import Industrial_Dishwasher_Product_Type__c from '@salesforce/schema/Opportunity.Industrial_Dishwasher_Product_Type__c';
import Linen__c from '@salesforce/schema/Opportunity.Linen__c';
import getCustomMetadata from '@salesforce/apex/LoadCalculatorController.getCustomMetadata';
import setOpportunityValues from '@salesforce/apex/LoadCalculatorController.setOpportunityValues';
import modal from "@salesforce/resourceUrl/QucikActionSize";
import { loadStyle } from "lightning/platformResourceLoader";
import getProductCategory from '@salesforce/apex/LoadCalculatorController.getProductCategory';
import loadCalculatedTrue from '@salesforce/apex/LoadCalculatorController.loadCalculatedTrue';
import UpdatingOpportunityForIDW from '@salesforce/apex/LoadCalculatorController.UpdatingOpportunityForIDW';


export default class Load_Calculator extends LightningElement {
    @api recordId;
    @track isMobileApp = false;
    @track productCategory = '';
    @track vertical = '';
    @track selectedLinen = [];
    @track linenData = [];
    @track draftValues = [];
    @track productCategoryOptions = [];
    @track verticalOptions = [];
    @track linenOptions = [];
    @track allLinenOptions = [];
    @track allLineneOptionData = [];
    @track metadata = [];
    @track totalWashingload = 0;
    @track totalDryingLoad = 0;
    @track totalFlatIronerLoad = 0;
    @track totalUnshapedGarmentsLoad = 0;
    @track totalDrycleaningLoad = 0;

    @track totalLoadOfPropertyWash;
    @track totalDryLoadOfProperty;
    @track totalIronLoadOfProperty;
    @track totalUnshapedGarmentsProperty;

    @track totalLoadPerDayWash;
    @track totalDryLoadPerDay;
    @track totalIronLoadPerDay;
    @track totalUnshapedGarmentsPerDay;

    @track totalLoadPerCycleForWashing =0;
    @track totalLoadPerCycleForDrying = 0;
    @track totalLoadPerCycleForIroning = 0;
    @track totalLoadPerCycleUnshapedGarments = 0;

    @track IdwProductOptions;
    @track selectedIDWPRoduct;
    @track showCheckbox = false;
    @track hideGlass = false;
    @track maxHeightGlasses;
    @track glassDiameter;
    @track glassInDay;
    @track HoursWashing;
    @track ContinuousLoad = '';
    @track plateDiameter;
    @track glassesPerHour;
    @track GlassPeakLoad;
    @track PlatePeakLoad;
    @track NumberOfGuestRooms = 0;
    @track totalGuestLaundaryLoadPerDay;
    @track totalLoadGuestCycle;
    @track totalGuestMachineCapacity;
    @track washingMachineCapacity = 0;
    @track DryingMachineCapacity = 0;
    @track IroningMachineCapacity = 0;
    @track washingOccupancy = 0;
    @track washingCycle = 0;
    @track UnshapedGarmentsMachineCapacity = 0;
    @track continousLoadOptions = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];
    @track glassLine35 = 0;
    @track glassLine40 = 0;
    @track glassLine50 = 0;
    @track glassLine60 = 0;
    @track glassbasket35 = 0;
    @track glassbasket40 = 0;
    @track glassbasket50 = 0;
    @track glassbasket60 = 0;
    @track glasshour35 = 0;
    @track glasshour40 = 0;
    @track glasshour50 = 0;
    @track glasshour60 = 0;
    @track choice35;
    @track choice40;
    @track choice50;
    @track choice60;
    @track pleatPerBasket = 0;
    @track CapacityPlates = 0;

    
    @track tableRequired = 0;
    @track MachineRequired = 0;

    @track singleBedSheet = 0;
    @track doubleBedSheet = 0;
    @track IroningSingleSeetPerDay = 0;
    @track IroningDoubleSeetPerDay = 0;
    @track ironHour = 0;
    @track singleSheetPerHour = 0;
    @track doubleSheetPerHour = 0;
    @track bedSize = 0;
    linenInputMap = new Map();
    linenIroningMap = new Map();
    MetadataTable = false;
    opportunityTable = true;
    loadTable = false;
    IDW = false;
    ILM = true;
    loading = true;
    Guest = false;
    Guests = true;
    RanckConveyor = false;
    IsChildVisible = false;
    bedsheetSelected = false;
    unshapedSelected = false;
   
    

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Vertical__c })
    VerticalValue({ error, data }) {
        if (data) {
            this.verticalOptions = data.values;
            console.log('this.v'+data.values);
            
        } else if (error) {
            console.error('Error fetching picklist values:', error);
        }
    }
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: Linen__c })
    lineValues({ error, data }) {
        if (data) {
            this.allLinenOptions = data.values;
            this.allLineneOptionData = data;
        } else if (error) {
            console.error('Error fetching picklist values:', error);
        }
    }

    @wire(getPicklistValues, {recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName : Industrial_Dishwasher_Product_Type__c})
    IDWProductOptions({error,data}){
        if (data) {
            this.IdwProductOptions = data.values;
            console.log(data.values);
        } else if (error) {
            console.error('Error in getting IDW Product multi select picklist', error);
        }
    }
    renderedCallback() {
        if (this.recordId && !this.isInitialized) {
            loadStyle(this, modal);
            this.isInitialized = true;
            this.fetchProductCategory();
        }
    }
    handleCloseChild(){
        this.IsChildVisible = false;
    }

    handleIWDProductChange(event){
        this.selectedIDWPRoduct = event.detail.value;
        if(this.selectedIDWPRoduct.includes('Plate')){
            this.showCheckbox = true;
            this.hideGlass = false;
        }
        else if(this.selectedIDWPRoduct.includes('Both')){
            this.showCheckbox = true;
            this.hideGlass = true;
        }
        else {
            this.showCheckbox = false;
            this.hideGlass = true;
        }
    }
    

    handleIDWProductValueChange(event){
        const field = event.target.dataset.id;
        const value = event.target.value;
        switch (field) {
            case 'maxHeightGlasses':
                this.maxHeightGlasses = value;
                break;
            case 'glassDiameter':
                this.glassDiameter = value;
                break;
            case 'glassInDay':
                this.glassInDay = value;
                break;
            case 'HoursWashing':
                this.HoursWashing = value;
                break;
            case 'ContinuousLoad':
                this.ContinuousLoad = value;
                break;
            case 'glassesPerHour':
                this.glassesPerHour = value;
                break;
            case 'GlassPeakLoad':
                this.GlassPeakLoad = value;
                break;
            case 'plateDiameter':
                this.plateDiameter =  value;
                break;
            case 'PlatePeakLoad':
                this.PlatePeakLoad =  value;
                break;
            default:
                break;
        }
    }

    handleVerticalChange(event) {
        
        this.vertical = event.detail.value;
        let key = this.allLineneOptionData.controllerValues[event.target.value];
        this.linenOptions = this.allLinenOptions.filter(opt => opt.validFor.includes(key));
        
    }

    handleLinenChange(event) {
        this.selectedLinen = event.detail.value;
    }

    handleClick() {
        this.fetchMetadata();
        this.MetadataTable = true;
        this.opportunityTable = false;
        loadStyle(this, modal);
    }
    handleBack(){
        this.MetadataTable = false;
        this.opportunityTable = true;
        this.loadTable = false;
        this.bedsheetSelected = false;
        this.unshapedSelected = false;
    }

    handleSaveIDW(){
        let isValid = true;
        let fields = this.template.querySelectorAll('lightning-input');
        fields.forEach(field => {
            if (!field.checkValidity()) {
                field.reportValidity();
                isValid = false;
            }
        });
        if(isValid){
            UpdatingOpportunityForIDW({
                recordIds: this.recordId,
                maxHeightGlasses: parseFloat(this.maxHeightGlasses),
                glassDiameter:parseFloat(this.glassDiameter),
                glassDay:parseFloat(this.glassInDay),
                glassPerHour : parseFloat(this.glassesPerHour),
                HoursWashing:parseFloat(this.HoursWashing),
                NohoursWashing:parseFloat(this.NohoursWashing),
                glassPeakLoad:parseFloat(this.GlassPeakLoad),
                maxHeightPlates: parseFloat(this.plateDiameter),
                platePeakLoad:parseFloat(this.PlatePeakLoad),
                continousLoad:this.ContinuousLoad,
                IWDProducts: this.selectedIDWPRoduct,
                glassLine35:parseFloat(this.glassLine35),
                glassLine40:parseFloat(this.glassLine40),
                glassLine50:parseFloat(this.glassLine50),
                glassLine60:parseFloat(this.glassLine60),
                glassBasket35:parseFloat(this.glassbasket35),
                glassBasket40:parseFloat(this.glassbasket40),
                glassBasket50:parseFloat(this.glassbasket50),
                glassBasket60:parseFloat(this.glassbasket60),
                glassHour35:parseFloat(this.glasshour35),
                glassHour40:parseFloat(this.glasshour40),
                glassHour50:parseFloat(this.glasshour50),
                glassHour60:parseFloat(this.glasshour60),
                choice35:this.choice35,
                choice40:this.choice40,
                choice50:this.choice50,
                choice60:this.choice60,
                NoOfPlates:this.NoOfPlates,
                platePerBasket : this.pleatPerBasket.toString(),
                capacity : parseFloat(this.CapacityPlates)
            })
            .then(() => {
                
                //this.dispatchEvent(new CustomEvent('close'));
                console.log('controller called successfully');
                this.IsChildVisible = true;
                this.IDW = false;
                
            })
            .catch(error => {
                console.log('aman sagar');
                console.log('fail'+error);
                
            });
        }
        else{
            alert('Please fill all the mandatory values');
        }
       
    }

    handleInputChange(event) {
        let weight = parseFloat(event.target.dataset.weight);
        let numberOflinens = parseFloat(event.target.value);
        let label = event.target.dataset.label;
        let vertical = event.target.dataset.vertical;
        console.log(vertical);
        

        let totalWeight = weight * numberOflinens;
        console.log(label + totalWeight);
        this.linenInputMap.set(label, totalWeight);
        this.metadata.forEach(element => {   
            if(element.Linen__c == label && element.Vertical__c == vertical && (element.Flat_Ironer__c || element.Ironing_Load_Unshaped_Garments_in_Nos__c)){
                this.linenIroningMap.set(label,numberOflinens);
            }
            
        });
        
        console.log('Updated Map:', JSON.stringify(Array.from(this.linenInputMap.entries())));
    }
    handleCalculate() {
        this.totalWashingload = 0;
        this.totalDryingLoad = 0;
        this.totalDrycleaningLoad = 0;
        
            this.loadTable = true;
            this.metadata.forEach(element => {    
                if (element.Washing__c && this.linenInputMap.has(element.Linen__c)) {
                    this.totalWashingload += this.linenInputMap.get(element.Linen__c);
                }
                if (element.Drying__c && this.linenInputMap.has(element.Linen__c)) {
                    this.totalDryingLoad += this.linenInputMap.get(element.Linen__c);
                }
                if(element.Dry_cleaning_Load__c && this.linenInputMap.has(element.Linen__c)){
                    this.totalDrycleaningLoad += this.linenInputMap.get(element.Linen__c);
                }
                if (element.Flat_Ironer__c && this.linenIroningMap.has(element.Linen__c)) {
                    this.totalFlatIronerLoad += this.linenIroningMap.get(element.Linen__c);
                    console.log(element.Linen__c);
                    if(element.Linen__c == 'Single Sheet' || element.Linen__c == 'Single Duvet Cover'){
                        this.bedsheetSelected = true;
                        this.singleBedSheet += this.linenIroningMap.get(element.Linen__c);
                    }
                    if(element.Linen__c == 'Double Sheet' || element.Linen__c == 'Double Duvet Cover'){
                        this.bedsheetSelected = true;
                        this.doubleBedSheet += this.linenIroningMap.get(element.Linen__c);
                    }
                }
                if(element.Ironing_Load_Unshaped_Garments_in_Nos__c && this.linenIroningMap.has(element.Linen__c)){
                    this.unshapedSelected = true;
                    this.totalUnshapedGarmentsLoad += this.linenIroningMap.get(element.Linen__c);;
                }
                
            });
            
            
        loadStyle(this, modal);   
    }
    HandleBedSheet(event){
        if(event.detail.value == 0 || event.detail.value == null){
            this.ironHour = 0;
        }
        else{
            this.ironHour = event.detail.value;
        }
        this.singleSheetPerHour = Math.ceil(this.IroningSingleSeetPerDay/event.detail.value);
        this.doubleSheetPerHour = Math.ceil(this.IroningDoubleSeetPerDay/event.detail.value);
    }
    
    handleOccupancyChangeWashing(event){
        this.washingOccupancy = event.detail.value;
        this.totalLoadPerDayWash = ((this.totalWashingload * event.detail.value)/100).toFixed(2);  
        this.IroningSingleSeetPerDay = ((this.singleBedSheet*this.washingOccupancy)/100).toFixed(2);
        this.IroningDoubleSeetPerDay = ((this.doubleBedSheet*this.washingOccupancy)/100).toFixed(2);     
    }
    handleOccupancyChangeDrying(event){
        this.totalDryLoadPerDay = ((this.totalDryingLoad * event.detail.value)/100).toFixed(2);
    }
    handleOccupancyChangeIroning(event){
        this.totalIronLoadPerDay = ((this.totalFlatIronerLoad * event.detail.value)/100).toFixed(2);
    }
    handleOccupancyChangeUnshapedGarments(event){
        this.totalUnshapedGarmentsPerDay = ((this.totalUnshapedGarmentsLoad * event.detail.value)/100).toFixed(2);
        
    }
    handleBedSize(event){
        if(event.detail.value == 0 || event.detail.value ==null){
            this.bedSize = 0;
        }
        else{
            this.bedSize = event.detail.value;
        }
        
    }
    

    handleNumOfCyclesChange(event){
        this.washingCycle = event.detail.value;
        if(event.detail.value==0 || event.detail.value == null){
            this.totalLoadPerCycleForWashing = 0;
        }
        else{
            this.totalLoadPerCycleForWashing = ((this.totalLoadPerDayWash/event.detail.value)).toFixed(2);
            this.washingMachineCapacity = (this.totalLoadPerCycleForWashing*1.2).toFixed(2);
        }    
    }
    handleGuestChange(event){
        this.NumberOfGuestRooms = 0;
        this.NumberOfGuestRooms = event.detail.value;
        
        this.totalGuestLaundaryLoadPerDay = (this.NumberOfGuestRooms * this.washingOccupancy)/100;
    
        this.totalLoadGuestCycle = Math.ceil(this.totalGuestLaundaryLoadPerDay/this.washingCycle);
        
        this.totalGuestMachineCapacity = this.totalLoadGuestCycle+Math.ceil((this.totalLoadGuestCycle*20)/100);
        
    }
    handleNumOfCycleChangeDrying(event){
        if(event.detail.value==0 || event.detail.value == null){
            this.totalLoadPerCycleForDrying = 0;
        }
        else{
            this.totalLoadPerCycleForDrying = ((this.totalDryLoadPerDay/event.detail.value)).toFixed(2);
            this.DryingMachineCapacity = (this.totalLoadPerCycleForDrying*1.2).toFixed(2);
        }
        
    }
    handleNumOfCycleChangeIroning(event){
        if(event.detail.value==0 || event.detail.value == null){
            this.totalLoadPerCycleForIroning = 0;
        }
        else{
            this.totalLoadPerCycleForIroning = ((this.totalIronLoadPerDay/event.detail.value)).toFixed(2);
            this.IroningMachineCapacity = (this.totalLoadPerCycleForIroning*1.2).toFixed(2);
        }
        
    }
    handleNumOfCycleChangeUnshapedGermaents(event){
        if(event.detail.value==0 || event.detail.value == null){
           this.totalLoadPerCycleUnshapedGarments = 0;
        }
        else{
            this.totalLoadPerCycleUnshapedGarments = ((this.totalUnshapedGarmentsPerDay/event.detail.value)).toFixed(2);
            this.UnshapedGarmentsMachineCapacity = (this.totalLoadPerCycleUnshapedGarments*1.2).toFixed(2);
            this.tableRequired = Math.ceil(this.totalLoadPerCycleUnshapedGarments/20);
            this.MachineRequired = Math.ceil(this.totalLoadPerCycleUnshapedGarments/50);
        }
        
    }
    

    handleSave() {
        setOpportunityValues({
            Record: this.recordId,
            washing: this.totalLoadPerCycleForWashing,
            drying: this.totalLoadPerCycleForDrying,
            Ironing: this.totalLoadPerCycleForIroning,
            vertical: this.vertical,
            selectedLinen: this.selectedLinen.join(';'), // Assuming Linen__c is a multi-select picklist field
            totalguestWash: this.totalGuestLaundaryLoadPerDay,
            totalguestDry: this.totalLoadGuestCycle,
            totalguestIron: this.NumberOfGuestRooms,
            totalUnshapedGarments: this.totalLoadPerCycleUnshapedGarments,
            washingMachineCapacity : this.washingMachineCapacity,
            dryingMachineCapacity : this.DryingMachineCapacity,
            IroningMachineCapacity : this.IroningMachineCapacity,
            UnshapedGarmentsMachineCapacity : this.UnshapedGarmentsMachineCapacity,
            drycleaning : this.totalDrycleaningLoad,
            tableRequired:this.tableRequired,
            MachineRequired:this.MachineRequired,
            SingleBedSheet:this.singleBedSheet,
            doubleBedSheet : this.doubleBedSheet,
            IroningSheetDay : this.IroningSingleSeetPerDay,
            IroningDoubleSheetDay : this.IroningDoubleSeetPerDay,
            IronHour : this.ironHour,
            SheetPerHour : this.singleSheetPerHour,
            DoubleSheetPerHour : this.doubleSheetPerHour,
            GuestMachineCapacity : this.totalGuestMachineCapacity,
            size : this.bedSize

        })
            .then(result => {
                console.log(result);
                //this.dispatchEvent(new CustomEvent('close'));
                this.IsChildVisible = true;
                this.ILM = false;
                //this.dispatchEvent(new CustomEvent('close'));
            })
            .catch(error => {
                console.error('Error saving opportunity values:', error);
            });
    }
    
    handleCalculateIDW(){
        let isValid = true;
        let fields = this.template.querySelectorAll('lightning-input');
        fields.forEach(field => {
            if (!field.checkValidity()) {
                field.reportValidity();
                isValid = false;
            }
        });
        if(isValid){
            this.glassLine35 = (35/this.glassDiameter).toFixed(0);
            this.glassLine40 = (40/this.glassDiameter).toFixed(0);
            this.glassLine50 = (50/this.glassDiameter).toFixed(0);
            this.glassLine60 = (60/this.glassDiameter).toFixed(0);
            this.glassbasket35 = (this.glassLine35*this.glassLine35).toFixed(2);
            this.glassbasket40 = (this.glassLine40*this.glassLine40).toFixed(2);
            this.glassbasket50 = (this.glassLine50*this.glassLine50).toFixed(2);
            this.glassbasket60 = (this.glassLine60*this.glassLine60).toFixed(2);
            this.glasshour35 = (this.glassbasket35*30).toFixed(2);
            this.glasshour40 = (this.glassbasket40*30).toFixed(2);
            this.glasshour50 = (this.glassbasket50*50).toFixed(2);
            this.glasshour60 = (this.glassbasket60*60).toFixed(2);
            console.log(this.glasshour35 + ' '+this.GlassPeakLoad);
            
            if (parseFloat(this.glasshour40) >= parseFloat(this.GlassPeakLoad)) {
                this.choice40 = 'Ok';
            } else {
                this.choice40 = 'Not OK';
            }
            if (parseFloat(this.glasshour50) >= parseFloat(this.GlassPeakLoad)) {
                this.choice50 = 'Ok';
            } else {
                this.choice50 = 'Not OK';
            }
            if (parseFloat(this.glasshour35) >= parseFloat(this.GlassPeakLoad)) {
                this.choice35 = 'Ok';
            } else {
                this.choice35 = 'Not OK';
            }
            if (parseFloat(this.glasshour60) >= parseFloat(this.GlassPeakLoad)) {
                this.choice60 = 'Ok';
            } else {
                this.choice60 = 'Not OK';
            }
            if(this.plateDiameter<=25){
                this.pleatPerBasket = 18;
            }
            else{
                this.pleatPerBasket = 9;
            }
            this.CapacityPlates = this.pleatPerBasket*50;
        }
        else{
            alert('Please fill all the mandatory values');
        }
       
    }
    
    fetchMetadata() {
        getCustomMetadata({ vertical: this.vertical, linens: JSON.stringify(this.selectedLinen) })
            .then(result => {
                this.metadata = result;
            })
            .catch(error => {
                console.error('Error fetching metadata:', error);
            });
    }
    fetchProductCategory() {
        getProductCategory({ recordIds: this.recordId })
            .then(result => {
                this.productCategory = result;
                console.log(result);
                if (this.productCategory === 'IDW') {
                    this.loading = false;
                    this.IDW = true;
                    this.ILM = false;
                    this.opportunityTable = false;
                    loadStyle(this, modal);
                    this.fetchIDWData();
                    this.fetchRackConveyorData();
                    this.loadCalculate();
                }
                else{
                    this.loading = false;
                    this.ILM = true;
                    this.IDW = false;
                }
            })
            .catch(error => {
                console.error('Problem in fetching Product category:', error);
            });
    }
    loadCalculate() {
        loadCalculatedTrue({ recordIds: this.recordId })
            .then(result => {
                console.log(result);
            })
            .catch(error => {
                console.error('Error in updating opportunity:', error);
            });
    }
    
    connectedCallback() {
        this.isMobileApp = this.isSalesforceMobileApp();
    }

    isSalesforceMobileApp() {
        const userAgent = navigator.userAgent.toLowerCase();
        return userAgent.includes('salesforce') && userAgent.includes('mobile');
    }
    handleClose() {
        const closeEvent = new CustomEvent('close');
        this.dispatchEvent(closeEvent);
    }
}