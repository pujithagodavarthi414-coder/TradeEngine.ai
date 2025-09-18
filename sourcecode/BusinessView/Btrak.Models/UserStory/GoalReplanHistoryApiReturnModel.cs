using System;

namespace Btrak.Models.UserStory
{
    public class GoalReplanHistoryApiReturnModel
    {
        public Guid GoalReplanId { get; set; }
        public Guid UserStoryReplanId { get; set; }

        public Guid GoalId { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }

        public Guid GoalReplanTypeId { get; set; }
        public string GoalReplanTypeName { get; set; }

        public string Reason { get; set; }

        public Guid UserStoryReplanTypeId { get; set; }
        public string UserStoryReplanTypeName { get; set; }

        public Guid UserStoryId { get; set; }
        public string UserStoryName { get; set; }
       
        public decimal? OldEstimatedTime { get; set; }
        public decimal? NewEstimatedTime { get; set; }

        public DateTimeOffset? UserStoryOldDeadLine { get; set; }
        public DateTimeOffset? UserStoryNewDeadLine { get; set; }

        public Guid? UserStoryExistedOwner { get; set; }
        public string ExistedOwnerFullName { get; set; }
        public string ExistedOwnerProfileImage { get; set; }

        public Guid? UserStoryNewOwner { get; set; }
        public string NewOwnerFullName { get; set; }
        public string NewOwnerProfileImage { get; set; }

        public Guid? UserStoryExistedDependency { get; set; }
        public string ExistedDependencyFullName { get; set; }
        public string ExistedDependencyProfileImage { get; set; }

        public Guid? UserStoryNewDependency { get; set; }
        public string NewDependencyFullName { get; set; }
        public string NewDependencyProfileImage { get; set; }

        public string OldUserStory { get; set; }
        public string NewUserStory { get; set; }

        public int UserStoryDeadLineInDays { get; set; }
        public int GoalDeadLineInDays { get; set; }

        public DateTimeOffset? UserStoryDeadLineDate { get; set; }
        public DateTimeOffset? GoalDeadLineDate { get; set; }

        public DateTimeOffset? GoalReplanCreatedDateTime { get; set; }
        public Guid? GoalReplanCreatedByUserId { get; set; }

        public DateTimeOffset? GoalReplanUpdatedDateTime { get; set; }
        public Guid? GoalReplanUpdatedByUserId { get; set; }

        public Guid SprintId { get; set; }
        public string SprintName { get; set; }
    }
}
