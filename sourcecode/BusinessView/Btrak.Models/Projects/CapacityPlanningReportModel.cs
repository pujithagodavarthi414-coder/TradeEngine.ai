using System;

namespace Btrak.Models.Projects
{
    public class CapacityPlanningReportModel
    {
        public Guid ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid GoalId { get; set; }
        public string GoalName { get; set; }
        public decimal? ActualHours { get; set; }
        public decimal? UsedHours { get; set; }
        public decimal? FutureHours { get; set; }
        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}
