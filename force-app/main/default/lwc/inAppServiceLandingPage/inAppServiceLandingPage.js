import { LightningElement, api } from 'lwc';
import HomePageForService from '@salesforce/resourceUrl/HomePageForService';
import ServiceConsole from '@salesforce/resourceUrl/ServiceConsole';
import CaseReceived from '@salesforce/resourceUrl/CaseReceived';
import CaseDetail from '@salesforce/resourceUrl/CaseDetail';
import TeleSales from '@salesforce/resourceUrl/TeleSales';
import SuperVisor from '@salesforce/resourceUrl/SuperVisor';
import Omnichannel from '@salesforce/resourceUrl/Omnichannel';

export default class InAppServiceLandingPage extends LightningElement {


    //welcome text
    @api welcome_text = "Welcome to Consumer Goods Cloud - Service!";
    @api description = "The best tool to increase customer satisfaction and revenue.";


    //accelerate text
    @api app_to_accelerate_desc = "You'll get access to a purpose-built solution that helps you to deliver high quality service to improve the resolution experience. Integrated service excellence components allow you to deliver this at scale while also increasing account sales and driving operational efficiency.";
    @api app_to_accelerate_post_desc = "In addition to these, you will get industry specific capabilities like telesales, penny perfect pricing and automation tools. Check out the guide below to get started.";

    @api getting_started_title = "Get Started with your Learning Journey!";

    //home page section variables
    @api home_page_title = "Homepage Dashboard";
    @api home_page_text = "Upon logging in you will be presented with a consolidated cockpit of information, helping to optimize service performance.";
    @api home_page_performance_text = "  You will see performance dashboard, tasks and events according to the cases in your patch.";
    @api home_page_case_text = "  Once you begin to log cases your dashboard will begin to populate a consolidated view of your business.";
    @api home_page_service_img = HomePageForService;

    //Service console page section variables
    @api service_console_title = "Service Console";
    @api service_console_text = "Once you have received a case, you can click into the NTO Store #201 account. Here you will find a custom-built service console designed specifically to help you improve the resolution experience with real-time data powered by data cloud.";
    @api customer_text = "  A customer profile card quickly surfaces all the important contact information for this customer.";
    @api timeline_text = "  Beneath it, you can see a real-time record of account details in a timeline view. This includes orders, visits, calls, and cases logged with this account."
    @api pricing_engine_text = "  In the center, all orders will be recorded. When ready to place new orders, you can click the “new” button to fill your cart and calculate the exact price with our penny perfect pricing engine."
    @api alert_text = "  Other real-time alerts populate in the alert component above to prepare you for inbound calls from retail customers.";
    @api quick_text = "  When you're ready to take action, a few quick clicks in the action launcher located at the top of the console make resolution even quicker.";
    @api activity_text = "  Any action taken is then logged in the activity component on the right where the whole organization can access it.";
    @api service_console_img = ServiceConsole;

    //Case Received page section variables
    @api case_received_title = "Case Received"
    @api case_received_text = "In this environment, we've preloaded a request to replace a damaged shipment to their store: Case 00001102. When receiving requests like this, you can log a case to create a new replacement order according to the customer needs, ";
    @api case_received_end_text = "right within the Service Console.";
    @api case_received_img = CaseReceived;

    //Case Details page section variables
    @api case_details_title = "Case Details"
    @api case_details_text = "You will see the case logged in the activities component on the right. Clicking into the case will then bring you to a case summary with all the relevant data you need to resolve quickly.";
    @api case_details_img = CaseDetail;

    //Telesales page section variables
    @api telesales_title = "Telesales and Order Management"
    @api telesales_text = "So you've decided to take action. Now, you can offer the opportunity to add products to a customer's order even while they're on the phone. Click the Advanced Orders tab of the OMS object in the center of your console.";
    @api telesales_end_text = "There you can start a new order using the “New” button in the top right of the object. While placing the order, the same penny perfect pricing engine utilized offline in the field is also leveraged for online ordering.";
    @api telesales_img = TeleSales;

    //Supervisor page section variables
    @api supervisor_title = "Supervisor Reports"
    @api supervisor_text = "Now you have a real-time view of Support Center performance - from case volume to FCR. With these insights, you can ensure you have the appropriate tools and human resources in place to ensure the highest levels of performance and customer satisfaction.";
    @api supervisor_end_text = "Click the “Reports” object from the drop down on the home tab. Here you can click into “12 - Service - Executive Reports” where you will find various reports to determine the effectiveness of your team across agents and accounts.";
    @api supervisor_img = SuperVisor

    //Omnichannel page section variables
    @api omnichannel_title = "Omni-Channel Supervisor"
    @api omnichannel_text = "Supervisors also have new tools to improve their productivity and efficiency. For example, they can review Response Time by Channel with access to an omni-channel view of agent capacity across all support channels. ";
    @api omnichannel_end_text = "From here you can identify any coverage gaps, take action, and assigning more service resources to ensure any gaps are covered.";
    @api omnichannel_img = Omnichannel
}