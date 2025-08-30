import { LightningElement, api } from 'lwc';
import CreateVisit from '@salesforce/resourceUrl/CreateVisit';

export default class Step2 extends LightningElement {
    @api welcome_text = "Welcome to Consumer Goods - Enhanced";
    @api description = "Welcome to the Salesforce Consumer Goods Cloud Learning Org";
    createvisit_img = CreateVisit;
}