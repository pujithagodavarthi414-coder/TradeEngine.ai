using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeeLoanUpsertInputModel : InputModelBase
    {
        public EmployeeLoanUpsertInputModel() : base(InputTypeGuidConstants.EmployeeLoanInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeLoanId { get; set; }
        public Guid? EmployeeId { get; set; }
        public decimal? LoanAmount { get; set; }
        public DateTime? LoanTakenOn { get; set; }
        public decimal? LoanInterestPercentagePerMonth { get; set; }
        public decimal? TimePeriodInMonths { get; set; }
        public Guid? LoanTypeId { get; set; }
        public Guid? CompoundedPeriodId { get; set; }
        public DateTime? LoanPaymentStartDate { get; set; }
        public decimal? LoanBalanceAmount { get; set; }
        public decimal? LoanTotalPaidAmount { get; set; }
        public DateTime? LoanClearedDate { get; set; }
        public bool IsApproved { get; set; }
        public bool IsArchived { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeLoanId = " + EmployeeLoanId);
            stringBuilder.Append(",EmployeeId = " + EmployeeId);
            stringBuilder.Append(",LoanAmount = " + LoanAmount);
            stringBuilder.Append(",LoanTakenOn = " + LoanTakenOn);
            stringBuilder.Append(",LoanInterestPercentagePerMonth = " + LoanInterestPercentagePerMonth);
            stringBuilder.Append(",TimePeriodInMonths = " + TimePeriodInMonths);
            stringBuilder.Append(",LoanTypeId = " + LoanTypeId);
            stringBuilder.Append(",CompoundedPeriodId = " + CompoundedPeriodId);
            stringBuilder.Append(",LoanPaymentStartDate = " + LoanPaymentStartDate);
            stringBuilder.Append(",LoanBalanceAmount = " + LoanBalanceAmount);
            stringBuilder.Append(",LoanTotalPaidAmount = " + LoanTotalPaidAmount);
            stringBuilder.Append(",LoanClearedDate = " + LoanClearedDate);
            stringBuilder.Append(",IsApproved = " + IsApproved);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",Name = " + Name);
            stringBuilder.Append(",Description = " + Description);
            return stringBuilder.ToString();
        }
    }
}
