using System;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class GetTimeSheetDetailsModel : SearchCriteriaInputModelBase
    {
        public GetTimeSheetDetailsModel() : base(InputTypeGuidConstants.TimeSheetCommandTypeGuid)
        {
        }

        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid OperationsPerformedBy { get; set; }
        public Guid BranchId { get; set; }
        public Guid TeamLeadId { get; set; }
        public Guid? TimeSheetId { get; set; }
        public DateTime? Date { get; set; }
        public bool IsAdmin { get; set; }
        public Guid? TimingId { get; set; }
        public string BranchName { get; set; }
        public DateTime? TimeSheetDate { get; set; }
        public string EmployeeName { get; set; }
        public string FeatureName { get; set; }
        public DateTimeOffset? LunchBreakEndTime { get; set; }
        public DateTimeOffset? LunchBreakStartTime { get; set; }
        public DateTimeOffset? InTime { get; set; }
        public DateTimeOffset? OutTime { get; set; }
        public DateTime? Deadline { get; set; }
        public DateTime? LunchBreakDiff { get; set; }
        public DateTime? MinutesDifference { get; set; }
        public DateTime? TotalTimeSpend { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public int? FeedThrough { get; set; }
        public DateTime? LeaveDateFrom { get; set; }
        public DateTime? LeaveAppliedDate { get; set; }
        public string LeaveReason { get; set; }
        public Guid? ToLeaveSessionId { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public string LeaveTypeName { get; set; }
        public string LeaveSessionName { get; set; }
        public string Description { get; set; }
        public Guid? FeatureId { get; set; }
        public Guid? UserStoryId { get; set; }
    }

    public class TimeSheetModel
    {
        public Guid ButtonTypeId { get; set; }
        public Guid? TimeSheetId { get; set; }
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? Date { get; set; }
        public DateTimeOffset? InTime { get; set; }
        public DateTimeOffset? LunchBreakStartTime { get; set; }
        public DateTimeOffset? LunchBreakEndTime { get; set; }
        public DateTimeOffset? OutTime { get; set; }
        public Guid LoggedUserId { get; set; }
        public bool IsFeed { get; set; }
        public string LeaveTypeName { get; set; }
    }

    public class TimeSheetButtonDetails
    {
        public Guid? UserId { get; set; }
        public DateTimeOffset StartTime { get; set; }
        public DateTimeOffset LunchStartTime { get; set; }
        public DateTimeOffset LunchEndTime { get; set; }
        public DateTimeOffset BreakInTime { get; set; }
        public DateTimeOffset BreakOutTime { get; set; }
        public DateTimeOffset FinishTime { get; set; }
        public bool IsStart { get; set; }
        public bool IsLunchStart { get; set; }
        public bool IsLunchEnd { get; set; }
        public bool IsBreakIn { get; set; }
        public bool IsBreakOut { get; set; }
        public bool IsFinish { get; set; }
    }
}
