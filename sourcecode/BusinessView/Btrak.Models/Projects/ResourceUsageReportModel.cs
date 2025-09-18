using System;

namespace Btrak.Models.Projects
{
    public class ResourceUsageReportModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string ProjectName { get; set; }
        public string GoalName { get; set; }
        public string UserStoryName { get; set; }
        public decimal? UserStoryAllocatedHours { get; set; }
        public decimal? UserStoryUsedHours { get; set; }
        public decimal? UserStoryBalanceHours { get; set; }
        public decimal? GoalAllocatedHours { get; set; }
        public decimal? GoalUsedHours { get; set; }
        public decimal? GoalBalanceHours { get; set; }
        public decimal? ProjectAllocatedHours { get; set; }
        public decimal? ProjectUsedHours { get; set; }
        public decimal? ProjectBalanceHours { get; set; }
        public decimal? UtilizationPercentage { get; set; }
        public decimal? NoOfHours { get; set; }
        public decimal? ResourceAvailable { get; set; }
    }
}
