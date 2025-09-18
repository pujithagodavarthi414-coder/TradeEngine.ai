using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveManagementOutputModel
    {
        public Guid? LeaveApplicationId { get; set; }
        public Guid? UserId { get; set; }
        public string LeaveReason { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public DateTime? LeaveDateFrom { get; set; }
        public DateTime? LeaveDateTo { get; set; }
        public bool? IsDeleted { get; set; }
        public Guid? OverallLeaveStatusId { get; set; }
        public Guid? FromLeaveSessionId { get; set; }
        public Guid? ToLeaveSessionId { get; set; }
        public string EmployeeName { get; set; }
        public int TotalCount { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime LeaveAppliedDate { get; set; }
        public string LeaveTypeName { get; set; }
        public string LeaveStatusName { get; set; }
        public string ToLeaveSessionName { get; set; }
        public string FromLeaveSessionName { get; set; }
        public string StatusSetByUserName { get; set; }
        public float? Days { get; set; }
        public string ApproveList { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsToReApply { get; set; }
        public bool? IsAdmin { get; set; }
        public bool? IsRejected { get; set; }
        public bool? IsApproved { get; set; }
        public string LeaveStatusColour { get; set; }
        public DateTime? Start { get; set; }
        public DateTime? End { get; set; }
        public DateTime? StartFrom { get; set; }
        public DateTime? EndTo { get; set; }
        public Guid? Id { get; set; }
        public bool? IsCalendarView { get; set; }
        public string Title { get; set; }
        public string ProfileImage { get; set; }
        public LeaveManagementDataItem DataItem { get; set; }
        public string LeaveTypeColor { get; set; }
        public class LeaveManagementDataItem
        {
            public string LeaveStatusColour { get; set; }
            public string Description { get; set; }
            public string ProfileImage { get; set; }
            public string EmployeeName { get; set; }
        }
        
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
            stringBuilder.Append(", LeaveSessionName = " + FromLeaveSessionName);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsRejected = " + IsRejected);
            stringBuilder.Append(", Start = " + Start);
            stringBuilder.Append(", End = " + End);
            stringBuilder.Append(", IsCalendarView = " + IsCalendarView);
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", DataItem = " + DataItem);

            return stringBuilder.ToString();
        }
    }
}
