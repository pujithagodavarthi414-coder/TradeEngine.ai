using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class ShiftWeekSearchInputModel : SearchCriteriaInputModelBase
    {
        public ShiftWeekSearchInputModel() : base(InputTypeGuidConstants.ShiftWeekInputCommandTypeGuid)
        {
        }

        public Guid? ShiftWeekId { get; set; }
        public Guid? ShiftTimingId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ShiftWeekId = " + ShiftWeekId);
            stringBuilder.Append("ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
