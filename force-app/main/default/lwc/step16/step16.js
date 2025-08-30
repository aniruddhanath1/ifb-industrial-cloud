import { LightningElement, api } from 'lwc';
import NewVisit from '@salesforce/resourceUrl/NewVisit';
import CompleteVisit from '@salesforce/resourceUrl/CompleteVisit';

export default class Step16 extends LightningElement {
    newvisit_img = NewVisit;
    completevisit_img = CompleteVisit;
}