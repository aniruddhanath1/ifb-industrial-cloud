import { LightningElement, api } from 'lwc';
import Yourday from '@salesforce/resourceUrl/Yourday';
import Yourday2 from '@salesforce/resourceUrl/Yourday2';
import Yourday3 from '@salesforce/resourceUrl/Yourday3';
import Yourday4 from '@salesforce/resourceUrl/Yourday4';

export default class Step1 extends LightningElement {
    @api welcome_text = "Welcome to Consumer Goods - Enhanced";
    @api description = "Welcome to the Salesforce Consumer Goods Cloud Learning Org";
    @api step1_welcome_text = "Step 1";
    yourday_img = Yourday;
    yourday2_img = Yourday2;
    yourday3_img = Yourday3;
    yourday4_img = Yourday4;
}