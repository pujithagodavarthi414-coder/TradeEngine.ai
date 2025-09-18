using System;
using System.Collections.Generic;

namespace Btrak.Models.MyWork
{
    public class UserHistoricalWorkReportOutputModel
    {
        public string Developer { get; set; }
        public Guid? UserId { get; set; }
        public int? ProjectsCount { get; set; }
        public decimal? LoggedHours { get; set; }
        public decimal Productivity { get; set; }
        public int? VerifiedUserStories { get; set; }
        public int? BouncedBackUserStories { get; set; }
        public string ReportTo { get; set; }
        public List<object> BouncedBackCount { get; set; }
        public List<object> StatusHexValue { get; set; }
        public List<object> ProjectName { get; set; }
        public List<object> GoalName { get; set; }
        public List<object> UserStoryUniqueName { get; set; }
        public List<object> UserStoryName { get; set; }
        public List<object> DeadLineDate { get; set; }
        public List<object> LatestDeployedDate { get; set; }
        public List<object> ApprovedDate { get; set; }
        public List<object> CurrentStatus { get; set; }
        public List<object> EstimatedTime { get; set; }
        public List<object> SpentTime { get; set; }
        public List<object> ProjectId { get; set; }
        public List<object> GoalId { get; set; }
        public List<object> UserStoryId { get; set; }
        public DateTimeOffset? JoinedDate { get; set; }
    }
}