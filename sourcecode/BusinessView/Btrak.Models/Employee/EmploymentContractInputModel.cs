using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Employee
{
    public class EmploymentContractInputModel : InputModelBase
    {
        public EmploymentContractInputModel() : base(InputTypeGuidConstants.EmploymentContractInputCommandTypeGuid)
        {
        }

        public Guid? EmploymentContractId { get; set; }
        public Guid? EmployeeId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string ContractDetails { get; set; }
        public Guid? ContractTypeId { get; set; }
        public int? ContractedHours { get; set; }
        public int? HourlyRate { get; set; }
        public string HolidayOrThisYear { get; set; }
        public string HolidayOrFullEntitlement { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CurrencyId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmploymentContractId = " + EmploymentContractId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", StartDate = " + StartDate);
            stringBuilder.Append(", EndDate = " + EndDate);
            stringBuilder.Append(", ContractDetails = " + ContractDetails);
            stringBuilder.Append(", ContractTypeId = " + ContractTypeId);
            stringBuilder.Append(", ContractedHours = " + ContractedHours);
            stringBuilder.Append(", HourlyRate = " + HourlyRate);
            stringBuilder.Append(", HolidayOrThisYear = " + HolidayOrThisYear);
            stringBuilder.Append(", HolidayOrFullEntitlement = " + HolidayOrFullEntitlement);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            return stringBuilder.ToString();
        }
    }
}
