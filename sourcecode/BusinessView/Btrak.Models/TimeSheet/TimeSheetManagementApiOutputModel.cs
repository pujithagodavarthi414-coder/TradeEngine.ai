using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetManagementApiOutputModel
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
        public string UserProfileImage { get; set; }
        public string FeatureName { get; set; }
        public DateTimeOffset? LunchBreakEndTime { get; set; }
        public DateTimeOffset? LunchBreakStartTime { get; set; }
        public DateTimeOffset? InTime { get; set; }
        public DateTimeOffset? OutTime { get; set; }
        public TimeSpan? Deadline { get; set; }
        public string LunchBreakDiff { get; set; }
        public string UsersBreakTime { get; set; }
        public int UserBreaksCount { get; set; }
        public DateTime? MinutesDifference { get; set; }
        public decimal TotalTimeSpend { get; set; }
        public int CountOfUserBreak { get; set; }
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
        public Guid? TimeZoneId { get; set; }
        public string UserBreaks { get; set; }
        public bool IsMorningLate { get; set; }
        public bool IsAfterNoonLate { get; set; }
        public int? TotalCount { get; set; }
        public bool? IsNextDay { get; set; }
        public bool? IsBreaksBold { get; set; }
        public string SpentTimeDiff { get; set; }
        public string ActiveTimeInMin { get; set; }
        public string TotalActiveTimeInMin { get; set; }
        public string ProductiveTimeInMin { get; set; }
        public string TotalIdleTime { get; set; }
        public string LoggedTime { get; set; }

        public string InTimeAbbreviation { get; set; }
        public string OutTimeAbbreviation { get; set; }
        public string LunchStartAbbreviation { get; set; }
        public string LunchEndAbbreviation { get; set; }
        public string InTimeTimeZone { get; set; }
        public string OutTimeTimeZone { get; set; }
        public string LunchStartTimeZone { get; set; }
        public string LunchEndTimeZone { get; set; }
        public string Screenshots { get; set; }
        public DateTime? LatestInsertedTrackerDate { get; set; }
        public bool Status { get; set; }
        public string LeaveStatusColor { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsRejected { get; set; }
        public bool? IswaitingForApproval { get; set; }
        public int? BreakInMin { get; set; }
        public string StatusColour { get; set; }
        public string StatusName { get; set; }
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
            stringBuilder.Append(", LeaveStatusColor = " + LeaveStatusColor);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}