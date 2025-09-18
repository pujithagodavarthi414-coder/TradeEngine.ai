using System;
using System.Collections.Generic;

namespace Btrak.Models.GenericForm
{
   public class UserTasksModel
    {
        public string Id { get; set; }

        public string Name { get; set; }

        public string Assignee { get; set; }

        public string Owner { get; set; }

        public string UserRole { get; set; }

        public DateTime? Created { get; set; }

        public DateTime? Due { get; set; }

        public DateTime? FollowUp { get; set; }

        public string Description { get; set; }

        public string Priority { get; set; }

        public string FormKey { get; set; }

        public string ProcessInstanceId { get; set; }

        public string ProcessDefinitionId { get; set; }

        public string TaskDefinitionKey { get; set; }
        public Dictionary<string, object> TaskVariables { get; set; }
    }
}
