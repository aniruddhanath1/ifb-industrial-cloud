import { LightningElement, track, wire,api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationFinishEvent } from 'lightning/flowSupport';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import punchIn from '@salesforce/apex/AttendanceController.punchIn';
import punchOut from '@salesforce/apex/AttendanceController.punchOut';
import checkPunchStatus from '@salesforce/apex/AttendanceController.checkPunchStatus';
import getPunchCategories from '@salesforce/apex/AttendanceController.getPunchCategories';
//import printLatLog from '@salesforce/apex/AttendanceController.printLatLog'

export default class AttendanceComponent extends NavigationMixin(LightningElement){
    //@api LoginFlow_FinishLocation='/lightning/n/Attendance_Screen';
    @track isPunchedInToday = false;
    @track isShowModal=false;
    @track isPunchOutDoneToday = false;
    @track punchInTime;
    @track showClose = false;
    @track spinner = true;
    @track punchCategories = [];
    @track selectedCategory = '';
    @track accessDenied = false;
    @track date;
    @track time;
  
    currentPageReference;
    urlStateParameters = {};
    expectedPageApiName = 'Attendance_Screen';
    currentPageApiName;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;
        this.urlStateParameters = currentPageReference?.state || {};

        const apiName = currentPageReference?.attributes?.apiName;
        this.currentPageReference?.attributes?.apiName;
        if (apiName !== this.expectedPageApiName) {
            this.handleAccessDenied();
        }
    }

    connectedCallback() {
        this.checkPunchStatus();
        this.loadPunchCategories();
    }

    checkPunchStatus() {
        checkPunchStatus()
            .then(result => {
            
                this.isPunchedInToday = result.isPunchedInToday;
                this.isPunchOutDoneToday = result.isPunchOutDoneToday;
                this.punchInTime=result.punchInDate;
                this.spinner = false;
                this.showClose = result.isPunchOutDoneToday && result.isPunchedInToday;
                const isoString = "2024-09-16T12:30:00Z";

                // Create a Date object
                let dateObj = new Date(result.punchInDate);

                // Extract the date and time
                this.date = dateObj.toLocaleDateString(); // Format: MM/DD/YYYY (based on locale)
                this.time = dateObj.toLocaleTimeString(); // Format: HH:MM:SS AM/PM (based on locale)

                //console.log("Date:", date);
                //console.log("Time:", time);

                            })
                            .catch(error => {
                                this.showToast('Error', error.body.message, 'error');
                                this.spinner = false;
                            });
                    }

                    loadPunchCategories() {
                        getPunchCategories()
                            .then(result => {
                                this.punchCategories = result.map(category => ({
                                    label: category.label,
                                    value: category.value
                                }));
                            })
                            .catch(error => {
                                this.showToast('Error', error.body.message, 'error');
                            });
                    }

    handleAccessDenied() {
        this.accessDenied = true;
        this.spinner = false;

        setTimeout(() => {
            this.closeFlow();
        }, 5000);
    }

    closeFlow() {
        const navigateNextEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateNextEvent);
    }

   
    redirectToAttendanceScreen() {
        const apiName = this.currentPageReference?.attributes?.apiName;
        if (apiName !== this.expectedPageApiName) {
            this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: this.expectedPageApiName
                }
            });
        }
    }
    redirectToHome(){
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            }
    })
}
    handleCategoryChange(event) {
        this.selectedCategory = event.detail.value;
    }

    handlePunchIn() {
        if (!this.selectedCategory) {
            this.showToast('Error', 'Please select a punch category before punching in.', 'error');
            return;
        }
        this.getGeolocation('punchIn');
    }

    handlePunchOut() {
        this.isShowModal=false;
        this.getGeolocation('punchOut');
    }
    
    handlePunchOutValidate(){
        let currentDate = Date.now();
        let punchInDate = new Date(this.punchInTime).getTime();
        let timeDiffMs = currentDate - punchInDate;
        let timeDiffMinutes = Math.floor(timeDiffMs / (1000 * 60));

        // Output the time difference in minutes
       
        if(timeDiffMinutes<480){
            this.isShowModal=true;
        }else{
            this.handlePunchOut();
        }
    }

    getGeolocation(action) {
        this.spinner = true;
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                position => {
                    const latitude = position.coords.latitude;
                    const longitude = position.coords.longitude;
                    if (latitude !== 0 && longitude !== 0) {
                        if (action === 'punchIn') {
                            this.punchIn(latitude, longitude);
                        } else if (action === 'punchOut') {
                            this.punchOut(latitude, longitude);
                        }
                    } else {
                        this.showToast('Error', 'Failed to get valid geolocation data. Please try again.', 'error');
                        this.spinner = false;
                    }
                },
                error => {
                    this.showError(error);
                    if (error.code === error.PERMISSION_DENIED) {
                        if(this.currentPageApiName!=this.expectedPageApiName){
                            this.handleAccessDenied();
                        }
                    }
                }
            );
        } else {
            this.showToast('Error', 'Geolocation is not supported by this browser.', 'error');
            this.spinner = false;
            if(this.currentPageApiName!=this.expectedPageApiName){
                this.handleAccessDenied();
            }
        }
    }

    punchIn(latitude, longitude) {
        punchIn({ 
            latitude: latitude, 
            longitude: longitude, 
            punchCategory: this.selectedCategory 
        })
        .then(() => {
            this.showToast('Success', 'Punch In successful.', 'success');
            this.isPunchedInToday = true;
            this.spinner = false;
            const now = new Date();
            const isoString = now.toISOString();
            this.punchInTime=isoString;
            //this.LoginFlow_FinishLocation='/lightning/page/home';
            this.closeFlow();
        })
        .catch(error => {
            this.showToast('Error', error, 'error');
            this.spinner = false;
        });
    }

    punchOut(latitude, longitude) {
        punchOut({ latitude: latitude, longitude: longitude })
        .then(() => {
            this.showToast('Success', 'Punch Out successful.', 'success');
            this.isPunchOutDoneToday = true;
            this.spinner = false;
            this.showClose = true;
            //this.LoginFlow_FinishLocation='/lightning/page/home';
            this.closeFlow();
        })
        .catch(error => {
            this.showToast('Error', error, 'error');
            this.spinner = false;
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    showError(error) {
        switch (error.code) {
            case error.PERMISSION_DENIED:
                this.showToast('Error', 'User denied the request for Geolocation.', 'error');
                this.handleAccessDenied();
                break;
            case error.POSITION_UNAVAILABLE:
                this.showToast('Error', 'Location information is unavailable.', 'error');
                break;
            case error.TIMEOUT:
                this.showToast('Error', 'The request to get user location timed out.', 'error');
                break;
            default:
                this.showToast('Error', 'An unknown error occurred.', 'error');
                break;
        }
    }

    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }
    printuplr(){
        console.log('page ref---> '+this.pageReference);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'home',
            },
        });
    }
}