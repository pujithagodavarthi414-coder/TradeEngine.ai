using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeSalaryDetailsInputModel : InputModelBase
    {
        public EmployeeSalaryDetailsInputModel() : base(InputTypeGuidConstants.EmployeeSalaryDetailsInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeSalaryDetailId { get; set; }
        public Guid? EmployeeId { get; set; }
        public Guid? PayrollTemplateId { get; set; }
        public Guid? PayGradeId { get; set; }
        public string SalaryComponent { get; set; }
        public Guid? PayFrequencyId { get; set; }
        public Guid? CurrencyId { get; set; }
        public decimal? Amount { get; set; }
        public decimal? NetPayAmount { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public Guid? PaymentMethodId { get; set; }
        public Guid? SalaryParticularsFileId { get; set; }
        public string Comments { get; set; }
        public bool? IsDirectDeposit { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? OperationsPerformedBy { get; set; }
        public Guid? TaxCalculationTypeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeeSalaryDetailId = " + EmployeeSalaryDetailId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", PayrollTemplateId = " + PayrollTemplateId);
            stringBuilder.Append(", PayGradeId = " + PayGradeId);
            stringBuilder.Append(", SalaryComponent = " + SalaryComponent);
            stringBuilder.Append(", PayFrequencyId = " + PayFrequencyId);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", NetPayAmount = " + NetPayAmount);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", PaymentMethodId = " + PaymentMethodId);
            stringBuilder.Append(", SalaryParticularsFileId = " + SalaryParticularsFileId);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", IsDirectDeposit = " + IsDirectDeposit);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            stringBuilder.Append(", TaxCalculationTypeId = " + TaxCalculationTypeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
