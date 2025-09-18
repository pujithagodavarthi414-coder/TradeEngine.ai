using System;

namespace Btrak.Models.Dashboard
{
    public class ProcessDashboardSpReturnModel
    {
        public Guid? ProcessDashboardId { get; set; }
        public Guid? GoalId { get; set; }
        public DateTimeOffset? MileStone { get; set; }
        public int? Delay { get; set; }
        public int? DashboardId { get; set; }
        public DateTimeOffset? GeneratedDateTime { get; set; }
        public string GoalStatusColor { get; set; }
        public Guid? ProcessDashBoardCreatedByUserId { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }
        public string GoalName { get; set; }
        public DateTimeOffset? OnboardProcessDate { get; set; }
        public string OnboardProcessedOn { get; set; }
        public string GoalStatusName { get; set; }
        public string MileStoneDate { get; set; }
        public string DelayColor { get; set; }

        public string Members { get; set; }
        public decimal Deviation { get; set; }
    }
}
