using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class WeekdaySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public WeekdaySearchCriteriaInputModel() : base(InputTypeGuidConstants.WeekdaySearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? WeekDayId { get; set; }
        public string WeekDayName { get; set; }
        public bool? IsWeekEnd { get; set; }
        public bool? IsHalfDay { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WeekDayId = " + WeekDayId);
            stringBuilder.Append(", WeekDayName = " + WeekDayName);
            stringBuilder.Append(", IsWeekEnd = " + IsWeekEnd);
            stringBuilder.Append(", IsHalfDay = " + IsHalfDay);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
