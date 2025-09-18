using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmployeeBankDetailApiReturnModel
    {
        public Guid? EmployeeBankId { get; set; }
        public Guid? EmployeeId { get; set; }
        public string FirstName { get; set; }
        public string Surname { get; set; }
        public string Email { get; set; }
        public string IFSCCode { get; set; }
        public string AccountNumber { get; set; }
        public string AccountName { get; set; }
        public string BuildingSocietyRollNumber { get; set; }
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public DateTime? EffectiveFrom { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public Guid? BankId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeBankId = " + EmployeeBankId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", Surname = " + Surname);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", SortCode = " + IFSCCode);
            stringBuilder.Append(", AccountNumber = " + AccountNumber);
            stringBuilder.Append(", AccountName = " + AccountName);
            stringBuilder.Append(", BuildingSocietyRollNumber = " + BuildingSocietyRollNumber);
            stringBuilder.Append(", BankName = " + BankName);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", EffectiveFrom = " + EffectiveFrom);
            stringBuilder.Append(", EffectiveTo = " + EffectiveTo);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", BankId = " + BankId);
            return stringBuilder.ToString();
        }
    }
}
