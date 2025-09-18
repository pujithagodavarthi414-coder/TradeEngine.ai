using System;

namespace Btrak.Models
{
    public class LeavesModel
    {
        public Guid LeaveApplicationId { get; set; }
        public Guid UserId { get; set; }
        public string EmployeeName { get; set; }
        public Guid LeaveTypeId { get; set; }
        public string LeaveType { get; set; }
        public Guid OverallLeaveStatusId { get; set; }
        public string OverallLeaveStatus { get; set; }
        public Guid FromLeaveSessionId { get; set; }
        public string FromLeaveSession { get; set; }
        public Guid ToLeaveSessionId { get; set; }
        public string ToLeaveSession { get; set; }
        public Guid CreatedByUserId { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public string LeaveReason { get; set; }
        public DateTime LeaveAppliedDate { get; set; }
        public DateTime LeaveDateFrom { get; set; }
        public DateTime LeaveDateTo { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public bool IsDeleted { get; set; } 
    }

    public class LeaveModel
    {
        public Guid LeaveApplicationId { get; set; }
        public Guid UserId { get; set; }
        public DateTime LeaveAppliedDate { get; set; }
        public string LeaveReason { get; set; }
        public Guid LeaveTypeId { get; set; }
        public string LeaveDateFrom { get; set; }
        public string LeaveDateTo { get; set; }
        public bool IsDeleted { get; set; }
        public Guid? OverAllLeaveStatusId { get; set; }
        public Guid FromLeaveSessionId { get; set; }
        public Guid ToLeaveSessionId { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTime CreatedByDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public string EmployeeName { get; set; }
    }

    public class LeaveApplicationModel
    {
        public Guid? LeaveApplicationId { get; set; }
        public Guid UserId { get; set; }
        public string LeaveReason { get; set; }
        public Guid LeaveTypeId { get; set; }
        public Guid FromLeaveSessionId { get; set; }
        public Guid ToLeaveSessionId { get; set; }
        public DateTime? LeaveDateFrom { get; set; }
        public DateTime? LeaveDateTo { get; set; }
        public DateTime? LeaveAppliedDate { get; set; }
        public bool IsDeleted { get; set; }
        public Guid? OverallLeaveStatusId { get; set; }
        public Guid OperationPerformedBy { get; set; }
    }

    public class LeaveInfoModel
    {
        public int LeaveAllowance { get; set; }
        public decimal LeavesApproved { get; set; }
        public int LeavesRejected { get; set; }
        public int PendingLeaves { get; set; }
        public Guid UserId { get; set; }
        public decimal RemainingLeaves { get; set; }
        public int LeavesCount { get; set; }
    }

    public class LeaveStatusModel
    {
        public Guid ApproveId { get; set; }
        public Guid RejectId { get; set; }
    }
}
