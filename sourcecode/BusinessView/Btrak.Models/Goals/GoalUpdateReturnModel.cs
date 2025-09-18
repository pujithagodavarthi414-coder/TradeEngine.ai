using System;

namespace Btrak.Models.Goals
{
    public class GoalUpdateReturnModel
    {
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public string GoalOldStatusColor { get; set; }
        public string GoalNewStatusColor { get; set; }
    }
}
