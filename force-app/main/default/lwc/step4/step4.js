import { LightningElement, api } from 'lwc';
import StoreCockpit from '@salesforce/resourceUrl/StoreCockpit';


export default class Step4 extends LightningElement {
    @api welcome_text = "Welcome to Consumer Goods - Enhanced";
    @api description = "Welcome to the Salesforce Consumer Goods Cloud Learning Org";
    storecockpit_img = StoreCockpit;
}