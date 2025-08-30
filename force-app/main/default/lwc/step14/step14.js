import { LightningElement, api } from 'lwc';
import NTOStoreUpdatedorder from '@salesforce/resourceUrl/NTOStoreUpdatedOrder';
import NTOStoreScanBarcode from '@salesforce/resourceUrl/NTOStoreScanBarcode';

export default class Step14 extends LightningElement {
    ntostoreupdatedorder_img = NTOStoreUpdatedorder;
    ntostorescanbarcode_img = NTOStoreScanBarcode;
}