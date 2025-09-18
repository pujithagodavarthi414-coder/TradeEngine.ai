using System;
using System.Text;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveManagementSpOutputModel
    {
        public Guid LeaveApplicationId { get; set; }
        public Guid UserId { get; set; }
        public string EmployeeName { get; set; }
        public Guid DesignationId { get; set; }
        public DateTime LeaveAppliedDate { get; set; }
        public bool Edit { get; set; }
        public bool Delete { get; set; }
        public bool Approve { get; set; }
        public Guid OverallLeaveStatusId { get; set; }
        public string LeaveReason { get; set; }
        public Guid LeaveTypeId { get; set; }
        public string LeaveTypeName { get; set; }
        public string LeaveStatusName { get; set; }
        public DateTime LeaveDateFrom { get; set; }
        public DateTime LeaveDateTo { get; set; }
        public bool IsDeleted { get; set; }
        public Guid FromLeaveSessionId { get; set; }
        public Guid ToLeaveSessionId { get; set; }
        public string LeaveSessionName { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
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
            stringBuilder.Append(", FromLeaveSessionId = " + FromLeaveSessionId);
            stringBuilder.Append(", ToLeaveSessionId = " + ToLeaveSessionId);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", LeaveAppliedDate = " + LeaveAppliedDate);
            stringBuilder.Append(", LeaveTypeName = " + LeaveTypeName);
            stringBuilder.Append(", LeaveStatusName = " + LeaveStatusName);
            stringBuilder.Append(", LeaveSessionName = " + LeaveSessionName);
            stringBuilder.Append(", DesignationId = " + DesignationId);
            stringBuilder.Append(", Edit = " + Edit);
            stringBuilder.Append(", Delete = " + Delete);
            stringBuilder.Append(", Approve = " + Approve);
            stringBuilder.Append(", OverallLeaveStatusId = " + OverallLeaveStatusId);
            stringBuilder.Append(", LeaveAppliedDate = " + LeaveAppliedDate);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
