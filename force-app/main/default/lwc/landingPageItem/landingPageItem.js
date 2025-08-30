import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class LandingPageItem extends NavigationMixin(LightningElement) {
    @api ref_id;
    @api url;
    @api heading;
    @api icon_name;
    @api cloud_detail;
    @api app;

    navigateTo(event) {
        // event.preventDefault();
        // event.stopPropagation();

        let compDefinition = {
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/n/' + this.app
            }
        }

        this[NavigationMixin.Navigate](compDefinition);
    }
}