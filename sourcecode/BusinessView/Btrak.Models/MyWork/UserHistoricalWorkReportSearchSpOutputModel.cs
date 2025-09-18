using System;

namespace Btrak.Models.MyWork
{
    public class UserHistoricalWorkReportSearchSpOutputModel
    {
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public Guid? SprintId { get; set; }
        public string SprintName { get; set; }
        public string Developer { get; set; }
        public Guid? UserId { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryUniqueName { get; set; }
        public string UserStoryName { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public DateTimeOffset? LatestDeployedDate { get; set; }
        public DateTimeOffset? ApprovedDate { get; set; }
        public string CurrentStatus { get; set; }
        public string EstimatedTime { get; set; }
        public string SpentTime { get; set; }
        public int? BouncedBackCount { get; set; }
        public string StatusHexValue { get; set; }
        public int? ProjectsCount { get; set; }
        public decimal? LoggedHours { get; set; }
        public decimal Productivity { get; set; }
        public int? VerifiedUserStories { get; set; }
        public int? BouncedBackUserStories { get; set; }
        public string ReportTo { get; set; }
        public DateTimeOffset? JoinedDate { get; set; }
        public int? AssignedUserStoriesCount { get; set; }
        public DateTimeOffset? LatestDevCompletedDate { get; set; }
        public DateTimeOffset? LatestDevInprogressDate { get; set; }
        public DateTimeOffset? QaApprovedDate { get; set; }
        public string ApprovedUserName { get; set; }
        public string BoardTypeName { get; set; }
        public int? BugsCount { get; set; }
        public int? RepalnUserStoriesCount { get; set; }
        public int? TotalCount { get; set; }
        public string ProfileImage { get; set; }
        public Guid? OwnerUserId { get; set; }
        public string ApprovedUserProfileImage { get; set; }
        public string ApprovedProfileImage { get; set; }
        public string GoalUniqueName { get; set; }
        public Guid? ApprovedUserId { get; set; }
        public bool? IsProductive { get; set; }
        public DateTimeOffset? InactiveDateTime { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }
        public DateTimeOffset? GoalParkedDateTime { get; set; }
        public DateTimeOffset? GoalInactiveDateTime { get; set; }
        public DateTimeOffset? ProjectInactiveDateTime { get; set; }
        public DateTime? SprintInactiveDatetime { get; set; }
        public decimal? GoalGrpTotal { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }

        public string SheetUpdatedDateTime { get; set; }
        public string SheetDeadLineDate { get; set; }
        public string SheetQaApprovedDate { get; set; }
        public string SheetDeployedDate { get; set; }
        public string SheetLatestDevCompletedDate { get; set; }
        public string SheetLatestDevInprogressDate { get; set; }

        public string JoinedDateTimeZoneName { get; set; }
        public string JoinedDateTimeZoneAbbreviation { get; set; }
        public string DeadLineDateTimeZoneName { get; set; }
        public string DeadLineDateTimeZoneAbbreviation { get; set; }
        public string QaApprovedDateTimeZoneName { get; set; }
        public string QaApprovedDateTimeZoneAbbreviation { get; set; }
        public string DeployedDateTimeZoneAbbreviation { get; set; }
        public string DeployedDateTimeZoneName { get; set; }
        public string DevCompletedDateTimeZoneName { get; set; }
        public string DevCompletedDateTimeZoneAbbreviation { get; set; }
        public string DevInprogressDateTimeZoneName { get; set; }
        public string DevInprogressDateTimeZoneAbbreviation { get; set; }
        public string UpdatedDateTimeZoneName { get; set; }
        public string UpdatedDateTimeZoneAbbreviation { get; set; }
    }
}