import { LightningElement, api } from 'lwc';
import YourdayVisits from '@salesforce/resourceUrl/YourdayVisits';

export default class Step3 extends LightningElement {
    @api welcome_text = "Welcome to Consumer Goods - Enhanced";
    @api description = "Welcome to the Salesforce Consumer Goods Cloud Learning Org";
    yourdayvisit_img = YourdayVisits;
}