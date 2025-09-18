using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class WeekdayInputModel: InputModelBase
    {
        public WeekdayInputModel(): base(InputTypeGuidConstants.LicenceTypeInputCommandTypeGuid)
        {
        }

        public int WeekDayId { get; set; }
        public string WeekDayName { get; set; }
        public bool IsWeekEnd { get; set; }
        public bool IsHalfDay { get; set; }
        public int SortOrder { get; set; }
        public bool IsArchived { get; set; }

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
