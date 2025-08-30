import { LightningElement, api } from 'lwc';
import OfflineApproaches from '@salesforce/resourceUrl/OfflineApproaches';

export default class Approaches extends LightningElement {
    @api welcome_text = "Differences between Original Approach (User Cockpit) and New Approach (Advanced User Cockpit)";
    offlineapproaches_img = OfflineApproaches;
}