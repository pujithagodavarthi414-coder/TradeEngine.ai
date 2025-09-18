using System;

namespace Btrak.Models
{
    public class BusinessViewAddGoalMessageJsonResult
    {
        public Guid GoalId { get; set; }
        public string DisplayMessage { get; set; }
        public string GoalColor { get; set; }
        public string OldGoalColor { get; set; }
        public string UserStoryIds { get; set; }
        public Guid GuidId { get; set; }
    }
}
