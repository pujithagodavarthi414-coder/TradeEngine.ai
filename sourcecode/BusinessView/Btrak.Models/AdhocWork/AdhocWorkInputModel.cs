using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.AdhocWork
{
    public class AdhocWorkInputModel : InputModelBase
    {
        public AdhocWorkInputModel() : base(InputTypeGuidConstants.AdhocWorkInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public int? Order { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public DateTimeOffset? ActualDeadLineDate { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsWorkflowStatus { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public DateTime? ParkedDateTime { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public Guid? UserStoryPriorityId { get; set; }
        public Guid? ReviewerUserId { get; set; }
        public Guid? ParentUserStoryId { get; set; }
        public string Description { get; set; }
        public string TimeZone { get; set; }
        public string CompanyName { get; set; }
        public bool? IsInductionGoal { get; set; }
        public bool? IsExitGoal { get; set; }
        
        public Guid? WorkFlowId { get; set; }
        public Guid? WorkFlowTaskId { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
        public Guid? WorkspaceDashboardId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? FormId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public string FileIds { get; set; }
        public int TimeZoneOffset { get; set; }
        public bool? IsFromInduction { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", ParkedDateTime = " + ParkedDateTime);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", UserStoryTypeId = " + UserStoryTypeId);
            stringBuilder.Append(", ProjectFeatureId = " + ProjectFeatureId);
            stringBuilder.Append(", UserStoryPriorityId = " + UserStoryPriorityId);
            stringBuilder.Append(", ReviewerUserId = " + ReviewerUserId);
            stringBuilder.Append(", ParentUserStoryId = " + ParentUserStoryId);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", GenericFormSubmittedId = " + GenericFormSubmittedId);
            stringBuilder.Append(", CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append(", FormId = " + FormId);
            stringBuilder.Append(", TimeZoneOffset = " + TimeZoneOffset);

            return stringBuilder.ToString();
        }
    }
}
