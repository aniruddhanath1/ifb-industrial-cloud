import { LightningElement, api } from 'lwc';
import StoreCockpitCompleteVisit3 from '@salesforce/resourceUrl/StoreCockpitCompleteVisit3';
import NTOStoreFlashyDrinks from '@salesforce/resourceUrl/NTOStoreFlashyDrinks';
import SummerEventPromotion from '@salesforce/resourceUrl/SummerEventPromotion';

export default class Step10 extends LightningElement {
    storecockpitcompletevisit3_img = StoreCockpitCompleteVisit3;
    ntostoreflashydrinks_img = NTOStoreFlashyDrinks;
    summereventpromotion_img = SummerEventPromotion;
}