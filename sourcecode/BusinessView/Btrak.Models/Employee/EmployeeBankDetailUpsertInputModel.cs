using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Employee
{
    public class EmployeeBankDetailUpsertInputModel : InputModelBase
    {
        public EmployeeBankDetailUpsertInputModel() : base(InputTypeGuidConstants.EmployeeBankDetailUpsertInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }
        public string IFSCCode { get; set; }
        public string AccountNumber { get; set; }
        public string AccountName { get; set; }
        public string BuildingSocietyRollNumber { get; set; }
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public DateTime? EffectiveFrom { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public bool IsArchived { get; set; }
        public Guid? EmployeeBankId { get; set; }
        public Guid? BankId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", SortCode = " + IFSCCode);
            stringBuilder.Append(", AccountNumber = " + AccountNumber);
            stringBuilder.Append(", AccountName = " + AccountName);
            stringBuilder.Append(", BuildingSocietyRollNumber = " + BuildingSocietyRollNumber);
            stringBuilder.Append(", BankName = " + BankName);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", EffectiveFrom = " + EffectiveFrom);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", EmployeeBankId = " + EmployeeBankId);
            stringBuilder.Append(", BankId = " + BankId);
            return stringBuilder.ToString();
        }
    }
}