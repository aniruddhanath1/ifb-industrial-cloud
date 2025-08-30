public class OrderInstallmentWrapper {
    public List<OrderInstallment> Order_Installments { get; set; }
    public Decimal PendingAmountPercentage { get; set; }
    public Decimal PendingAmount { get; set; }
    public Decimal AdvanceAmountPercentage { get; set; }
    public Decimal AdvanceReceivedAmount { get; set; }
    public Decimal OrderTotalAmount { get; set; }
    
    public String sId { get; set; }
    
    // Inner classes for the nested objects
    public class OrderInstallment {
        public Decimal Amount { get; set; }
        public String TransactionId { get; set; }
        public String TransactionProofLink { get; set; }
        public String sType { get; set; }
        public String Order_InstallmentID { get; set; }
        public String OrderId { get; set; }
    }
    /*
    public class TransactionProof {
        public String fileData { get; set; }
        public String fileType { get; set; }
        public String fileName { get; set; }
    }*/
    
}