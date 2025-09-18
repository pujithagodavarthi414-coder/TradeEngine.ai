using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.LeaveType
{
    public class LeaveTypeInputModel : InputModelBase
    {
        public LeaveTypeInputModel() : base(InputTypeGuidConstants.LeaveInputCommandTypeGuid)
        {
        }
        public Guid? LeaveTypeId { get; set; }
        public string LeaveTypeName { get; set; }
        public string LeaveTypeShortName { get; set; }
        public Guid? MasterLeaveTypeId { get; set; }
        public bool? IsArchived { get; set; } 
        public bool? IsToIncludeHolidays { get; set; }
        public string LeaveTypeColor { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", LeaveTypeId = " + LeaveTypeId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", LeaveTypeName = " + LeaveTypeName);
            stringBuilder.Append(", LeaveTypeShortName = " + LeaveTypeShortName);
            stringBuilder.Append(", MasterLeaveTypeId = " + MasterLeaveTypeId);
            stringBuilder.Append(", IsToIncludeHolidays = " + IsToIncludeHolidays);
            stringBuilder.Append(", LeaveTypeColor = " + LeaveTypeColor);
            return stringBuilder.ToString();
        }
    }
}
