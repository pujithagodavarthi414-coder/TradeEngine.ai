using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class EmployeeAttendanceSpEntity
    {
        public Guid CompanyId { get; set; }
        public string CompanyName { get; set; }
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public DateTime? Date { get; set; }
        public TimeSpan? InTime { get; set; }
        public TimeSpan? OutTime { get; set; }
        public TimeSpan? LunchBreakStartTime { get; set; }
        public TimeSpan? LunchBreakEndTime { get; set; }
        public bool? IsHoliday { get; set; }
        public bool? IsSunday { get; set; }
        public bool? IsNoShift { get; set; }
        public TimeSpan? DeadlineTime { get; set; }
        public TimeSpan? InTimeStartFrom { get; set; }
        public bool? IsAbsent { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public string LeaveType { get; set; }
        public string LateBy { get; set; }
        public bool? IsActive { get; set; }
        public int? SummaryValue { get; set; }
        public string Summary { get; set; }
    }

    public class EmployeeWorkingDaysSpEntity
    {
        public Guid UserId { get; set; }
        public string EmployeeId { get; set; }
        public string Name { get; set; }
        public string SurName { get; set; }
        public string FullName { get; set; }
        public int? TotalDays { get; set; }
        public int? NoOfWorkingDays { get; set; }
        public int? NoOfAbsents { get; set; }
        public int? NoOfLateDays { get; set; }
        public int? NoOfWorkedDays { get; set; }
        public int? NoOfHolidays { get; set; }
    }

    public class EmployeeSpentTimeSpEntity
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public DateTime? Date { get; set; }
        public string TimeSpent { get; set; }
        public decimal? TotalTimeSpent { get; set; }
    }

    public class LateEmployeeSpEntity
    {
        public Guid? UserId { get; set; }
        public string FullName { get; set; }
        public string DaysLateFor { get; set; }
        public int? DaysLate { get; set; }
        public int? PermittedDays { get; set; }
        public int? DaysWithOutPermission { get; set; }
        public int? SpentTime { get; set; }
        public int? DaysMoreTimeSpent { get; set; }
    }

    public class EmployeePresenceSpEntity
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string Status { get; set; }
    }

    public class HrDashboardLeavesReportSpEntity
    {
        public Guid? UserId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public DateTime? DateOfJoining { get; set; }
        public string BranchName { get; set; }
        public float? EligibleLeaves { get; set; }
        public float? EligibleLeavesYTD { get; set; }
        public float? LeavesTaken { get; set; }
        public float? OnsiteLeaves { get; set; }
        public float? WorkFromHomeLeaves { get; set; }
        public float? UnplannedLeaves { get; set; }
        public float? PaidLeaves { get; set; }
        public float? UnPaidLeaves { get; set; }
    }

    public class HrDashboardMorningLateSpEntity
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string DaysLateFor { get; set; }
        public int? DaysLate { get; set; }
        public int? PermittedDays { get; set; }
    }

    public class HrDashboardAfterNoonLateSpEntity
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string DaysLateFor { get; set; }
        public int? DaysLate { get; set; }
    }

    public class HrDashboardMoreSpentTimeSpEntity
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string DaysMoreTimeSpentFor { get; set; }
        public int? DaysMoreTimeSpent { get; set; }
        public string SpentTime { get; set; }
    }

    public class HrTopAndBottomSpentTimeEmployeeSpEntity
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string DaysMoreTimeSpentFor { get; set; }
        public int? DaysMoreTimeSpent { get; set; }
        public int? SpentTime { get; set; }
    }

    public class HrDashboardMorningAndAfternoonTopLateEmployeeSpEntity
    {
        public Guid? UserId { get; set; }
        public string EmployeeName { get; set; }
        public int? LateDaysCount { get; set; }
    }

    

    public class HrDashboardLateEmployeeCountSpEntity
    {
        public DateTime? Date { get; set; }
        public int? TotalCount { get; set; }
        public int? MorningLateCount { get; set; }
        public int? LunchbreakLateCount { get; set; }
        public int? MorningLatePermissionCount { get; set; }
        public int? MorningLateExcludingPermissionCount { get; set; }
    }

    public class HrDashboardEachAuditSpEntity
    {
        public Guid UserId { get; set; }
        public Guid FeatureId { get; set; }
        public DateTime? ViewedDate { get; set; }
        public string UserName { get; set; }
        public string FeatureName { get; set; }
    }

    public class HrDashboardMoreTimeViewedAuditSpEntity
    {
        public Guid FeatureId { get; set; }
        public string FeatureName { get; set; }
        public int? ViewedCount { get; set; }
    }

    public class HrDashboardEmployeeMtdAttendanceSpEntity
    {
        public Guid? EmployeeId { get; set; }
        public string FullName { get; set; }
        public DateTime? Date { get; set; }
        public TimeSpan? Intime { get; set; }
        public TimeSpan? LunchBreakStartTime { get; set; }
        public TimeSpan? LunchBreakEndTime { get; set; }
        public TimeSpan? DeadlineTime { get; set; }
        public decimal? MorningLate { get; set; }
        public decimal? LunchLate { get; set; }
        public decimal? Top5PercentOfMorningLate { get; set; }
        public decimal? Top5PercentOfLunchLate { get; set; }
        public decimal? LongSickLeave { get; set; }
        public decimal? CasualLeave { get; set; }
        public decimal? MondayLeave { get; set; }
        public int? DateKey { get; set; }
        public decimal? IsHoliday { get; set; }
        public decimal? IsSunday { get; set; }
        public string Description { get; set; }
        public int? Value { get; set; }
    }

    public class HrDashboardEmployeeYtdAttendanceSpEntity
    {
        public Guid? EmployeeId { get; set; }
        public string FullName { get; set; }
        public DateTime? Date { get; set; }
        public int? MorningLate { get; set; }
        public int? LunchLate { get; set; }
        public int? Top5PercentOfMorningLate { get; set; }
        public int? Top5PercentOfLunchLate { get; set; }
        public int? LongSickLeave { get; set; }
        public int? CasualLeave { get; set; }
        public int? MondayLeave { get; set; }
        public int? WorkingHours { get; set; }
    }

    public class HrDashboardDailyTasksSpEntity
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public Guid UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime EndDateTime { get; set; }
    }

    public class HrDashboardProcessDashboardOverallStatusSpEntity
    {
        public string TeamLead { get; set; }
        public string StatusColor { get; set; }
        public DateTime? GeneratedDate { get; set; }
        public int? StatusNumber { get; set; }
        public int? RedCount { get; set; }
    }

    public class HrDashboardProcessDashboardOverallStatusWithSpEntity
    {
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public Guid? TeamLeadId { get; set; }
        public string TeamLead { get; set; }
        public string StatusColor { get; set; }
        public DateTime? GeneratedDateTime { get; set; }
        public DateTime? GeneratedDate { get; set; }
        public int? StatusNumber { get; set; }
    }

    public class HrDashboardTaskSpentTimeSpEntity
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public DateTime? Date { get; set; }
        public string UserStoryName { get; set; }
        public int? SpentTime { get; set; }
    }

    public class MorningLateWithPermissionSpEntity
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public string DaysLateFor { get; set; }
        public int? DaysLate { get; set; }
        public int? PermittedDays { get; set; }
    }

    public class LogTimeReportSpEntity
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public DateTime Date { get; set; }
        public int? SpentTime { get; set; }
        public int? LogTime { get; set; }
        public string Status { get; set; }
    }

    public class MonthlyLogReportSpEntity
    {
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public DateTime? Date { get; set; }
        public int? SpentTime { get; set; }
        public int? LogTime { get; set; }
        public int? SummaryValue { get; set; }
        public string Summary { get; set; }
    }

    public class LineManagersSpEntity
    {
        public Guid UserId { get; set; }
        public  string UserName { get; set; }
    }
}
