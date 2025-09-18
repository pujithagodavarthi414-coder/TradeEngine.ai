using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace Btrak.Models.HrDashboard
{
    public class EmployeeAttendanceModel
    {
        public List<object> Names { get; set; }
        public List<object> Dates { get; set; }
        public List<object> Summary { get; set; }
        public List<object> SummaryValue { get; set; }
    }

    public class EmployeeSpentTimeModel
    {
        public List<object> UserName { get; set; }
        public List<object> Date { get; set; }
        public List<object> TimeSpent { get; set; }
        public List<object> TotalTimeSpent { get; set; }
    }

    public class LateEmployeeModel
    {
        public Guid? UserId { get; set; }
        public string FullName { get; set; }
        public string DaysLateFor { get; set; }
        public int? DaysLate { get; set; }
        public int? DaysMoreTimeSpent { get; set; }
        public int? PermittedDays { get; set; }
        public int? NotPermittedDays { get; set; }
    }

    public class EmployeePresenceModel
    {
        public Guid? UserId { get; set; }
        public string FullName { get; set; }
        public string Status { get; set; }
    }

    public class LeavesReportModel
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

    public class AfterNoonLateEmployeeModel
    {
        public string FullName { get; set; }
        public int? DaysLate { get; set; }
    }

    public class MoreSpentTimeEmployeesModel
    {
        public string FullName { get; set; }
        public string SpentTime { get; set; }
    }

    public class TopSpentTimeModel
    {
        public string EmployeeName { get; set; }
        public int? SpentTime { get; set; }
    }

    public class BottomSpentTimeModel
    {
        public string EmployeeName { get; set; }
        public int? SpentTime { get; set; }
    }

    public class MorningAndAfterNoonLateEmployeeModel
    {
        public string EmployeeName { get; set; }
        public int? LateDaysCount { get; set; }
    }

    public class EmployeeMtdAttendenceModel
    {
        public List<object> Date { get; set; }
        public List<object> Value { get; set; }
        public List<object> Description  { get; set; }
        public List<object> Summary { get; set; }
    }

    public class ProcessDashboardOverallStatusModel
    {
        public List<object> StatusDate { get; set; }
        public List<object> TeamLead { get; set; }
        public List<object> StatusColor { get; set; }
        public List<object> Summary { get; set; }
    }

    public class ProcessDashboardOverallStatusWithGoalsModel
    {
        public List<object> GoalStatusDate { get; set; }
        public List<object> GoalStatusColor { get; set; }
        public List<object> Summary { get; set; }
        public List<object> GoalName { get; set; }
    }

    public class TaskSpentTimeReportModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string Date { get; set; }
        public int? SpentTime { get; set; }
        public string UserStory { get; set; }
    }

    public class HrDashboardModel
    {
        public string TaskName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
    }

    public class AuditJson
    {
        public Guid UserId { get; set; }
        public Guid? FeatureId { get; set; }
        public DateTime DateTimeCreated { get; set; }
    }

    public class GanttChartModel
    {
        public List<HrDashboardModel> HrDashboardModels { get; set; }
        public int Count { get; set; }
    }

    public class OrgChartList
    {
        public List<USP_GetOrgChart_Result> OrgChartCeoList { get; set; }
        public List<USP_GetOrgChart_Result> OrgChartTeamLeadList { get; set; }
        public List<USP_GetOrgChart_Result> OrgChartMembersList { get; set; }
        public List<USP_GetOrgChart_Result> OrgChartAnalystList { get; set; }
    }

    public class ActiveEmployee
    {
        public Guid ActiveEmployeeId { get; set; }
        public string ActiveEmployeeImage { get; set; }
        public string ActiveEmployeeName { get; set; }
    }


    public class LateEmployeeCountModel
    {
        public List<object> Date { get; set; }
        public List<object> MorningLateCount { get; set; }
        public List<object> LunchbreakLateCount { get; set; }
        public List<object> MorningLatePermissionCount { get; set; }
        public List<object> MorningLateExcludingPermissionCount { get; set; }
    }

    public class EmployeeYtdAttendenceModel
    {
        public List<KeyValuePair<string, int?>> Dataobjects { get; set; }
        public List<object> AllMonthDates { get; set; }
        public List<KeyValuePair<string, int?>> DateWithHours { get; set; }
    }
    
    public class AuditJsonFormatterModel
    {
        public string UserName { get; set; }
        public string FeatureName { get; set; }
        public string ViewedDateTime { get; set; }
    }

    public class AllFeatures
    {
        public int FeatureId { get; set; }
        public string FeatureName { get; set; }
    }

    public class Leaves
    {
        public Guid Id { get; set; }
        public string Text { get; set; }
    }

    public class FeatureUsageModel
    {
        public int? ViewedCount { get; set; }
        public string FeatureName { get; set; }
    }

    public class LeaveManagementModel
    {
        public int UserId { get; set; }
        [Required(ErrorMessage = "Leave Type Field is Mandatory")]
        public Guid LeaveTypeId { get; set; }
        [Required(ErrorMessage = "Leave Session From Field is Mandatory")]
        public Guid LeaveSessionFromId { get; set; }
        [Required(ErrorMessage = "Leave Session To Field is Mandatory")]
        public Guid LeaveSessionToId { get; set; }
        [Required(ErrorMessage = "Leave From Date Field is Mandatory")]
        public DateTime LeaveFromDate { get; set; }
        [Required(ErrorMessage = "Leave To Date Field is Mandatory")]
        public DateTime LeaveToDate { get; set; }
        [Required(ErrorMessage = "Leave Reason Field is Mandatory")]
        public string LeaveReason { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public int? UpdatedByUserId { get; set; }

    }
    public class CalendarModel
    {
        public List<KeyValuePair<string, float?>> Dataobjects { get; set; }
        public List<object> AllMonthDates { get; set; }
        public List<KeyValuePair<string, int?>> DateWithHours { get; set; }
    }
    public class LeaveListModel
    {
        public Guid? LeaveApplicationId { get; set; }
        public int? UserId { get; set; }
        public string UserName { get; set; }
        public string LeaveType { get; set; }
        public string LeaveReason { get; set; }
        public string LeaveDateFrom { get; set; }
        public string LeaveDateTo { get; set; }
        public string TeamLeadStatus { get; set; }
        public string CeoStatus { get; set; }
        public string Description { get; set; }
        public string LeaveAppliedDate { get; set; }
        public string LeaveSessionFrom { get; set; }
        public string LeaveSessionTo { get; set; }
        public Guid? LeaveApprovalId { get; set; }
        public List<SelectListItem> LeaveApprovalFilter { get; set; }
    }

    public class LogTimeReportModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public DateTime Date { get; set; }
        public string DateString { get; set; }
        public int? SpentTime { get; set; }
        public int? LogTime { get; set; }
        public string Status { get; set; }
    }

    public class MonthlyLogReportModel
    {
        public List<object> Names { get; set; }
        public List<object> Dates { get; set; }
        public List<object> Summary { get; set; }
        public List<object> SummaryValue { get; set; }
        public int holidaysCount { get; set; }
    }
}
