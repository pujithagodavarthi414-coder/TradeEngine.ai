using System;

namespace Btrak.Models.Goals
{
    public class LeastPerformingGoalByResponsiblePerson
    {
        public DateTime AxisDates { get; set; }
        public int Standard { get; set; }
        public int Done { get; set; }
        public Guid GoalId { get; set; }
        public string GoalName { get; set; }
    }
}
