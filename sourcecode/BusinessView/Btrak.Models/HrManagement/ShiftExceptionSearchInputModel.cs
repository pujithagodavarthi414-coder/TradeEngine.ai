using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class ShiftExceptionSearchInputModel : SearchCriteriaInputModelBase
    {
        public ShiftExceptionSearchInputModel() : base(InputTypeGuidConstants.ShiftExceptionInputCommandTypeGuid)
        {
        }

        public Guid? ShiftExceptionsId { get; set; }
        public Guid? ShiftTimingId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ShiftExceptionsId = " + ShiftExceptionsId);
            stringBuilder.Append("ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", SearchText  = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
