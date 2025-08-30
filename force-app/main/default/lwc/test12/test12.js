import { LightningElement, api } from 'lwc';
import NTOStoreOrder from '@salesforce/resourceUrl/NTOStoreOrder';
import PDFPreview from '@salesforce/resourceUrl/PDFPreview';

export default class Test12 extends LightningElement {
    ntostoreorder_img = NTOStoreOrder;
    pdfpreview_img = PDFPreview;
}