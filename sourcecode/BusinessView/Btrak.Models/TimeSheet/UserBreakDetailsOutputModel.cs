using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class UserBreakDetailsOutputModel : InputModelBase
    {
        public UserBreakDetailsOutputModel() : base(InputTypeGuidConstants.GetFeedTimeHistoryInputCommandTypeGuid)
        {

        }
 
        public DateTimeOffset? DateFrom { get; set; }
        public DateTimeOffset? DateTo { get; set; }
        public int TotalCount { get; set; }
        public Guid? BreakId { get; set; }

        public Guid? BreakInTimeZoneId { get; set; }
        public string BreakInAbbreviation { get; set; }
        public string BreakOutAbbreviation { get; set; }
        public string BreakInTimeZone { get; set; }
        public string BreakOutTimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", BreakId = " + BreakId);
            return stringBuilder.ToString();
        }
    }
}

