using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.LeaveManagement
{
    public class LeavesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public LeavesSearchCriteriaInputModel() : base(InputTypeGuidConstants.LeaveInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public string LeaveReason { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public Guid? BranchId { get; set; }
        public DateTime? LeaveDateFrom { get; set; }
        public DateTime? LeaveDateTo { get; set; }
        public DateTime? LeaveAppliedDate { get; set; }
        public DateTime? Date { get; set; }
        public bool? IsDeleted { get; set; }
        public Guid? OverallLeaveStatusId { get; set; }
        public Guid? FromLeaveSessionId { get; set; }
        public Guid? ToLeaveSessionId { get; set; }
        public Guid? LeaveApplicationId { get; set; }
        public string LeaveApplicationIds { get; set; }
        public string LeaveApplicationIdsXml { get; set; }
        public bool? IsWaitingForApproval { get; set; }
        public bool? IsCalendarView { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? EntityId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", LeaveApplicationId = " + LeaveApplicationId);
            stringBuilder.Append(", OverallLeaveStatusId = " + OverallLeaveStatusId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", LeaveReason = " + LeaveReason);
            stringBuilder.Append(", LeaveTypeId = " + LeaveTypeId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", LeaveDateFrom = " + LeaveDateFrom);
            stringBuilder.Append(", LeaveDateTo = " + LeaveDateTo);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", FromLeaveSessionId = " + FromLeaveSessionId);
            stringBuilder.Append(", ToLeaveSessionId = " + ToLeaveSessionId);
            stringBuilder.Append(", EntityId = " + EntityId);
            return stringBuilder.ToString();
        }
    }
}