using System;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowEligibleStatusTransitionApiReturnModel
    {
        public Guid? WorkflowEligibleStatusTransitionId { get; set; }

        public Guid? WorkFlowId { get; set; }
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

        public bool WorkFlowIsArchived { get; set; }
        public bool IsArchived { get; set; }
        public Guid? CompanyId { get; set; }
        public int? TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkFlowEligibleStatusTransitionId = " + WorkflowEligibleStatusTransitionId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", WorkflowName = " + WorkflowName);
            stringBuilder.Append(", FromWorkFlowUserStoryStatusId = " + FromWorkflowUserStoryStatusId);
            stringBuilder.Append(", FromWorkflowUserStoryStatus = " + FromWorkflowUserStoryStatus);
            stringBuilder.Append(", FromWorkflowUserStoryStatusColor = " + FromWorkflowUserStoryStatusColor);
            stringBuilder.Append(", ToWorkFlowUserStoryStatusId = " + ToWorkflowUserStoryStatusId);
            stringBuilder.Append(", ToWorkflowUserStoryStatus = " + ToWorkflowUserStoryStatus);
            stringBuilder.Append(", ToWorkflowUserStoryStatusColor = " + ToWorkflowUserStoryStatusColor);
            stringBuilder.Append(", TransitionDeadlineId = " + TransitionDeadlineId);
            stringBuilder.Append(", DeadlineName = " + DeadlineName);
            stringBuilder.Append(", DisplayName = " + DisplayName);
            stringBuilder.Append(", WorkFlowIsArchived = " + WorkFlowIsArchived);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
