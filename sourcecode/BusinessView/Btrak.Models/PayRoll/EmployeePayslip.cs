using System;

namespace Btrak.Models.PayRoll
{
   public class EmployeePayslip
    {
        public Guid? EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeNumber { get; set; }
        public DateTime DateOfJoining { get; set; }
        public string Designation { get; set; }
        public string Department { get; set; }
        public string Location { get; set; }
        public string PfNumber { get; set; }
        public string Uan { get; set; }
        public string EsiNumber { get; set; }
        public string PanNumber { get; set; }
        public string BankName { get; set; }
        public string BankAccountNumber { get; set; }
        public int? DaysInMonth { get; set; }
        public decimal? EffectiveWorkingDays { get; set; }
        public decimal? Lop { get; set; }
        public Guid? ComponentId { get; set; }
        public string ComponentName { get; set; }
        public string Actual { get; set; }
        public string Full { get; set; }
        public bool? IsDeduction { get; set; }
        public string ActualNetPayment { get; set; }
        public decimal ActualComponentAmount { get; set; }
        public string NetPayment { get; set; }
        public string TotalDeductionsToDate { get; set; }
        public string ActualDeductionsToDate { get; set; }
        public string ActualEarningsToDate { get; set; }
        public string TotalEarningsToDate { get; set; }
        public string CompanyName { get; set; }
        public string HeadOfficeAddress { get; set; }
        public string CompanySiteAddress { get; set; }
        public string PayrollMonth { get; set; }
        public string CurrencyName { get; set; }
        public string CurrencyCode { get; set; }
        public string CompanyBranches { get; set; }
        public string CompanyLogo { get; set; }
        public string PayslipLogo { get; set; }
        public string ActualNetPayAmountInWords { get; set; }
        public string ActualNetPayAmount { get; set; }
        public string Comments { get; set; }
        public Guid? PayRollRunEmployeeComponentId { get; set; }
        public Guid? PayRollRunId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsComponentUpdated { get; set; }
        public decimal OriginalActualComponentAmount { get; set; }
        public string NetPayAmount { get; set; }
        public string ModifiedOriginalActualComponentAmount { get; set; }
        public decimal? ComponentAmount { get; set; }
        public decimal? OldYTDComponentAmount { get; set; }
        public string OldYTDComponentAmountFormat { get; set; }
        public string YTDComments { get; set; }
        public bool IsYTDComponentUpdated { get; set; }
        public bool IncludeYtd { get; set; }
    }
}
