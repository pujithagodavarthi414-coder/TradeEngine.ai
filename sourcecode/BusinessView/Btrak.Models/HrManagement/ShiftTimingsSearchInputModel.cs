using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class ShiftTimingsSearchInputModel : SearchCriteriaInputModelBase
    {
        public ShiftTimingsSearchInputModel() : base(InputTypeGuidConstants.GetShiftTimingsInputCommandTypeGuid)
        {
        }

        public Guid? ShiftTimingId { get; set; }
        public Guid? EmployeeId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}