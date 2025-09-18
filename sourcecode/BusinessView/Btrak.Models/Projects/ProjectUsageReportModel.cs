using System;

namespace Btrak.Models.Projects
{
    public class ProjectUsageReportModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public DateTimeOffset? StartDate { get; set; }
        public DateTimeOffset? EndDate { get; set; }
        public string UserStoryName { get; set; }
        public decimal? UserStoryAllocatedHours { get; set; }
        public decimal? UserStoryUsedHours { get; set; }
        public decimal? UserStoryBalanceHours { get; set; }
        public decimal? GoalEstimatedHours { get; set; }
        public decimal? GoalAllocatedHours { get; set; }
        public decimal? GoalUsedHours { get; set; }
        public decimal? GoalNonAllocatedHours { get; set; }
        public decimal? ProjectAllocatedHours { get; set; }
        public decimal? ProjectUsedHours { get; set; }
        public decimal? ProjectNonAllocatedHours { get; set; }
        public decimal? GoalNonUsedHours { get; set; }
        public decimal? ProjectNonUsedHours { get; set; }
        public decimal? ProjectPendingHours { get; set; }
        public decimal? GoalPendingHours { get; set; }

        public decimal? GoalAllocatedHoursPercentage { get; set; }
        public decimal? GoalUsedHoursPercentage { get; set; }
        public decimal? GoalNonAllocatedHoursPercentage { get; set; }
        public decimal? GoalNonUsedHoursPercentage { get; set; }

        public decimal? ProjectAllocatedHoursPercentage { get; set; }
        public decimal? ProjectUsedHoursPercentage { get; set; }
        public decimal? ProjectNonAllocatedHoursPercentage { get; set; }
        public decimal? ProjectNonUsedHoursPercentage { get; set; }
    }
}
