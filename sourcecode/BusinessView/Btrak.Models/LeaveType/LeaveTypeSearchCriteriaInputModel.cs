using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.LeaveType
{
    public class LeaveTypeSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public LeaveTypeSearchCriteriaInputModel() : base(InputTypeGuidConstants.LeaveTypeSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? LeaveTypeId { get; set; }
        public string LeaveTypeName { get; set; }
        public bool? IsApplyLeave { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsToIncludeHolidays { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", LeaveTypeId = " + LeaveTypeId);
            stringBuilder.Append(", LeaveTypeName = " + LeaveTypeName);
            return stringBuilder.ToString();
        }
    }
}
