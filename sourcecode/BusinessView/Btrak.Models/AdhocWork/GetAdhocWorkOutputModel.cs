using System;
using System.Text;

namespace Btrak.Models.AdhocWork
{
    public class GetAdhocWorkOutputModel
    {
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public Guid? OwnerUserId { get; set; }
        public string OwnerName { get; set; }
        public string OwnerProfileImage { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public DateTimeOffset? UserStoryParkedDateTime { get; set; }
        public int Order { get; set; }
        public int TotalCount { get; set; }
        public Guid? WorkFlowId { get; set; }
        public Byte[] TimeStamp { get; set; }
        public string Description { get; set; }
        public bool IsArchived { get; set; }
        public string UserStoryUniqueName { get; set; }
        public string GoalUniqueName { get; set; }
        public bool IsFillForm { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? FormId { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
        public Guid? TaskStatusId { get; set; }
        public Guid? WorkFlowTaskId { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public bool? IsLogTimeRequired { get; set; }
        public bool? IsQaRequired { get; set; }
        public string UserStoryTypeName { get; set; }
        public string Tag { get; set; }
        public string UserStoryTypeColor { get; set; }
        public bool? AutoLog { get; set; }
        public bool? IsAdhocUserStory { get; set; }
        public bool? IsEnableStartStop { get; set; }
        public bool? BreakType { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserStoryId = "+ UserStoryId);
            stringBuilder.Append(" UserStoryName = "+ UserStoryName);
            stringBuilder.Append(" EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(" OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(" OwnerName = " + OwnerName);
            stringBuilder.Append(" OwnerProfileImage = " + OwnerProfileImage);
            stringBuilder.Append(" UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(" UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(" UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(" ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(" UserStoryParkedDateTime = " + UserStoryParkedDateTime);
            stringBuilder.Append(" Order = " + Order);
            stringBuilder.Append(" TotalCount = " + TotalCount);
            stringBuilder.Append(" WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(" UserStoryUniqueName  = " + UserStoryUniqueName);
            stringBuilder.Append("GoalUniqueName = " + GoalUniqueName);
            stringBuilder.Append("TaskStatusId = " + TaskStatusId);
            stringBuilder.Append("IsFillForm = " + IsFillForm);
            stringBuilder.Append("CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append("GenericFormSubmittedId = " + GenericFormSubmittedId);
            stringBuilder.Append("Tag = " + Tag);
            stringBuilder.Append("UserStoryTypeId = " + UserStoryTypeId);
            return base.ToString();
        }
    }
}