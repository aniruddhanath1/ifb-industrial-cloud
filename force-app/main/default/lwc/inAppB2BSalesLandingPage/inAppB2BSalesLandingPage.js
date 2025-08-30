import { LightningElement,api } from 'lwc';
import HomePage from '@salesforce/resourceUrl/HomePage';
import Account from '@salesforce/resourceUrl/Account';
import Opportunity from '@salesforce/resourceUrl/Opportunity';
import Leadership from '@salesforce/resourceUrl/Leadership';
export default class InAppB2BSalesLandingPage extends LightningElement {


     //welcome text
     @api welcome_text = "Welcome to Consumer Goods Cloud - Sales!";
     @api description = "Your app to accelerate growth and drive productivity.";
   
    
     //accelerate text
     @api app_to_accelerate_desc = "You'll get access to a purpose-built solution that helps you to grow accounts and collaborate across teams at a reduced cost and faster speed to market on one unified platform. ";
     @api app_to_accelerate_post_desc = "Predict and plan the entire sales cycle. Empower teams with shared tools to manage expectations across your org.";

     @api getting_started_title = "Get Started with your Learning Journey!"

     //home page section variables
     @api home_page_title = "Homepage"
     @api home_page_text = "1. As a Sales Manager, on your Homepage check for Closed Business, Sales by Quarter, Tasks, Events, and Open Opportunities"
     @api home_page_img = HomePage

     //Account page section variables
     @api account_title = "Accounts"
     @api account_text = "1. When opening your accounts tab, you should be able to see key opportunities surfaced, specifically: AU Outfitters VIC Promo Launch."
     @api account_text_desc_a = "a. If you click into this record, you should see a complete 360 degree view of the account including key contacts, locations, sales, service, marketing, activity, and more."
     @api account_text_desc_b = "b. Drill down into the new retail store location to check out the more detail"
     @api account_img = Account

     //Opportunity page section variables
     @api opportunity_title = "Opportunities"
     @api opportunity_text = "1. If you click into the opportunity tab, you should see that there is a related opportunity with the Aussie Outfitters HQ. Click into it to learn more."
     @api opportunity_text_desc_a = "a. You should see a record for a new store opening. There you’ll find stages tailored to this type of promotion and guidance for success steps to help advance the opportunity."
     @api opportunity_img = Opportunity

     //Leadership page section variables
     @api leadership_title = "Leadership Dashboard"
     @api leadership_text = "1. When opening the leadership dashboard, aggregate metrics are immediately surfaced like New Item Feedback, Accepted Store Count, Sum of Expected volume, etc"
     @api leadership_text_desc_a = "a. This dashboard is powered by insights in real-time. In the forecast component, you can see strong pipeline coverage for this quarter, but next quarter is light. Take action and work with your team to cover that gap."
     @api leadership_img = Leadership
}