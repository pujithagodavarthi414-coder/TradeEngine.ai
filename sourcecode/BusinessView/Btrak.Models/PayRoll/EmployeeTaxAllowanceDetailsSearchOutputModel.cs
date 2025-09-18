using System;

namespace Btrak.Models.PayRoll
{
    public class EmployeeTaxAllowanceDetailsSearchOutputModel
    {
        public Guid? EmployeeTaxAllowanceId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? TaxAllowanceId { get; set; }
        public string TaxAllowanceName { get; set; }
        public decimal? InvestedAmount { get; set; }
        public DateTime? ApprovedDateTime { get; set; }
        public Guid? ApprovedByEmployeeId { get; set; }
        public bool? IsPercentage { get; set; }
        public bool IsAutoApproved { get; set; }
        public bool IsOnlyEmployee { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public int? Type { get; set; }
        public string ApprovedBy { get; set; }
        public DateTime? SubmittedDate { get; set; }
        public string Comments { get; set; }
        public bool? IsRelatedToHRA { get; set; }
        public string OwnerPanNumber { get; set; }
        public bool IsApproved { get; set; }
        public bool RelatedToMetroCity { get; set; }
        public string ModifiedInvestedAmount { get; set; }
    }
}
