public class AMCTemplateController {
    public String imageUrl { get; set; }
   

    public AMCTemplateController() {
        // Replace '015F30000013yyB' with the ID of your document or file in Salesforce.
        Document img =  [SELECT Name,Id FROM Document WHERE Name LIKE 'QuoteCompanyLogo%' limit 1];
        String documentId = '015F30000013yyB'; // Example ID
        String orgId = UserInfo.getOrganizationId();
		String orgURL = System.URL.getOrgDomainUrl().toExternalForm();
        imageUrl=orgURL.replace('my.salesforce.com', 'file.force.com/servlet/servlet.ImageServer?') + 'id=' + img.Id + '&oid=' + orgId;
    }
}