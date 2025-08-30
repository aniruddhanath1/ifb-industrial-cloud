import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/DocumentUploaderController.uploadFile';

export default class PODocumentUploader extends LightningElement {
    @api recordId;
    acceptedFormats = ['.pdf', '.png', '.jpg', '.jpeg', '.doc', '.docx', '.xls', '.xlsx'];

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        
        if (uploadedFiles.length > 0) {
            // Create an array of promises for each file upload
            const uploadPromises = uploadedFiles.map(file => {
                const fileName = `PO_${new Date().toISOString().slice(0, 10)}_${file.name}`;
                const contentDocumentId = file.documentId;

                // Call the Apex method to update the file name and attach it to the record
                return uploadFile({ 
                    recordId: this.recordId, 
                    fileName: fileName, 
                    contentDocumentId: contentDocumentId 
                })
            });

            // Wait for all upload promises to complete
            Promise.all(uploadPromises)
                .then(() => {
                    this.showToast('Success', `${uploadedFiles.length} files uploaded successfully.`, 'success');
                })
                .catch(error => {
                    console.error('Error during file upload:', error);
                    this.showToast('Error', `Error uploading files: ${error.body ? error.body.message : 'Unknown error'}`, 'error');
                });
        } else {
            this.showToast('Error', 'No files uploaded.', 'error');
        }
    }

    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(evt);
    }
}