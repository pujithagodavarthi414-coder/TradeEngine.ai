using Btrak.Models.MyWork;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Models.UserStory
{
    public class UserStorySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public UserStorySearchCriteriaInputModel() : base(InputTypeGuidConstants.UserStorySearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public string ProjectName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public DateTimeOffset? ActualDeadLineDate { get; set; }
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public Guid? ParentUserStoryId { get; set; }
        public Guid? AuditConductQuestionId { get; set; }
        public Guid? ConductId { get; set; }
        public DateTime? ParkedDateTime { get; set; }
        public int? Order { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? GoalStatusId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusIds { get; set; }
        public string OwnerUserIds { get; set; }
        public bool? IsStatusMultiSelect { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsUserActions { get; set; }
        public Guid? ScenarioId { get; set; }
        public Guid? GoalResponsiblePersonId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? WorkspaceDashboardId { get; set; }
        public DateTimeOffset? DateFrom { get; set; }
        public DateTimeOffset? DateTo { get; set; }
        public bool? IsRed { get; set; }
        public bool? IsGoalsPage { get; set; }
        public Guid? EntityId { get; set; }
        public bool? IsWarning { get; set; }
        public bool? IsForUserStoryoverview { get; set; }
        public bool? IsActiveGoalsOnly { get; set; }
        public string TestSuiteId { get; set; }
        public string SectionId { get; set; }
        public string BugPriorityId { get; set; }

        public string BugPriorityIds { get; set; }
        public string UserStoryTypeIds { get; set; }
        public string ProjectIds { get; set; }
        public string GoalResponsiblePersonIds { get; set; }
        public string GoalStatusIds { get; set; }
        public string Tags { get; set; }

        public string BugPriorityIdsXml { get; set; }
        public string UserStoryStatusIdsXml { get; set; }
        public string UserStoryTypeIdsXml { get; set; }
        public string OwnerUserIdsXml { get; set; }
        public string GoalStatusIdsXml { get; set; }
        public string ProjectIdsXml { get; set; }
        public string GoalResponsiblePersonIdsXml { get; set; }

        public bool? IsToBeTracked { get; set; }
        public bool? IsTracked { get; set; }
        public bool? IsProductive { get; set; }
        public bool? IsProductiveBoard { get; set; }
        public bool? IsIncludeUnAssigned { get; set; }
        public bool? IsExcludeOtherUs { get; set; }

        public bool? IsUserStoryArchived { get; set; }
        public bool? IsGoalParked { get; set; }
        public bool? IsUserStoryParked { get; set; }
        public bool? IncludeArchive { get; set; }
        public bool? IncludePark { get; set; }
        public bool? IsMyWorkOnly { get; set; }
        public bool? IsMyWork { get; set; }
        public bool IsAction { get; set; }
        public string UserIdsXml { get; set; }
        public string UserIds { get; set; }

        public string ActionCategoryIdsXml { get; set; }
        public string ActionCategoryIds { get; set; }
        public string BranchIds { get; set; }
        public string BranchIdsXml { get; set; }
        public string TeamMemberIdsXml { get; set; }
        public string UserStoryTagsXml { get; set; }
        public string TeamMemberIds { get; set; }
        public string UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }
     
        public string DependencyText { get; set; }
        public DateTimeOffset? DeadLineDateFrom { get; set; }
        public DateTimeOffset? DeadLineDateTo { get; set; }
        public string UserStoryUniqueName { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public bool? IsSprintUserStories { get; set; }
        public bool? IsAutoLog { get; set; }
        public bool? IsSameUser { get; set; }
        public Guid? SprintId { get; set; }
        public string GoalName { get; set; }
        public string UserStoryTags { get; set; }
        public string GoalTags { get; set; }
        public bool? IsOnTrack { get; set; }
        public bool? IsNotOnTrack { get; set; }

        public string VersionName { get; set; }
        public bool? IsForFilters { get; set; }
        public string BugCausedUserIds { get; set; }
        public string DependencyUserIds { get; set; }
        public string ProjectFeatureIds { get; set; }
        public DateTime? CreatedDateFrom { get; set; }
        public DateTime? CreatedDateTo { get; set; }
        public DateTime? UpdatedDateFrom { get; set; }
        public DateTime? UpdatedDateTo { get; set; }
        public string BusinessUnitIds { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public List<WorkReportExcelInputModel> ExcelColumnList { get; set; }
    }
}
