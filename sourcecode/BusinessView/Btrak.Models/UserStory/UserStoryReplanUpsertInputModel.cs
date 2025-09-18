using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryReplanUpsertInputModel : InputModelBase
    {
        public UserStoryReplanUpsertInputModel() : base(InputTypeGuidConstants.UserStoryReplanUpsertInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryReplanId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? UserStoryReplanTypeId { get; set; }
        public string UserStoryReplanJson { get; set; }

        public decimal? EstimatedTime { get; set; }
        public string UserStoryName { get; set; }
        public DateTime? UserStoryDeadLine { get; set; }
        public Guid? UserStoryOwnerId { get; set; }
        public Guid? UserStoryDependencyId { get; set; }
        public bool? IsFromSprint { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryReplanId = " + UserStoryReplanId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryReplanTypeId = " + UserStoryReplanTypeId);
            stringBuilder.Append(", UserStoryReplanJson = " + UserStoryReplanJson);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", UserStoryDeadLine = " + UserStoryDeadLine);
            stringBuilder.Append(", UserStoryOwnerId = " + UserStoryOwnerId);
            stringBuilder.Append(", UserStoryDependencyId = " + UserStoryDependencyId);
            return stringBuilder.ToString();
        }
    }

    public class UserStoryReplanChangeDeadLine
    {
        public Guid? UserStoryId { get; set; }
        public DateTimeOffset? OldDeadLine { get; set; }
        public DateTimeOffset? NewDeadLine { get; set; }
    }

    public class UserStoryReplanChangeEstimatedTime
    {
        public Guid? UserStoryId { get; set; }
        public decimal? OldEstimatedTime { get; set; }
        public decimal? NewEstimatedTime { get; set; }
    }

    public class UserStoryReplanChangeUserStory
    {
        public Guid? UserStoryId { get; set; }
        public string OldUserStory { get; set; }
        public string NewUserStory { get; set; }
    }

    public class UserStoryReplanChangeOwner
    {
        public Guid? UserStoryId { get; set; }
        public Guid? ExistedOwner { get; set; }
        public Guid? NewOwner { get; set; }
    }

    public class UserStoryReplanChangeDependency
    {
        public Guid? UserStoryId { get; set; }
        public Guid? ExistedDependency { get; set; }
        public Guid? NewDependency { get; set; }
    }
}
