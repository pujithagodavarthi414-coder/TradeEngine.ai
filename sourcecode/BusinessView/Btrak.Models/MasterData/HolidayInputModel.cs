
using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class HolidayInputModel : InputModelBase
    {
        public HolidayInputModel() : base(InputTypeGuidConstants.LicenceTypeInputCommandTypeGuid)
        {
        }

        public Guid? HolidayId { get; set; } 
        public int? DateKey { get; set; }
        public DateTime? Date { get; set; }
        public string Reason { get; set; }
        public Guid? CountryId { get; set; }
        public bool IsArchived { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool? IsWeekOff { get; set; }
        public Guid? BranchId { get; set;}
        public string WeekOffDays { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HolidayId = " + HolidayId);
            stringBuilder.Append(", DateKey = " + DateKey);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", Reason = " + Reason);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsWeekOff = " + IsWeekOff);
            stringBuilder.Append(", WeekOffDays = " + WeekOffDays);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", BranchId = " + BranchId);
            return stringBuilder.ToString();
        }
    }
}