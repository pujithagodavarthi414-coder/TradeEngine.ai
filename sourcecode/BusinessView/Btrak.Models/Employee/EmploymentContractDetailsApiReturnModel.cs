using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmploymentContractDetailsApiReturnModel
    {
        public Guid? EmployeeId { get; set; }
        public Guid? EmploymentContractId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string ContractDetails { get; set; }
        public Guid? ContractTypeId { get; set; }
        public string ContractTypeName { get; set; }
        public int? ContractedHours { get; set; }
        public int? HourlyRate { get; set; }
        public string HolidayOrThisYear { get; set; }
        public string HolidayOrFullEntitlement { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public string CurrencyName { get; set; }
        public Guid? CurrencyId { get; set; }
        public string Symbol { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmploymentContractId = " + EmploymentContractId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", ContractDetails = " + ContractDetails);
            stringBuilder.Append(", ContractTypeId = " + ContractTypeId);
            stringBuilder.Append(", ContractTypeName = " + ContractTypeName);
            stringBuilder.Append(", ContractedHours = " + ContractedHours);
            stringBuilder.Append(", HourlyRate = " + HourlyRate);
            stringBuilder.Append(", HolidayOrThisYear = " + HolidayOrThisYear);
            stringBuilder.Append(", HolidayOrFullEntitlement = " + HolidayOrFullEntitlement);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", Symbol = " + Symbol);
            return stringBuilder.ToString();
        }
    }
}
