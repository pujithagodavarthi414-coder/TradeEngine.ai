using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeSalaryDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public Guid? PayGradeId { get; set; }
        public string PayGradeName { get; set; }
        public string SalaryComponent { get; set; }
        public Guid? PayFrequencyId { get; set; }
        public string PayFrequencyName { get; set; }
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public decimal? Amount { get; set; }
        public decimal? NetPayAmount { get; set; }
        public bool? IsAddedDepositDetails { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public Guid? PaymentMethodId { get; set; }
        public string PaymentMethodName { get; set; }
        public Guid? SalaryParticularsFileId { get; set; }
        public string Comments { get; set; }
        public string FileName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public bool? IsPermanent { get; set; }
        public Guid? EmployeeSalaryDetailId { get; set; }
        public Guid? PayrollTemplateId { get; set; }
        public string PayrollName { get; set; }
        public Guid? TaxCalculationTypeId { get; set; }
        public string TaxCalculationTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", PayGradeId = " + PayGradeId);
            stringBuilder.Append(", PayGradeName = " + PayGradeName);
            stringBuilder.Append(", SalaryComponent = " + SalaryComponent);
            stringBuilder.Append(", PayFrequencyId = " + PayFrequencyId);
            stringBuilder.Append(", PayFrequencyName = " + PayFrequencyName);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", IsAddedDepositDetails = " + IsAddedDepositDetails);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            stringBuilder.Append(", PaymentMethodId = " + PaymentMethodId);
            stringBuilder.Append(", PaymentMethodName = " + PaymentMethodName);
            stringBuilder.Append(", SalaryParticularsFileId = " + SalaryParticularsFileId);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", FileName = " + FileName);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", EmployeeSalaryDetailId = " + EmployeeSalaryDetailId);
            stringBuilder.Append(", PayrollTemplateId = " + PayrollTemplateId);
            stringBuilder.Append(", PayrollName = " + PayrollName);
            return stringBuilder.ToString();
        }
    }
}
