using System;
using System.Collections.Generic;

namespace Btrak.Models.MyWork
{
    public class EmployeeWorkLogReportOutputmodel
    {
        public DateTimeOffset? Date { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? UserId { get; set; }
        public string DeveloperName { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public Guid? BoardTypeId { get; set; }
        public string BoardType { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public Guid? UserStoryStatus { get; set; }
        public string Status { get; set; }
        public decimal? OriginalEstimate { get; set; }
        public decimal? SpentToday { get; set; }
        public decimal? TotalSpentTimeSoFar { get; set; }
        public int? TotalCount { get; set; }
        public decimal? RemainingTime { get; set; }
        public string Comments { get; set; }
        public string UserStoryUniqueName { get; set; }
        public List<string> CommentsList { get; set; }
        public string LoggedUserName { get; set; }
        public Guid? LoggedUserId { get; set; }
        public string LoggedUserProfileImage { get; set; }
        public bool? IsUserStoryArchived { get; set; }
        public bool? IsGoalArchived { get; set; }
        public bool? IsProjectArchived { get; set; }
        public bool? IsFromSprint { get; set; }
        public bool? IsUserStoryParked { get; set; }
        public bool? IsGoalParked { get; set; }
        public bool? IsSprintDelete { get; set; }
        public string DeveloperImage { get; set; }

    }
}