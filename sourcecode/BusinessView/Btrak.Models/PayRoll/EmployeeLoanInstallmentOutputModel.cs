using System;

namespace Btrak.Models.PayRoll
{
    public class EmployeeLoanInstallmentOutputModel
    {
        public Guid Id { get; set; }
        public Guid EmployeeLoanId { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal PrincipalAmount { get; set; }
        public decimal InstallmentAmount { get; set; }
        public decimal RemainingAmount { get; set; }
        public DateTime? InstallmentDate { get; set; }
        public bool? IsTobePaid { get; set;}
        public byte[] TimeStamp { get; set; }
        public string LoanName { get; set; }
        public string EmployeeName { get; set; }
        public DateTime? LoanTakenOn { get; set; }
        public DateTime? LoanPaymentStartDate { get; set; }
        public decimal? LoanInterestPercentagePerMonth { get; set; }
        public decimal? TimePeriodInMonths { get; set; }
        public string LoanDescription { get; set; }
        public decimal LoanAmount { get; set; }
        public string EmployeeAddress { get; set; }
        public string ModifiedPrincipalAmount { get; set; }
        public string ModifiedInstallmentAmount { get; set; }
        public string ModifiedLoanAmount { get; set; }

    }
}
