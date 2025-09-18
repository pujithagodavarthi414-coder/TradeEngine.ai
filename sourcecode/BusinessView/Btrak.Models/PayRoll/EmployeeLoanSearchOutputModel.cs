using System;

namespace Btrak.Models.PayRoll
{
    public class EmployeeLoanSearchOutputModel
    {
        public Guid? EmployeeLoanId { get; set; }
        public Guid? EmployeeId { get; set; }
        public decimal? LoanAmount { get; set; }
        public DateTime? LoanTakenOn { get; set; }
        public Guid? LoanTypeId { get; set; }
        public Guid? CompoundedPeriodId { get; set; }
        public DateTime? LoanPaymentStartDate { get; set; }
        public decimal? LoanBalanceAmount { get; set; }
        public decimal? LoanTotalPaidAmount { get; set; }
        public DateTime? LoanClearedDate { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsArchived { get; set; }
        public string LoanTypeName { get; set; }
        public string PeriodTypeName { get; set; }
        public string EmployeeName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public decimal? LoanInterestPercentagePerMonth { get; set; }
        public decimal? TimePeriodInMonths { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ModifiedLoanAmount { get; set; }
        public string ModifiedLoanBalanceAmount { get; set; }
        public string ModifiedTotalPaidAmount { get; set; }
        public string ProfileImage { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsPaid { get; set; }
    }
}
