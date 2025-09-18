using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class HolidaySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public HolidaySearchCriteriaInputModel() : base(InputTypeGuidConstants.HolidaySearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? HolidayId { get; set; }
        public Guid? DateKey { get; set; }
        public DateTime? Date { get; set; }
        public string Reason { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsWeekOff { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HolidayId = " + HolidayId);
            stringBuilder.Append(", DateKey = " + DateKey);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", Reason = " + Reason);
            stringBuilder.Append(", CountryId = " + CountryId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", IsWeekOff = " + IsWeekOff);
            return stringBuilder.ToString();
        }
    }
}
