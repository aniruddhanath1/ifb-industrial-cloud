@isTest
public class AMCTemplateControllerTest {

    @isTest
    public static void testAMCTemplateController(){
            Document document;

            document = new Document();
        
            document.Body = Blob.valueOf('Some Text');
        
            document.ContentType = 'application/pdf';
        
            document.DeveloperName = 'my_document';
        
            document.IsPublic = true;
        
            document.Name = 'QuoteCompanyLogo';
        
            document.FolderId = [select id from folder where name = 'My Test Docs'].id;
        
            insert document;
        AMCTemplateController ans= new AMCTemplateController();
    }
}