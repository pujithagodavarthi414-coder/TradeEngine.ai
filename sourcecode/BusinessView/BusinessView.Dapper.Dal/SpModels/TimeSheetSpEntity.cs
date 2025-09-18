using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class TimeSheetSpEntity
    {
        public Guid? TimeSheetId { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsAdmin { get; set; }
        public Guid BranchId { get; set; }
        public Guid? TimingId { get; set; }
        public string BranchName { get; set; }
        public DateTime TimesheetDate { get; set; }
        public DateTime LeaveAppliedDate { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public Guid TeamLeadId { get; set; }
        public string Guidime { get; set; }
        public DateTimeOffset? LunchBreakEndTime { get; set; }
        public DateTimeOffset? LunchBreakStartTime { get; set; }
        public DateTimeOffset? InTime { get; set; }
        public DateTimeOffset? OutTime { get; set; }
        public TimeSpan? DeadLine { get; set; }
        public Guid EmployeeList { get; set; }
        public string LeaveReason { get; set; }
        public Guid? ToLeaveSessionId { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public int? LunchDuration { get; set; }
        public string LunchBreakDiff { get; set; }
        public int? Minutes_Difference { get; set; }
        public string DeadLineTimeVal { get; set; }
        public string BreaksList { get; set; }
        public string LeaveTypeName { get; set; }
        public string LeaveSessionName { get; set; }
        public DateTime Date { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public string FeedThrough { get; set; }
    }

    public class TimesheetDisableorEnableEntity
    {
        public bool IsStart { get; set; }

        public DateTimeOffset? StartTime { get; set; }

        public bool IsLunchStart { get; set; }

        public DateTimeOffset? LunchStartTime { get; set; }

        public bool IsLunchEnd { get; set; }

        public DateTimeOffset? LunchEndTime { get; set; }

        public bool IsFinish { get; set; }

        public DateTimeOffset? FinishTime { get; set; }

        public bool IsBreakOut { get; set; }

        public DateTimeOffset? BreakOutTime { get; set; }

        public bool IsBreakIn { get; set; }

        public DateTimeOffset? BreakInTime { get; set; }

        public float SpentTime { get; set; }

        public string StartTimeAbbr { get; set; }
        public string StartTimeZoneName { get; set; }
        public string LunchStartTimeAbbr { get; set; }
        public string LunchStartTimeZoneName { get; set; }
        public string LunchEndTimeAbbr { get; set; }
        public string LunchEndTimeZoneName { get; set; }
        public string BreakInTimeAbbr { get; set; }
        public string BreakInTimeZoneName { get; set; }
        public string BreakOutTimeAbbr { get; set; }
        public string BreakOutTimeZoneName { get; set; }
        public string FinishTimeAbbr { get; set; }
        public string FinishTimeZoneName { get; set; }
    }

    public class TimesheetDisableorEnable
    {
        public string StartTime { get; set; }
        public string LunchStartTime { get; set; }
        public string LunchEndTime { get; set; }
        public string FinishTime { get; set; }
        public string BreakOutTime { get; set; }
        public string BreakInTime { get; set; }
        public bool Start { get; set; }
        public bool BreakIn { get; set; }
        public bool BreakOut { get; set; }
        public bool Finish { get; set; }
        public bool LunchStart { get; set; }
        public bool LunchEnd { get; set; }
        public bool TimeSheetRestricted { get; set; }
        public float SpentTime { get; set; }
    }

    public class TimesheetDisableorEnableApiModel
    {
        public DateTimeOffset? StartTime { get; set; }
        public DateTimeOffset? LunchStartTime { get; set; }
        public DateTimeOffset? LunchEndTime { get; set; }
        public DateTimeOffset? FinishTime { get; set; }
        public DateTimeOffset? BreakOutTime { get; set; }
        public DateTimeOffset? BreakInTime { get; set; }
        public bool Start { get; set; }
        public bool BreakIn { get; set; }
        public bool BreakOut { get; set; }
        public bool Finish { get; set; }
        public bool LunchStart { get; set; }
        public bool LunchEnd { get; set; }
        public bool TimeSheetRestricted { get; set; }
        public float SpentTime { get; set; }

        public string StartTimeAbbr { get; set; }
        public string StartTimeZoneName { get; set; }
        public string LunchStartTimeAbbr { get; set; }
        public string LunchStartTimeZoneName { get; set; }
        public string LunchEndTimeAbbr { get; set; }
        public string LunchEndTimeZoneName { get; set; }
        public string BreakInTimeAbbr { get; set; }
        public string BreakInTimeZoneName { get; set; }
        public string BreakOutTimeAbbr { get; set; }
        public string BreakOutTimeZoneName { get; set; }
        public string FinishTimeAbbr { get; set; }
        public string FinishTimeZoneName { get; set; }
    }
}

