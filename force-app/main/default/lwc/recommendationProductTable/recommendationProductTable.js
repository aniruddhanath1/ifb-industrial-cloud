import addProductsToOpportunity from '@salesforce/apex/OpportunityProductRecomendationPlugin.addProductsToOpportunity';
import IdWrecommend from '@salesforce/apex/OpportunityProductRecomendationPlugin.IdWrecommend';
import ILMrecommend from '@salesforce/apex/OpportunityProductRecomendationPlugin.ILMrecommend';
import opportunityProductTotalLoad from '@salesforce/apex/OpportunityProductRecomendationPlugin.opportunityProductTotalLoad';
import modal from "@salesforce/resourceUrl/QucikActionSize";
import { NavigationMixin } from 'lightning/navigation';
import { loadStyle } from "lightning/platformResourceLoader";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, track, wire } from 'lwc';

const FIELDS = [
    'Opportunity.Name',
    'Opportunity.Product_category__c',
      'Opportunity.Vertical__c',
      'Opportunity.Total_Guest_laundry_load_for_drying__c',
     'Opportunity.Total_Guest_laundry_load_for_Washing__c',
      'Opportunity.Total_Guest_laundry_load_for_Ironing__c',
      'Opportunity.Total_Load_per_Cycle_for_Dry_Load__c',
      'Opportunity.Total_Load_per_Cycle_for__c',
      'Opportunity.Total_Load_per_cycle__c',
      
];


export default class RecommendationProductTable extends NavigationMixin(LightningElement) {

    @api recordId;
    @track normalProducts=[];
    @track guestProducts=[];
    @track columns=[];
    @track productCategory;
    @track selectedProductIds = new Set();
    @track hasProducts;
    @track isShowModal = false;
    @track noProducts;
    @track totaldrySelectedLoad =0;
    @track totalWashSelectedLoad=0 ;
    @track totalIronSelectedLoad=0 ;
    @track oppTotaldrySelectedLoad ;
    @track opptotalWashSelectedLoad ;
    @track oppTotalIronSelectedLoad ;
    @track OPPGuesttotaldrySelectedLoad ;
    @track OPPGuesttotalWashSelectedLoad ;
    @track OPPGuesttotalIronSelectedLoad ;
    @track oppProducttotalIronSelectedLoad ;
    @track oppProducttotalWashSelectedLoad ;
    @track oppProducttotalDrySelectedLoad ;
    @track isLoading = true;
    ironLoadWarningAlert;
    washLoadWarningAlert;
    dryLoadWarningAlert
    @track Vertical;
    @track productILM = true;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    opportunityHandler({ error, data }) {
        if (data) {
            this.productCategory = data.fields.Product_category__c.value;
            this.Vertical=data.fields.Vertical__c.value;
            this.OPPGuesttotalIronSelectedLoad=data.fields.Total_Guest_laundry_load_for_Ironing__c.value;
            this.OPPGuesttotalWashSelectedLoad=data.fields.Total_Guest_laundry_load_for_Washing__c.value;
            this.OPPGuesttotaldrySelectedLoad=data.fields.Total_Guest_laundry_load_for_drying__c.value;
            this.oppTotalIronSelectedLoad=data.fields.Total_Load_per_Cycle_for__c.value;
            this.opptotalWashSelectedLoad=data.fields.Total_Load_per_cycle__c.value;
            this.oppTotaldrySelectedLoad=data.fields.Total_Load_per_Cycle_for_Dry_Load__c.value;
            this.handleProductCategory();
        } else if (error) {
            console.error('Error fetching opportunity record:', error);
        }
    }
    renderedCallback() {
        console.log(this.productCategory);
            if(this.productCategory=='IDW'){
                this.productILM = false;
            }
            loadStyle(this, modal);
    }
    handleProductCategory() {
        
        if (this.productCategory === 'ILM') {
            this.fetchILMRecommendations();
        } else if (this.productCategory === 'IDW') {
            this.fetchIDWRecommendations();
        } else {
            console.log('No matching product category');
        }
    }

    fetchILMRecommendations() {
        
        ILMrecommend({ OppId: this.recordId })
            .then(result => {
                this.isLoading = false;
                console
                const normalProducts = result.Recommendations || [];
                
                const guestProducts = result.GuestRecommendations || [];
                if(result.length === 0) {
                    console.log('result.length === 0');
                    this.hasProducts = false;
                    
                    this.noProducts=true;
                }else{
                    this.noProducts=false;
                  
                    this.normalProducts = this.transformDataILM(normalProducts);
                    this.guestProducts = this.transformDataILM(guestProducts);
                    this.hasProducts = true;
            }
              
                
            })
            .catch(error => {
                console.error('Detailed error fetching ILM products:', JSON.stringify(error));
            });
    }

    fetchIDWRecommendations() {
        IdWrecommend({ OppId: this.recordId })
            .then(result => {
                this.isLoading = false;
                if(result.length === 0) {
                    this.hasProducts = false;
                    this.noProducts=true;
                }
                else {
                    this.hasProducts =true;
                    this.noProducts=false;
                    this.products =result;
                 
                    loadStyle(this, modal);
                }
             
            })
            .catch(error => {
                 console.error('Detailed error fetching ILM products:', JSON.stringify(error));
            });
    }

    transformDataILM(data) {
        
        // Directly map over the array
        return data.map(item => {
            return {
                Id: item.product.Id,
                Name: item.product.Name,
                Dry_load_capacity__c: item.product.Dry_load_capacity__c,
                Wash_Load_capacity__c: item.product.Wash_Load_capacity__c,
                Heating_type__c:item.product.Heating_type__c,
                quantity: item.quantity,
                 TotalCapacity: item.product.Dry_load_capacity__c > 0 
                ? item.quantity * item.product.Dry_load_capacity__c 
                : item.product.Wash_Load_capacity__c > 0 
                    ? item.quantity * item.product.Wash_Load_capacity__c 
                    : 0
            };
        });
    }

   

    handleRowSelection(event) {
        const productId = event.target.dataset.id;
        const quantity = parseFloat(event.target.dataset.quantity) || 1;

        // Get load values from the data attributes
        const dryLoad = parseFloat(event.target.dataset.dryLoad) || 0;
        const washLoad = parseFloat(event.target.dataset.washLoad) || 0;
        const ironLoad = parseFloat(event.target.dataset.ironLoad) || 0;
        console.log(dryLoad);
        console.log(washLoad);
        console.log(ironLoad);
        console.log(quantity);
     
        
        
        // Multiply load capacities by quantity
        const totalDryLoad = dryLoad * quantity;
        const totalWashLoad = washLoad * quantity;
        const totalIronLoad = ironLoad * quantity;
        console.log(totalDryLoad);
        console.log(totalWashLoad);
        console.log(totalIronLoad);
        console.log(quantity);
        
        
        if (event.target.checked) {
            this.totaldrySelectedLoad += totalDryLoad;
            this.totalWashSelectedLoad += totalWashLoad;
            this.totalIronSelectedLoad += totalIronLoad;
            this.selectedProductIds.add(({ Id:productId, quantity: quantity }));

        } else {
            this.totaldrySelectedLoad -= totalDryLoad;
            this.totalWashSelectedLoad -= totalWashLoad;
            this.totalIronSelectedLoad -= totalIronLoad;
            this.selectedProductIds.delete(({ Id:productId, quantity: quantity }));
        }
     
    
        
    }

    get selectedLoads() {
        return `Dry Load: ${this.totaldrySelectedLoad}, Wash Load: ${this.totalWashSelectedLoad}, Iron Load: ${this.totalIronSelectedLoad}`;
    }
    
    
    getTotalLoad(){
       console.log('getTotalLoad');
       
        opportunityProductTotalLoad({ oppId: this.recordId })
        .then(result => {
            
            
            this.oppProducttotalWashSelectedLoad = result.Wash_Load_capacity__c;
            this.oppProducttotalIronSelectedLoad = result.Iron_Load_capacity__c;
            this.oppProducttotalDrySelectedLoad = result.Dry_load_capacity__c;
            this.oppProducttotalWashSelectedLoad = result.Wash_Load_capacity__c;
          
            console.log('oppProducttotalWashSelectedLoad',this.oppProducttotalWashSelectedLoad);
            console.log('oppProducttotalIronSelectedLoad',this.oppProducttotalIronSelectedLoad);
            console.log('oppProducttotalDrySelectedLoad',this.oppProducttotalDrySelectedLoad);
         this.handleAlert();
         this.isLoading = false;
            
        })
        .catch(error => {
             console.error('Detailed error fetching ILM products:', JSON.stringify(error));
        });
    }
    handleAddProductCheck() {
        this.isLoading = true;
        console.log('handleAddProductCheck',);
        
        this.getTotalLoad();
       
    }
    handleAlert(){

       
        console.log('handleAddProductCheck--->');
        
      if(this.Vertical=='Guest laundry'){
        let hasWarning = false;
        console.log('Guest laundry-->');
        
        if(this.totaldrySelectedLoad+this.oppProducttotalDrySelectedLoad>this.OPPGuesttotaldrySelectedLoad){
                this.dryLoadWarningAlert='The selected products exceed the capacity based on the dry load.';
                hasWarning = true;
                
        }
        else if(this.totaldrySelectedLoad+this.oppProducttotalDrySelectedLoad<this.OPPGuesttotaldrySelectedLoad){
                this.dryLoadWarningAlert='The selected products are under capacity based on the dry load.';
                hasWarning = true;
        }
        if(this.totalWashSelectedLoad+this.oppProducttotalWashSelectedLoad>this.OPPGuesttotalWashSelectedLoad){
            this.washLoadWarningAlert='The selected products exceed the capacity based on the Wash load.';
            hasWarning = true;
        }
        else if(this.totalWashSelectedLoad+this.oppProducttotalWashSelectedLoad<this.OPPGuesttotalWashSelectedLoad){
            this.washLoadWarningAlert='The selected products are under capacity based on the Wash load.';
            hasWarning = true;
        }
        // if(this.totalIronSelectedLoad+this.oppProducttotalIronSelectedLoad<this.OPPGuesttotalIronSelectedLoad){
        //     this.ironLoadWarningAlert='The selected products exceed the capacity based on the Iron load.';
        //      hasWarning = true;
        // }
        // else if(this.totalIronSelectedLoad+this.oppProducttotalIronSelectedLoad>this.OPPGuesttotalIronSelectedLoad){
        //         this.ironLoadWarningAlert='The selected products are under capacity based on the Iron load.';
        //          hasWarning = true;
        // }
        if (hasWarning) {
            this.isShowModal = true;
        } else {
       
            this.HandleaddProduct();
        }
      }
      else {
        
       

        let hasWarning = false;

        // Dry Load Check
        if (this.totaldrySelectedLoad + this.oppProducttotalDrySelectedLoad > this.oppTotaldrySelectedLoad) {
            this.dryLoadWarningAlert = 'The selected products exceed the capacity based on the dry load.';
            hasWarning = true;
        } else if (this.totaldrySelectedLoad + this.oppProducttotalDrySelectedLoad < this.oppTotaldrySelectedLoad) {
            this.dryLoadWarningAlert = 'The selected products are under capacity based on the dry load.';
            hasWarning = true;
        }
        
        // Wash Load Check
        if (this.totalWashSelectedLoad + this.oppProducttotalWashSelectedLoad > this.opptotalWashSelectedLoad) {
            this.washLoadWarningAlert = 'The selected products exceed the capacity based on the Wash load.';
            hasWarning = true;
        } else if (this.totalWashSelectedLoad + this.oppProducttotalWashSelectedLoad < this.opptotalWashSelectedLoad) {
            this.washLoadWarningAlert = 'The selected products are under capacity based on the Wash load.';
            hasWarning = true;
        }
        
        // Iron Load Check
        // if (this.totalIronSelectedLoad + this.oppProducttotalIronSelectedLoad > this.OPPGuesttotalIronSelectedLoad) {
        //     this.ironLoadWarningAlert = 'The selected products exceed the capacity based on the Iron load.';
        //     hasWarning = true;
        // } else if (this.totalIronSelectedLoad + this.oppProducttotalIronSelectedLoad < this.OPPGuesttotalIronSelectedLoad) {
        //     this.ironLoadWarningAlert = 'The selected products are under capacity based on the Iron load.';
        //     hasWarning = true;
        // }
        
        // If any warnings were triggered, show the modal
        if (hasWarning) {
            this.isShowModal = true;
        } else {
            // No warnings, proceed with adding the product
            this.HandleaddProduct();
        }
       
      }
    }
    HandleaddProduct(){
        console.log('HandleaddProduct----->');
        
       
        this.isShowModal=false;
        
        if (this.selectedProductIds.size > 0) {
            console.log('HandleaddProduct');
            const productList = Array.from(this.selectedProductIds).map(product => ({
                Id: product.Id,
                quantity: product.quantity
            }));
            addProductsToOpportunity({ products: productList, opportunityId: this.recordId })
                .then(() => {

                    this.isLoading = false;
                    this.showToast('Success', 'Products added to opportunity successfully', 'success');
                    this.OppNavigate();
                })
                .catch(error => {
                    this.showToast('Error', error.body.message, 'error');
                });
        } else {
            this.showToast('Error', 'No products selected', 'error');
        }
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
    hideModalBox() {  
        this.isShowModal = false;
    }
    OppNavigate(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Opportunity',
                actionName: 'view'
            }
        });
    }
}