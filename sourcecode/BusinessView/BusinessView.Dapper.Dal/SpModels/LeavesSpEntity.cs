using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class LeavesSpEntity
    {
        public Guid LeaveApplicationId { get; set; }
        public Guid UserId { get; set; }
        public string EmployeeName { get; set; }
        public Guid DesignationId { get; set; }
        public string Designation { get; set; }
        public DateTime LeaveAppliedDate { get; set; }
        public string TeamLeadStatus { get; set; }
        public string CEOStatus { get; set; }
        public bool Edit { get; set; }
        public bool Delete { get; set; }
        public bool Approve { get; set; }
        public bool Reject { get; set; }
        public Guid OverallLeaveStatusId { get; set; }
        public string OverallLeaveStatus { get; set; }
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
    }
}