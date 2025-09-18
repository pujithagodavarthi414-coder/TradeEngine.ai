using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryReplanInputModel : InputModelBase
    {
        public UserStoryReplanInputModel() : base(InputTypeGuidConstants.UserStoryReplanUpsertInputCommandTypeGuid)
        {
        }
        public Guid? UserStoryReplanTypeId { get; set; }
        public Guid? UserStoryReplanId { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryReplanXML { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? SprintId { get; set; }
        public Guid? UserId { get; set; }
        public List<Guid?> UserStoryIds { get; set; }

        public decimal? EstimatedTime { get; set; }
        public decimal? SprintEstimatedTime { get; set; }
        public string UserStoryName { get; set; }
        public string TimeZone { get; set; }
        public DateTimeOffset? UserStoryDeadLine { get; set; }
        public DateTime? DeadLine { get; set; }
        public int TimeZoneOffset { get; set; }
        public Guid? UserStoryOwnerId { get; set; }
        public Guid? UserStoryDependencyId { get; set; }
        public Guid? GoalReplanId { get; set; }
        public bool? IsFromSprint { get; set; }
        public DateTimeOffset? UserStoryStartDate { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryReplanId = " + UserStoryReplanId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryReplanTypeId = " + UserStoryReplanTypeId);
            stringBuilder.Append(", UserStoryReplanXML = " + UserStoryReplanXML);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", UserStoryIds = " + UserStoryIds);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", UserStoryDeadLine = " + UserStoryDeadLine);
            stringBuilder.Append(", UserStoryOwnerId = " + UserStoryOwnerId);
            stringBuilder.Append(", UserStoryDependencyId = " + UserStoryDependencyId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalReplanTypeId = " + GoalReplanId);
            stringBuilder.Append(", UserStoryStartDate = " + UserStoryStartDate);
            return stringBuilder.ToString();
        }
    }

    public class UserStoryReplanChangedValues
    {
        public object OldValue { get; set; }
        public object NewValue { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? UserStoryReplanTypeId { get; set; }
    }
}