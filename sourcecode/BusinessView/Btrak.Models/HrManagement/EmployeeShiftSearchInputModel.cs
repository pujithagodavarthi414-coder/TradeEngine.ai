using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class EmployeeShiftSearchInputModel : SearchCriteriaInputModelBase
    {
        public EmployeeShiftSearchInputModel() : base(InputTypeGuidConstants.EmployeeShiftSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeeId { get; set; }
        public Guid? ShiftTimingId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeId = " + EmployeeId);
            stringBuilder.Append("ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
