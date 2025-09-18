using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveManagementInputModel : InputModelBase
    {
        public LeaveManagementInputModel() : base(InputTypeGuidConstants.LeaveInputCommandTypeGuid)
        {
        }
        public Guid? LeaveApplicationId { get; set; }
        public Guid? UserId { get; set; }
        public string LeaveReason { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public DateTime? LeaveDateFrom { get; set; }
        public DateTime? LeaveDateTo { get; set; }
        public bool? IsDeleted { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? FromLeaveSessionId { get; set; }
        public Guid? ToLeaveSessionId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", LeaveApplicationId = " + LeaveApplicationId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", LeaveReason = " + LeaveReason);
            stringBuilder.Append(", LeaveTypeId = " + LeaveTypeId);
            stringBuilder.Append(", LeaveDateFrom = " + LeaveDateFrom);
            stringBuilder.Append(", LeaveDateTo = " + LeaveDateTo);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", FromLeaveSessionId = " + FromLeaveSessionId);
            stringBuilder.Append(", ToLeaveSessionId = " + ToLeaveSessionId);
            return stringBuilder.ToString();
        }
    }
}
