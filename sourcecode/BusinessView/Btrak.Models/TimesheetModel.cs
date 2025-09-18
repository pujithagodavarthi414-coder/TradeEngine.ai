using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Btrak.Models
{
    public class FeedTimeSheetModel
    {
        public Guid Id { get; set; }

        public Guid UserId { get; set; }
      
        public string FullName { get; set; }

        public Guid LeaveTypeId { get; set; }

        public Guid LeaveSessionId { get; set; }

        [Required(ErrorMessage = "Please enter Date")]
        [DataType(DataType.Date)]

        public DateTime? Date { get; set; }
        public DateTime? Guidime { get; set; }
        public DateTimeOffset? LunchBreakEndTime { get; set; }
        public DateTimeOffset? LunchBreakStartTime { get; set; }
        public DateTimeOffset? OutTime { get; set; }
        public DateTimeOffset? InTime { get; set; }
        public bool IsAbsent { get; set; }
        public string ReasonforAbsent { get; set; }
        public Guid loggedUserId { get; set; }
        public bool NextDay { get; set; }
        public Guid TimeZoneId { get; set; }
        public Guid TimesheetConstants { get; set; }

        public bool IsPermitted { get; set; }
        public bool IsMorning { get; set; }
        public TimeSpan? PermittedTime { get; set; }
        public Guid PermissionReasonId { get; set; }
        public bool IsFeed { get; set; }
    }

    public class GetTimesheetModel
    {
        public DateTime DateFrom { get; set; }
        public DateTime DateTo { get; set; }
        public Guid TeamLeadId { get; set; }
        public Guid BranchId { get; set; }
        public int IsAbsentorPresentStatus  { get; set; }
        public string ClickType { get; set; }
        public string DayorWeekType { get; set; }
        public Guid UserId { get; set; }
        public string Type { get; set; }
    }

    public class ViewTimesheetModel
    {
        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsAdmin { get; set; }
        public Guid BranchId { get; set; }
        public Guid? TimingId { get; set; }
        public string BranchName { get; set; }
        public DateTime Date { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public Guid TeamLeadId { get; set; }
        public string Guidime { get; set; }
        public string LunchBreakEndTime { get; set; }
        public string LunchBreakStartTime { get; set; }
        public string OutTime { get; set; }
        public string InTime { get; set; }
        public TimeSpan? DeadLineTime { get; set; }
        public Guid EmployeeList { get; set; }
        public string ReasonForAbsent { get; set; }
        public Guid? LeaveSessionId { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public int? LunchDuration { get; set; }
        public string LunchDiffHours { get; set; }
        public int? LunchDeadLineTime { get; set; }
        public string DeadLineTimeVal { get; set; }
        public string BreaksList { get; set; }
        public string LunchBreak { get; set; }
        public DateTime? UtcIntime { get; set; }
        public string CreatedDateTime { get; set; }
        public string FeedThrough { get; set; }
    }

    public class TimesheetModelForButtons
    {
        public DateTimeOffset? InTime { get; set; }
        public DateTimeOffset? OutTime { get; set; }
        public DateTimeOffset? LunchStart { get; set; }
        public DateTimeOffset? LunchEnd { get; set; }
        public bool? IsAbsent { get; set; }
    }

    public class TimesheetModelForBreakButtons
    {
        public DateTimeOffset? BreakIn { get; set; }
        public DateTime Date { get; set; }
        public DateTimeOffset? BreakOut { get; set; }
    }

    public class BreakButtonsForDisableOrEnable
    {
        public string BreakIn { get; set; }
        public DateTime Date { get; set; }
        public string BreakOut { get; set; }
    }

    public class TimesheetPermissionsModel
    {
        public Guid Id
        { get; set; }

        public Guid UserId
        { get; set; }

        public string Date
        { get; set; }

        public string TimeString
        { get; set; }

        public TimeSpan? Duration
        { get; set; }

        public double? DurationInMin
        { get; set; }

        public bool IsMorning
        { get; set; }

        public string FullName
        { get; set; }

        public Guid ReasonId
        { get; set; }

        public string ReasonName
        { get; set; }

        public DateTime CreatedDateTime
        { get; set; }

        public Guid CreatedByUserId
        { get; set; }

        public DateTime? UpdatedDateTime
        { get; set; }

        public Guid? UpdatedByUserId
        { get; set; }
    }

    public class PermissionReasonsModel
    {
            public Guid Id
            { get; set; }

            public string ReasonName
            { get; set; }

    }

    public class PermissionListModel
    {
        public Guid UserId
        { get; set; }

        public string Date
        { get; set; }

        public string EmployeeName
        { get; set; }

        public string LateTime
        { get; set; }

        public Guid? PermissionId
        { get; set; }

        public string Duration
        { get; set; }

        public double? DurationInMinutes
        { get; set; }

        public Guid? PermissionReasonId
        { get; set; }

        public string ReasonName
        { get; set; }

        public string PermissionGivenDate
        { get; set; }

    }

    public class UploadTimesheetModel
    {
        public Guid Id
        { get; set; }

        public DateTime Date
        { get; set; }

        public Guid BranchId
        { get; set; }

        public string TimeString
        { get; set; }

        public List<FilesModel> Files { get; set; }
        public Guid FilesId { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public Guid CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
    }
}
