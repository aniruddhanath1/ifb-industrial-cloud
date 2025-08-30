({
  invoke : function(component, event, helper) {
        var quoteId = component.get("v.recordId"); // Assuming you pass quoteId to the component
        //var url = '/apex/sbqq__sb?id=' + quoteId + '#/product/lookup?qId=' + quoteId;
		var url = '/apex/sbqq__sb?id=' + quoteId + '#/quote/le?qId=' + quoteId;

        // Redirect to the URL
        window.location.href = url;
    }
})