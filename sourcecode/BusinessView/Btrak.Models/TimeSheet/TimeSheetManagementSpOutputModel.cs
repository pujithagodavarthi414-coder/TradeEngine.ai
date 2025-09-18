using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetManagementSpOutputModel
    {
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
        public DateTime? LunchBreakEndTime { get; set; }
        public DateTime? LunchBreakStartTime { get; set; }
        public DateTime? InTime { get; set; }
        public DateTime? OutTime { get; set; }
        public TimeSpan? Deadline { get; set; }
        public string LunchBreakDiff { get; set; }
        public DateTime? MinutesDifference { get; set; }
        public decimal TotalTimeSpend { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string FeedThrough { get; set; }
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
        public string UserBreaks { get; set; }
        public bool IsMorningLate { get; set; }
        public bool IsAfterNoonLate { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", OperationsPerformedBy = " + OperationsPerformedBy);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", TeamLeadId = " + TeamLeadId);
            stringBuilder.Append(", TimeSheetId = " + TimeSheetId);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", IsAdmin = " + IsAdmin);
            stringBuilder.Append(", TimingId = " + TimingId);
            stringBuilder.Append(", BranchName = " + BranchName);
            stringBuilder.Append(", TimeSheetDate = " + TimeSheetDate);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", FeatureName = " + FeatureName);
            stringBuilder.Append(", LunchBreakEndTime = " + LunchBreakEndTime);
            stringBuilder.Append(", LunchBreakStartTime = " + LunchBreakStartTime);
            stringBuilder.Append(", InTime = " + InTime);
            stringBuilder.Append(", OutTime = " + OutTime);
            stringBuilder.Append(", Deadline = " + Deadline);
            stringBuilder.Append(", LunchBreakDiff = " + LunchBreakDiff);
            stringBuilder.Append(", MinutesDifference = " + MinutesDifference);
            stringBuilder.Append(", TotalTimeSpend = " + TotalTimeSpend);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", FeedThrough = " + FeedThrough);
            stringBuilder.Append(", LeaveDateFrom = " + LeaveDateFrom);
            stringBuilder.Append(", LeaveAppliedDate = " + LeaveAppliedDate);
            stringBuilder.Append(", LeaveReason = " + LeaveReason);
            stringBuilder.Append(", ToLeaveSessionId = " + ToLeaveSessionId);
            stringBuilder.Append(", LeaveTypeId = " + LeaveTypeId);
            stringBuilder.Append(", LeaveTypeName = " + LeaveTypeName);
            stringBuilder.Append(", LeaveSessionName = " + LeaveSessionName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", FeatureId = " + FeatureId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserBreaks = " + UserBreaks);
            stringBuilder.Append(", IsMorningLate = " + IsMorningLate);
            stringBuilder.Append(", IsAfterNoonLate = " + IsAfterNoonLate);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}