public class Account360Controller {
    @AuraEnabled(cacheable=true)
    public static CustomerWrapper getAccountData(string accountId){
        CustomerWrapper customerWrapper = new CustomerWrapper();
        try{
            Integration_Handler__mdt intHandlerInst = Integration_Handler__mdt.getInstance(ConstantUtilities.LabelAccount360Request);
            if(accountId != null &&  intHandlerInst!= null){
                Account acc = [Select Id, Customer_Id__c from Account where id =:accountId limit 1];
                String tokenStr = IntegrationHandler.generateToken(intHandlerInst);
                HttpResponse response = IntegrationHandler.makeHttpCallout(intHandlerInst.URL__c+'?CustomerId='+acc.Customer_Id__c, intHandlerInst.Http_Method__c, tokenStr, null );
                customerWrapper = (CustomerWrapper)JSON.deserialize(response.getBody(), CustomerWrapper.class);
            }else{
                throw new AuraHandledException('Account Id or Integration Handler record not found'); 
            }
            
        }catch(Exception e){
            ExceptionHandler.logException('Account360Controller' , 'getAccountData', e);
            throw new AuraHandledException(e.getMessage()); 
        }
        return customerWrapper;
    }
    @AuraEnabled
    public static boolean checkComp(string accountId,List<Map<String, String>> compList){
        Integer compCount = 0;
        system.debug(compList);
        Boolean retStatement;
        if(compList.size()>=3){
            
            for(Map<String,String> comp:compList){
                if(comp.get('callType')=='Service Call' && (comp.get('status')=='Open' || comp.get('status')=='Assigned' || comp.get('status')=='Pending' || comp.get('status')=='Negative Response')){
                    compCount+=1;
                }
            }
        }
        List<Account> accList = [Select Id,Is_Red_Flag__c From Account Where Id=:accountId LIMIT 1];
        system.debug(accList);
        List<Account> updateAccList = new List<Account>();
        for(Account acc:accList){
            if(compCount>=3){
                acc.Is_Red_Flag__c = 'Yes';
                updateAccList.add(acc);
                retStatement= true;
            }
            else{
                acc.Is_Red_Flag__c='No';
                updateAccList.add(acc);
                retStatement= false;
            }
        }
        if(!updateAccList.isEmpty()){
            system.debug(updateAccList);
            Database.update(updateAccList,false);
        }  
        return retStatement;
        
    }
}