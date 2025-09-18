using System;
using System.Collections.Generic;

namespace Btrak.Models.UserStory
{
    public class GoalReplanHistoryOutputModel
    {
        public string RequestedBy { get; set; }
        public string GoalName { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public string SprintName { get; set; }
        public DateTimeOffset? DateOfReplan { get; set; }
        public string GoalMembers { get; set; }
        public string SprintMembers { get; set; }
        public string GoalReplanName { get; set; }
        public string SprintReplanName { get; set; }
        public Guid? ApprovedUserId { get; set; }
        public string ApprovedUser { get; set; }
        public int? GoalReplanCount { get; set; }
        public int? SprintReplanCount { get; set; }
        public int? MaxReplanCount { get; set; }
        public Guid? GoalReplanId { get; set; }
        public Guid? SprintReplanId { get; set; }
        public int? GoalDelay { get; set; }
        public int? SprintDelay { get; set; }
        public List<UserStoriesDescrption> UserStoriesDescrptions { get; set; }
    }

    public class UserStoriesDescrption
    {
        public string UserStoryName { get; set; }
        public string UserStoryUniqueName { get; set; }
        public int? UserStoryDelay { get; set; }
        public List<string> Description { get; set; }
    }
}