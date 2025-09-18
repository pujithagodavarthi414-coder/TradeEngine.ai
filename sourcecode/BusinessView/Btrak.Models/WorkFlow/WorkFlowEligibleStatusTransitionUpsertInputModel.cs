using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.WorkFlow
{
    public class WorkFlowEligibleStatusTransitionUpsertInputModel : InputModelBase
    {
        public WorkFlowEligibleStatusTransitionUpsertInputModel() : base(InputTypeGuidConstants.WorkFlowEligibleStatusTransitionUpsertInputCommandTypeGuid)
        {
        }

        public Guid? WorkflowEligibleStatusTransitionId { get; set; }
        public Guid? WorkFlowId { get; set; }
        public Guid? FromWorkflowUserStoryStatusId { get; set; }
        public Guid? ToWorkflowUserStoryStatusId { get; set; }
        public Guid? TransitionDeadlineId { get; set; }
        public string DisplayName { get; set; }
        public string RoleIdXml { get; set; }
        public List<Guid> RoleGuids { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkFlowEligibleStatusTransitionId = " + WorkflowEligibleStatusTransitionId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", FromWorkFlowUserStoryStatusId = " + FromWorkflowUserStoryStatusId);
            stringBuilder.Append(", ToWorkFlowUserStoryStatusId = " + ToWorkflowUserStoryStatusId);
            stringBuilder.Append(", TransitionDeadlineId = " + TransitionDeadlineId);
            stringBuilder.Append(", DisplayName = " + DisplayName);
            stringBuilder.Append(", RoleGuids = " + RoleGuids);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
