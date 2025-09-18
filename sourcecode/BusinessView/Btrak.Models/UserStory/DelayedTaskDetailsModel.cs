using System;

namespace Btrak.Models.UserStory
{
    public class DelayedTaskDetailsModel
    {
        public Guid UserStoryId { get; set; }
        public Guid OwnerUserId { get; set; }
        public string UserStoryName { get; set; }
        public DateTime DeadLineDate { get; set; }
        public string OwnerUserName { get; set; }
        public string Email { get; set; }
        public string ProjectName { get; set; }
        public string GoalName { get; set; }
        public string ProjectResponsiblePersonName { get; set; }
        public string ProjectResponsiblePersonEmail { get; set; }
        public string SprintName { get; set; }
    }
}