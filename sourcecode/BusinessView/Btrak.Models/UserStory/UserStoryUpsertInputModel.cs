using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStoryUpsertInputModel : InputModelBase
    {
        public UserStoryUpsertInputModel() : base(InputTypeGuidConstants.UserStoryUpsertInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }

        public Guid? ActionCategoryId { get; set; }
        public Guid? UnLinkActionId { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public string TimeZone { get; set; }

        public List<Guid?> MultipleUserStoryIds { get; set; }
        public string[] MultipleUserStoryName { get; set; }

        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }

        public Guid? OwnerUserId { get; set; }
        public Guid? OldOwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }

        public int? Order { get; set; }

        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }

        public DateTimeOffset? ParkedDateTime { get; set; }

        public Guid? BugPriorityId { get; set; }
        public Guid? BugCausedUserId { get; set; }
        public Guid? TestSuiteSectionId { get; set; }
        public Guid? TestCaseId { get; set; }

        public Guid? UserStoryStatusId { get; set; }

        public Guid? UserStoryTypeId { get; set; }
        public Guid? ProjectFeatureId { get; set; }

        public Guid? UserStoryPriorityId { get; set; }
        public Guid? ReviewerUserId { get; set; }
        public Guid? ParentUserStoryId { get; set; }

        public string Description { get; set; }
        public bool IsForQa { get; set; }
        public string VersionName { get; set; }
        public string Tag { get; set; }

        public bool? IsReplan { get; set; }
        public Guid? GoalReplanId { get; set; }

        /* For mobile */
        public Guid? ProjectId { get; set; }
        public string UserStoryStatusName { get; set; }
        public Guid? TemplateId { get; set; }
        public string FormName { get; set; }
        public bool? IsFromTemplate { get; set; }
        public Guid? SprintId { get; set; }
        public bool? IsFromSprint { get; set; }
        public bool? IsFromBug { get; set; }
        public decimal? SprintEstimatedTime { get; set; }
        public string RAGStatus { get; set; }

        //For cron expression
        public string CronExpression { get; set; }
        public Guid? CronExpressionId { get; set; }
        public string CronExpressionDescription { get; set; }
        public Guid? AuditConductQuestionId { get; set; }
        public byte[] CronExpressionTimeStamp { get; set; }
        public int JobId { get; set; }
        public bool? IsRecurringWorkItem { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public bool? IsPaused { get; set; }
        public bool?  IsFromBugs { get; set; }
        public bool? IsAction { get; set; }
        public string UserStoryUniqueName { get; set; }
        public int TimeZoneOffset { get; set; }
        public Guid? AuditProjectId { get; set; }
        public DateTimeOffset? UserStoryStartDate { get; set; }

        public DateTime? DeadLine { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", MultipleUserStoryIds = " + MultipleUserStoryIds);
            stringBuilder.Append(", MultipleUserStoryName = " + MultipleUserStoryName);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", OldOwnerUserId = " + OldOwnerUserId);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", IsRePlan = " + IsReplan);
            stringBuilder.Append(", GoalRePlanTypeId = " + GoalReplanId);
            stringBuilder.Append(", TestCaseId = " + TestCaseId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", ParkedDateTime = " + ParkedDateTime);
            stringBuilder.Append(", BugPriorityId = " + BugPriorityId);
            stringBuilder.Append(", BugCausedUserId = " + BugCausedUserId);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", UserStoryTypeId = " + UserStoryTypeId);
            stringBuilder.Append(", ProjectFeatureId = " + ProjectFeatureId);
            stringBuilder.Append(", UserStoryPriorityId = " + UserStoryPriorityId);
            stringBuilder.Append(", ReviewerUserId = " + ReviewerUserId);
            stringBuilder.Append(", ParentUserStoryId = " + ParentUserStoryId);
            stringBuilder.Append(", TestSuiteSectionId = " + TestSuiteSectionId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsForQa = " + IsForQa);
            stringBuilder.Append(", TemplateId = " + TemplateId);
            stringBuilder.Append(", VersionName = " + VersionName);
            stringBuilder.Append(", SprintId = " + SprintId);
            stringBuilder.Append(", AuditConductQuestionId = " + AuditConductQuestionId);
            stringBuilder.Append(", IsFromSprint = " + IsFromSprint);
            stringBuilder.Append(", AuditProjectId = " + AuditProjectId);
            stringBuilder.Append(", StartDate = " + UserStoryStartDate);

            return stringBuilder.ToString();
        }
    }
}
