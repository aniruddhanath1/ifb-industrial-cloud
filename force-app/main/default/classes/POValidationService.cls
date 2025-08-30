public with sharing class POValidationService {
    @AuraEnabled(cacheable=true)
    public static ResponseWrapper validatePO(String orderId,Boolean submitForApproval) {
        System.debug('validatePO-->methoud called '+submitForApproval);
        ResponseWrapper resWrp = new ResponseWrapper();
        List<String> validationErrors = new List<String>();
        String currentUserProfileName = '';
        String currentUserRoleName = '';
        List<Profile> currentUserProfileInformation = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1];
        if (currentUserProfileInformation != null && !currentUserProfileInformation.isEmpty()){
            currentUserProfileName = currentUserProfileInformation[0].Name;
        }

 System.debug('currentUserProfileName-->methoud called '+currentUserProfileInformation);


        List<User> currentUserInformation = [SELECT Id, Name, UserRoleId, UserRole.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        if (currentUserInformation != null && !currentUserInformation.isEmpty()) {
            currentUserRoleName = currentUserInformation[0].UserRole.Name;
        }


 System.debug('currentUserInformation-->methoud called '+currentUserRoleName);
    System.debug('orderId-->methoud called '+orderId);
        if (String.isBlank(orderId)) {
                System.debug('orderIdisBlank-->methoud called '+orderId);
            validationErrors.add(ConstantUtilities.ERROR_ORDER_ID_MISSING);
            resWrp.validationErrors = validationErrors;
            return resWrp;
        }
       
        Id orderIdAsId;
        try {
            orderIdAsId = Id.valueOf(orderId);
        } catch (Exception e) {
            validationErrors.add(ConstantUtilities.ERROR_INVALID_ORDER_ID);
            resWrp.validationErrors = validationErrors;
            return resWrp;
        }




        Order order;
        String quoteDeliveryPeriod;
        try {
            order = [
                SELECT Id, PO_Received__c, Advance_Received_Amount__c,
                       Advance_less_than_Payment_Term_committed__c,
                       Credit_Approval_Check_Required__c, GST_Certificate_Provided__c,
                       TCS_Declaration_Form_Provided__c, PAN_Card_Provided__c,
                       Contracted_Account__c, Payment_Terms__c, Warranty_Term_In_Year__c,
                       Freight_Terms__c, Installation_Level__c, Delivery_Period__C,
                       GST_No__c, PAN_No__c, CIN_No__c,CurrencyIsoCode,
                       (SELECT Id, Product2.Name, Quantity, UnitPrice FROM OrderItems),
                       SBQQ__Quote__r.Payment_Term__c, SBQQ__Quote__r.WarrantyTerm_In_Year__c,
                       SBQQ__Quote__r.Installation_Level__c, SBQQ__Quote__r.Actual_Delivery_Period__c,
                       SBQQ__Quote__r.Expected_Delivery_Period__c, SBQQ__Quote__r.Freight_Terms__c
                FROM Order
                WHERE Id = :orderIdAsId
                LIMIT 1
            ];
            system.debug('order'+order);
        } catch (Exception e) {
            validationErrors.add(ConstantUtilities.ERROR_ORDER_NOT_FOUND);
            resWrp.validationErrors = validationErrors;
            return resWrp;
        }




        if (order != null) {
            if (!order.PO_Received__c) {
                validationErrors.add(ConstantUtilities.ERROR_PO_NOT_RECEIVED);
            }




            if (!order.Credit_Approval_Check_Required__c) {
                validationErrors.add(ConstantUtilities.ERROR_CREDIT_APPROVAL_REQUIRED);
            }




            if (!order.GST_Certificate_Provided__c &&
                    (!currentUserProfileName.containsIgnoreCase('ASM - Area Sales Manager') || !currentUserProfileName.containsIgnoreCase('RSM - Regional Sales Manager')|| !currentUserProfileName.containsIgnoreCase('State Head - State Head')
                            || !currentUserRoleName.containsIgnoreCase('Regional Head')|| !currentUserRoleName.containsIgnoreCase('State Head') || !currentUserRoleName.containsIgnoreCase('Business Head') || !currentUserRoleName.containsIgnoreCase('CEO')|| !currentUserRoleName.containsIgnoreCase('ASM')
                    )) {




                validationErrors.add(ConstantUtilities.ERROR_GST_CERTIFICATE_NOT_PROVIDED);
            }




            if (!order.TCS_Declaration_Form_Provided__c &&
                    (!currentUserProfileName.containsIgnoreCase('ASM - Area Sales Manager') || !currentUserProfileName.containsIgnoreCase('RSM - Regional Sales Manager') || !currentUserProfileName.containsIgnoreCase('State Head - State Head')
                            || !currentUserRoleName.containsIgnoreCase('Regional Head') || !currentUserRoleName.containsIgnoreCase('State Head') || !currentUserRoleName.containsIgnoreCase('Business Head') || !currentUserRoleName.containsIgnoreCase('CEO') || !currentUserRoleName.containsIgnoreCase('ASM')
                    )) {
                validationErrors.add(ConstantUtilities.ERROR_TCS_DECLARATION_NOT_PROVIDED);
            }




            if (!order.PAN_Card_Provided__c && order.CurrencyIsoCode == 'INR' ) {
                validationErrors.add(ConstantUtilities.ERROR_PAN_CARD_NOT_PROVIDED);
            }




            if (order.Advance_Received_Amount__c == null) {
                validationErrors.add(ConstantUtilities.ERROR_ADVANCE_NOT_PROVIDED);
            }
           
            if (order.GST_No__c == null &&
                    (!currentUserProfileName.containsIgnoreCase('ASM - Area Sales Manager') || !currentUserProfileName.containsIgnoreCase('RSM - Regional Sales Manager') || !currentUserProfileName.containsIgnoreCase('State Head - State Head')
                            || !currentUserRoleName.containsIgnoreCase('Regional Head') || !currentUserRoleName.containsIgnoreCase('State Head') || !currentUserRoleName.containsIgnoreCase('Business Head') || !currentUserRoleName.containsIgnoreCase('CEO') || !currentUserRoleName.containsIgnoreCase('ASM')
                    )) {
                validationErrors.add(ConstantUtilities.ERROR_GST_NO_NOT_PROVIDED);
            }
           
            if (order.PAN_No__c == null  && order.CurrencyIsoCode == 'INR' ) {
                validationErrors.add(ConstantUtilities.ERROR_PAN_NO_NOT_PROVIDED);
            }
           
             if (order.CIN_No__c == null &&
                    (!currentUserProfileName.containsIgnoreCase('ASM - Area Sales Manager') || !currentUserProfileName.containsIgnoreCase('RSM - Regional Sales Manager')  || !currentUserProfileName.containsIgnoreCase('State Head - State Head') || !currentUserRoleName.containsIgnoreCase('Regional Head')
                            || !currentUserRoleName.containsIgnoreCase('State Head') || !currentUserRoleName.containsIgnoreCase('Business Head') || !currentUserRoleName.containsIgnoreCase('CEO')|| !currentUserRoleName.containsIgnoreCase('ASM')
                    )) {
                validationErrors.add(ConstantUtilities.ERROR_CIN_NO_NOT_PROVIDED);
            }




            if (order.SBQQ__Quote__r != null) {
                if (order.Payment_Terms__c != order.SBQQ__Quote__r.Payment_Term__c) {
                    validationErrors.add(ConstantUtilities.ERROR_PAYMENT_TERMS_MISMATCH);
                }




                if (order.Warranty_Term_In_Year__c != order.SBQQ__Quote__r.WarrantyTerm_In_Year__c) {
                    validationErrors.add(ConstantUtilities.ERROR_WARRANTY_TERMS_MISMATCH);
                }




                if (order.Freight_Terms__c != order.SBQQ__Quote__r.Freight_Terms__c) {
                    validationErrors.add(ConstantUtilities.ERROR_FREIGHT_TERMS_MISMATCH);
                }




                if (order.Installation_Level__c != order.SBQQ__Quote__r.Installation_Level__c) {
                    validationErrors.add(ConstantUtilities.ERROR_INSTALLATION_TERMS_MISMATCH);
                }




                quoteDeliveryPeriod = order.SBQQ__Quote__r.Expected_Delivery_Period__c != null
                                      ? order.SBQQ__Quote__r.Expected_Delivery_Period__c
                                      : order.SBQQ__Quote__r.Actual_Delivery_Period__c;


system.debug('quoteDeliveryPeriod'+quoteDeliveryPeriod);

                if (order.Delivery_Period__c != quoteDeliveryPeriod) {
                    validationErrors.add(ConstantUtilities.ERROR_DELIVERY_TERMS_MISMATCH);
                }
            } else {
                validationErrors.add(ConstantUtilities.ERROR_QUOTE_NOT_FOUND);
            }

            Boolean isApprovalRequired = (
                (order.Payment_Terms__c != order.SBQQ__Quote__r.Payment_Term__c ||
                 order.Advance_less_than_Payment_Term_committed__c ||
                 order.Warranty_Term_In_Year__c != order.SBQQ__Quote__r.WarrantyTerm_In_Year__c ||
                 order.Freight_Terms__c != order.SBQQ__Quote__r.Freight_Terms__c ||
                 order.Installation_Level__c != order.SBQQ__Quote__r.Installation_Level__c ||
                 order.Delivery_Period__c != quoteDeliveryPeriod)

            );

            Boolean panAndPoCondition =(order.PAN_Card_Provided__c &&order.PO_Received__c && Order.PAN_No__c !=null && order.CurrencyIsoCode == 'INR')||(order.PO_Received__c  && order.CurrencyIsoCode != 'INR' );
            if (isApprovalRequired && panAndPoCondition) {
              
                if(!Approval.isLocked(orderId)){
                    if (submitForApproval) {
                        if (!Approval.isLocked(orderId)) {
                            System.debug('is not locked-->'+Approval.isLocked(orderId));
                            System.debug('submitForApproval'+submitForApproval);
                            System.enqueueJob(new POApprovalProcessQueueable(order.Id));
                        }
                        System.debug('is not locked-->'+Approval.isLocked(orderId));
                        System.debug('submitForApproval'+submitForApproval);
                        resWrp.successMessage = ConstantUtilities.PO_SUCCESS_MESSAGE;
                    } else {
                        System.debug('insidesubmitForApproval'+submitForApproval);
                        resWrp.successMessage ='';
                    }
                }
                else{
                    
                    resWrp.successMessage = ConstantUtilities.PO_SUCCESS_MESSAGE;
                }
               
                       
            }
            else if (validationErrors.isEmpty() && !order.Advance_less_than_Payment_Term_committed__c &&  order.Payment_Terms__c == order.SBQQ__Quote__r.Payment_Term__c && order.Warranty_Term_In_Year__c == order.SBQQ__Quote__r.WarrantyTerm_In_Year__c &&  order.Freight_Terms__c == order.SBQQ__Quote__r.Freight_Terms__c &&
                       order.Installation_Level__c == order.SBQQ__Quote__r.Installation_Level__c &&   order.Delivery_Period__c == quoteDeliveryPeriod) {
               
                updateOrder(order.Id);
                resWrp.successMessage = ConstantUtilities.PO_APPROVED_MESSAGE;
            }
            else if(!isApprovalRequired && panAndPoCondition && !validationErrors.isEmpty()){
                 if(!Approval.isLocked(orderId)){
                    if (submitForApproval) {
                         updateOrder(order.Id);
                resWrp.successMessage = ConstantUtilities.PO_APPROVED_MESSAGE;
                    } else {
                        
                        resWrp.successMessage ='';
                    }
                }
                else{
                  
                    resWrp.successMessage = ConstantUtilities.PO_SUCCESS_MESSAGE;
                }
            }
        }

        resWrp.validationErrors = validationErrors;
        return resWrp;
    }




    @future
    public static void updateOrder(Id orderId) {
        Order orderrec = new Order();
        orderrec.Id = orderId;
        orderrec.Status = ConstantUtilities.STATUS_PO_APPROVED;
        update orderrec;
    }

    public class ResponseWrapper {
        @AuraEnabled
        public List<String> validationErrors;
        @AuraEnabled
        public String successMessage;
    }
}