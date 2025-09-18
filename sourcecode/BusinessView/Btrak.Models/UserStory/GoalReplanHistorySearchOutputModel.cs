using System;

namespace Btrak.Models.UserStory
{
    public class GoalReplanHistorySearchOutputModel
    {
        public string GoalReplanName { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public string TimeZoneName { get; set; }
        public string UserStoryName { get; set; }
        public string ApprovedBy { get; set; }
        public string RequestedBy { get; set; }
        public string GoalName { get; set; }
        public string UserStoryReplanName { get; set; }
        public Guid? UserStoryId { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public DateTimeOffset? DateOfReplan { get; set; }
        public string GoalMembers { get; set; }
        public string Description { get; set; }
        public Guid? GoalReplanId { get; set; }
        public Guid? GoalId { get; set; }
        public int? UserStoryDelay { get; set; }
        public int? GoalReplanCount { get; set; }
        public int? MaxReplanCount { get; set; }
        public Guid? ApprovedUserId { get; set; }
        public string ApprovedUser { get; set; }
        public int? GoalDelay { get; set; }
        public string UserStoryUniqueName { get; set; }
        public string SprintName { get; set; }
        public string SprintMembers { get; set; }
        public string SprintReplanName { get; set; }
        public int? SprintReplanCount { get; set; }
        public Guid? SprintReplanId { get; set; }
        public int? SprintDelay { get; set; }
    }
}