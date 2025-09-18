using System;

namespace Btrak.Models
{
    public class UserStoryWorkflowStatusTransitionModel
    {
        public int Id
        {
            get;
            set;
        }

        public Guid UserStoryId
        {
            get;
            set;
        }

        public Guid WorkFlowTransitionId
        {
            get;
            set;
        }

        public DateTime TransitionDateTime
        {
            get;
            set;
        }
    }
}
