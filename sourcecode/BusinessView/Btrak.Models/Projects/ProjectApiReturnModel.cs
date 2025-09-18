using System;

namespace Btrak.Models.Projects
{
    public class ProjectApiReturnModel
    {
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectTypeId { get; set; }
        public string ProjectTypeName { get; set; }
        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string ProjectStatusColor { get; set; }
        public string Email { get; set; }
        public int ActiveGoalCount { get; set; }
        public int NumberOfReds { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public string Password { get; set; }
        public bool IsPasswordForceReset { get; set; }
        public bool IsActive { get; set; }
        public Guid TimeZoneId { get; set; }
        public string MobileNo { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public Guid UpdatedByUserId { get; set; }
        public string FullName { get; set; }
        public Guid CompanyId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string ProfileImage { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public string TimeZoneName { get; set; }
        public string StartDateTimeZoneAbbreviation { get; set; }
        public string StartDateTimeZoneName { get; set; }
        public string EndDateTimeZoneAbbreviation { get; set; }
        public string EndDateTimeZoneName { get; set; }
        public Guid ProjectResponsiblePersonId { get; set; }
        public UserMiniModel ProjectResponsiblePerson { get; set; }
        public int TestSuiteCount { get; set; }
        public int TestRunCount { get; set; }
        public int MilestoneCount { get; set; }
        public int ReportCount { get; set; }
        public int CasesCount { get; set; }
        public int ViewGoalsPermissionCount { get; set; }
        public bool IsDateTimeConfiguration { get; set; }
        public bool IsSprintsConfiguration { get; set; }
        public int AuditsCount { get; set; }
        public int ConductsCount { get; set; }
        public int AuditReportsCount { get; set; }
        public int AuditQuestionsCount { get; set; }
        public DateTimeOffset? ProjectStartDate { get; set; }
        public DateTimeOffset? ProjectEndDate { get; set; }
    }
}
