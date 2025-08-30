import { LightningElement,api } from 'lwc';

export default class InAppLandingPage extends LightningElement {

@api appWelcomeText = "Welcome to CG Cloud Learning Trial Org";
@api appDescription = "Here's a collection of resources to help you get started.";

get pass_true() {
    return true;
}

get pass_false() {
    return false;
}
}