using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowEligibleStatusTransitionInputModel : InputModelBase
    {
        public WorkFlowEligibleStatusTransitionInputModel() : base(InputTypeGuidConstants.WorkFlowEligibleStatusTransitionInputCommandTypeGuid)
        {
        }

        public Guid? WorkflowEligibleStatusTransitionId { get; set; }
        public Guid? WorkFlowId { get; set; }
        public Guid? FromWorkflowUserStoryStatusId { get; set; }
        public Guid? ToWorkflowUserStoryStatusId { get; set; }
        public Guid? TransitionDeadlineId { get; set; }
        public string DisplayName { get; set; }

        public Guid? ProjectId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? SprintId { get; set; }
        public Guid? UserId { get; set; }

        /* This fields is for isarchived */
        public bool IsAdd { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkFlowEligibleStatusTransitionId = " + WorkflowEligibleStatusTransitionId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", FromWorkFlowUserStoryStatusId = " + FromWorkflowUserStoryStatusId);
            stringBuilder.Append(", ToWorkFlowUserStoryStatusId = " + ToWorkflowUserStoryStatusId);
            stringBuilder.Append(", TransitionDeadlineId = " + TransitionDeadlineId);
            stringBuilder.Append(", DisplayName = " + DisplayName);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", IsAdd = " + IsAdd);
            return stringBuilder.ToString();
        }
    }
}