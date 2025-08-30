import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class InAppLandingPageChild extends NavigationMixin(LightningElement) {

    @api heading = "";
    @api cloudDetail = "";
    @api url = "";
    @api linkInNewTab = false;
    @api linkReference = "";
    @api app = "";
    @api page = "";
    @api objectName = "";
    @api objectId = "";
    @api filterName = "";
    @api pageReference = [];

    handleClick(event) {

        if (this.linkReference == "standard__namedPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: "standard__namedPage",
                        attributes: {
                            pageName: this.page
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__navItemPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: "standard__navItemPage",
                        attributes: {
                            apiName: this.page
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__recordPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: 'standard__recordPage',
                        attributes: {
                            objectApiName: this.objectName,
                            actionName: 'view',
                            recordId: this.objectId
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__objectPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: 'standard__objectPage',
                        attributes: {
                            objectApiName: this.objectName,
                            actionName: 'list'
                        },
                        state: {
                            filterName: this.filterName
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__recordRelationshipPage") {
            this.pageReference = {
                type: "standard__app",
                attributes: {
                    appTarget: this.app,
                    pageRef: {
                        type: 'standard__recordRelationshipPage',
                        attributes: {
                            objectApiName: this.objectName,
                            actionName: 'view',
                            recordId: this.objectId,
                            relationshipApiName: this.relatedEntity
                        }
                    }
                }
            }
        } else if (this.linkReference == "standard__webPage") {
            this.pageReference = {
                type: 'standard__webPage',
                attributes: {
                    url: this.url
                }
            }
        }
        if (this.linkInNewTab) {
            this[NavigationMixin.GenerateUrl](this.pageReference)
            .then(generated_url => {
        const windowContextNameUUID = crypto.randomUUID();
        window.open('',windowContextNameUUID);
        window.open(generated_url, windowContextNameUUID);} );
        } else {
            this[NavigationMixin.Navigate](this.pageReference);
        }
        
    }
}