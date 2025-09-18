using System;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowEligibleStatusTransitionSpReturnModel
    {
        public Guid? WorkflowEligibleStatusTransitionId { get; set; }

        public Guid? WorkflowId { get; set; }
        public string WorkflowName { get; set; }

        public Guid? FromWorkflowUserStoryStatusId { get; set; }
        public string FromWorkflowUserStoryStatus { get; set; }
        public string FromWorkflowUserStoryStatusColor { get; set; }

        public Guid? ToWorkflowUserStoryStatusId { get; set; }
        public string ToWorkflowUserStoryStatus { get; set; }
        public string ToWorkflowUserStoryStatusColor { get; set; }

        public Guid? TransitionDeadlineId { get; set; }
        public string DeadlineName { get; set; }

        public string DisplayName { get; set; }

        public string RoleIds { get; set; }
        public string RoleNames { get; set; }

        public bool WorkFlowIsArchived { get; set; }
        public bool IsArchived { get; set; }
        public Guid? CompanyId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

    }
}