using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class WeekdayOutputModel
    {
        public Guid WeekId { get; set; }
        public int WeekDayId { get; set; }
        public string WeekDayName { get; set; }
        public bool IsWeekend { get; set; }
        public bool IsHalfDay { get; set; }
        public int SortOrder { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WeekDayId = " + WeekDayId);
            stringBuilder.Append(", WeekDayName = " + WeekDayName);
            stringBuilder.Append(", IsWeekend = " + IsWeekend);
            stringBuilder.Append(", IsHalfDay = " + IsHalfDay);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
