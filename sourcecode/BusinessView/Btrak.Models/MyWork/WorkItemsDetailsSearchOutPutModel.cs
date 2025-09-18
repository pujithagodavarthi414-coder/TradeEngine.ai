using System;

namespace Btrak.Models.MyWork
{
    public class WorkItemsDetailsSearchOutPutModel
    {

        public Guid UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByProfileImage { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public string Developer { get; set; }
        public string DeveloperProfileImage { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public string EstimatedTime { get; set; }
        public string SpentTime { get; set; }
        public Guid? OwnerUserId { get; set; }
        public DateTimeOffset? QaApprovedDate { get; set; }
        public string ApprovedUserName { get; set; }
        public string ApprovedUserProfileImage { get; set; }
        public Guid? ApprovedUserId { get; set; }
        public bool? IsBoardProductive { get; set; }
        public bool? IsBoardTracked { get; set; }
        public int? DelayDays { get; set; }
        public int? RepalnUserStoriesCount { get; set; }
        public int? BouncedBackCount { get; set; }
        public int? BugsCount { get; set; }
        public int? NumberOfTestScenarios { get; set; }
        public decimal? EffectiveProductivity { get; set; }
        public string BlockeddBy { get; set; }
        public string BlockedUserProfileImage { get; set; }
        public Guid? BlockedUserId { get; set; }
        public DateTimeOffset? BlockedDate { get; set; }
        public int? CommentsCount { get; set; }
        public string WorkItemIsInRed { get; set; }
        public string GoalIsInRed { get; set; }
        public string GoalResponsibleUser { get; set; }
        public string GoalResponsibleUserProfileImage { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public string ProjectResponsiblePerson { get; set; }
        public string ProjectResponsiblePersonProfileImage { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public string AssigneeBranchName { get; set; }
        public DateTimeOffset? LastUpdatedDate { get; set; }
        public string LastUpdatedBy { get; set; }
        public string LastUpdatedUserProfileImage { get; set; }
        public Guid? LastUpdatedUserId { get; set; }
        public string WorkItemType { get; set; }
        public string WorkItemPriority { get; set; }
        public int? TotalCount { get; set; }
        public DateTimeOffset? InactiveDateTime { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }
        public DateTimeOffset? GoalParkedDateTime { get; set; }
        public DateTimeOffset? GoalInactiveDateTime { get; set; }
        public DateTimeOffset? ProjectInactiveDateTime { get; set; }
        public Guid? SprintId { get; set; }
        public string SprintName { get; set; }
        public DateTime? SprintInactiveDatetime { get; set; }
        public string ApprovedDateTimeZoneName { get; set; }
        public string CreatedDateTimeZoneName { get; set; }
        public string DeadlineDateTimeZoneName { get; set; }
        public string BlockedTimeZoneName { get; set; }
        public string ApprovedDateTimeZoneAbbreviation { get; set; }
        public string CreatedDateTimeZoneAbbreviation { get; set; }
        public string DeadlineDateTimeZoneAbbreviation { get; set; }
        public string BlockedTimeZoneAbbreviation { get; set; }
    }
}
