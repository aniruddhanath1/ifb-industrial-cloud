import { LightningElement, api } from 'lwc';
import NTOStore from '@salesforce/resourceUrl/NTOStore';

export default class Step5 extends LightningElement {
    @api welcome_text = "Welcome to Consumer Goods - Enhanced";
    @api description = "Welcome to the Salesforce Consumer Goods Cloud Learning Org";
    ntostore_img = NTOStore;
}