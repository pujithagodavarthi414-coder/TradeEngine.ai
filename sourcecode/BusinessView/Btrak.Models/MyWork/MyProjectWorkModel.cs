using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MyWork
{
    public class MyProjectWorkModel : SearchCriteriaInputModelBase
    {
        public MyProjectWorkModel() : base(InputTypeGuidConstants.GetMyProjectsWork)
        {
        }
        public string TeamMemberId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public string ProjectName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public bool? IsFromAdoc { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public DateTimeOffset? ActualDeadLineDate { get; set; }
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public DateTime? ParkedDateTime { get; set; }
        public int? Order { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? GoalStatusId { get; set; }
        public string UserStoryStatusIds { get; set; }
        public string OwnerUserIds { get; set; }
        public bool? IsStatusMultiSelect { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? GoalResponsiblePersonId { get; set; }
        public Guid? BranchId { get; set; }
        public DateTimeOffset? DateFrom { get; set; }
        public DateTimeOffset? DateTo { get; set; }
        public bool? IsRed { get; set; }
        public bool? IsWarning { get; set; }
        public string BugPriorityId { get; set; }
     
        public string BugPriorityIds { get; set; }

        public string BugPriorityIdsXml { get; set; }
        public string UserStoryStatusIdsXml { get; set; }
        public string OwnerUserIdsXml { get; set; }

        public bool? IsToBeTracked { get; set; }
        public bool? IsProductiveBoard { get; set; }

        public bool? IsUserStoryArchived { get; set; }
        public bool? IsGoalParked { get; set; }
        public bool? IsUserStoryParked { get; set; }
        public bool? IncludeArchive { get; set; }
        public bool? IncludePark { get; set; }
        public bool? IsMyWorkOnly { get; set; }
        public bool? IsActiveGoalsOnly { get; set; }
        public bool? IsForUserStoryoverview { get; set; }
        public string DependencyText { get; set; }
        public DateTimeOffset? DeadLineDateFrom { get; set; }
        public DateTimeOffset? DeadLineDateTo { get; set; }
        public string TeamMemberIds { get; set; }
        public string TeamMemberIdsXml { get; set; }
        public string UserStoryIdsXml { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
        public string UserStoryUniqueName { get; set; }
        public Guid? ParentUserStoryId { get; set; }
    }
}