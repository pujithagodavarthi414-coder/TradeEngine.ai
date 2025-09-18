using System;

namespace Btrak.Models.Goals
{
    public class GoalActivityWithUserStoriesOutputModel
    {
        public Guid? UserStoryOrSprintId { get; set; }
        public string UserStoryOrSprintName { get; set; }
        public Guid? UserStoryOrGoalId { get; set; }
        public string UserStoryOrGoalName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string FieldName { get; set; }
        public string Description { get; set; }
        public string KeyValue { get; set; }
        public string UserName { get; set; }
        public string UniqueName { get; set; }
        public string ProfileImage { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsGoal { get; set; }
        public bool? ConsiderEstimatedHours { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? UserStoryOrGoalIdOrSprintId {get;set;}
        public string UserStoryOrGoalNameOrSprintName { get; set; }
        public string GoalNameOrSprintNameOrTestSuiteName { get; set; }
        public bool? IsSprintOrGoal { get; set; }
        public string GoalName { get; set; }
        public string SprintName { get; set; }
        public string TemplateName { get; set; }
        public string TestSuiteName { get; set; }
        public string TestRunName { get; set; }
        public int TotalCount { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public string TimeZoneName { get; set; }
    }
}



