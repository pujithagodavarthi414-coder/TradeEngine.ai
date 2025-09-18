using System;

namespace Btrak.Models.PayRoll
{
    public class EmployeeCreditorDetailsSearchOutputModel
    {
        public Guid? EmployeeCreditorDetailsId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? EmployeeId { get; set; }
        public string BranchName { get; set; }
        public string BankName { get; set; }
        public string AccountNumber { get; set; }
        public string AccountName { get; set; }
        public string IfScCode { get; set; }
        public string PanNumber { get; set; }
        public bool? IsArchived { get; set; }
        public bool? UseForPerformaInvoice { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public Guid? BankId { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }
    }
}
