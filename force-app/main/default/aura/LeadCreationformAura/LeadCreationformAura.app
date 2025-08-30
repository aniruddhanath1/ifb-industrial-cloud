<aura:application access="global" extends="ltng:outApp"  implements="ltng:allowGuestAccess" >
    <!--<c:leadCreationForm recordId="{!v.recordId}"></c:leadCreationForm>-->
	<aura:dependency resource="c:leadCustomerQuoteForm"/>
    <aura:dependency resource="c:serviceTeamLeadForm"/>
	<!--<aura:dependency resource="c:leadCreationPartnerAndServiceForm"/>-->
</aura:application>