({
    doInit : function(component, event, helper) {
        var action = component.get("c.getOpportunityId");
        action.setParams({ orderId : component.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var opportunityId = response.getReturnValue();
                if(opportunityId) {
                    component.set("v.opportunityId", opportunityId);
                } else {
                    component.set("v.errorMessage", "We encountered an issue. Please contact your administrator for assistance.");
                }
            } else {
                component.set("v.errorMessage", "We encountered an issue. Please contact your administrator for assistance.");
            }
        });
        $A.enqueueAction(action);
    }
})