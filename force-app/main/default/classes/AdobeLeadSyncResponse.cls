public class AdobeLeadSyncResponse {
    public String status;
    public List<LeadResponse> data;

    public class LeadResponse {
        public String leadId;
        public String status;
        public List<String> errors;
    }

    public static AdobeLeadSyncResponse parseResponse(String jsonResponse) {
        return (AdobeLeadSyncResponse) JSON.deserialize(jsonResponse, AdobeLeadSyncResponse.class);
    }
}