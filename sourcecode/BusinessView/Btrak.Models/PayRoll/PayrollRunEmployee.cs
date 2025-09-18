using System;

namespace Btrak.Models.PayRoll
{
   public class PayrollRunEmployee : PayrollRun
    {
        public Guid? EmployeeId { get; set; }
        public Guid? PayrollRunId { get; set; }
        public decimal? PaidAmount { get; set; }
        public string EmployeeName { get; set; }
        public string Address1 { get; set; }
        public string BankAccountDetailsJson { get; set; }
        public decimal? TotalAmountPaid { get; set; }
        public decimal? LoanAmountRemaining { get; set; }
        public decimal? TotalDaysInPayroll { get; set; }
        public decimal? TotalWorkingDays { get; set; }
        public decimal? PlannedHolidays { get; set; }
        public decimal? SickDays { get; set; }
        public decimal? UnPlannedHolidays { get; set; }
        public decimal? TotalEarningToDate { get; set; }
        public decimal? TotalDeductionsToDate { get; set; }
        public decimal? EffectiveWorkingDays { get; set; }
        public decimal? LossOfPay { get; set; }
        public bool IsHold { get; set; }
        public decimal? PreviousMonthPaidAmount { get; set; }
        public bool? IsPaidAmountDifferent { get; set; }
        public decimal? ActualPaidAmount { get; set; }
        public String PayrollTemplateName { get; set; }
        public Guid? PayrollTemplateId { get; set; }
        public string ModifiedActualPaidAmount { get; set; }
        public string ModifiedPreviousMonthPaidAmount { get; set; }
        public string ModifiedLoanAmountRemaining { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public Guid? UserId { get; set; }
    }
}
