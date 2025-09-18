using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class ReOrderWorkflowStatusesInputModel : InputModelBase
    {
        public ReOrderWorkflowStatusesInputModel() : base(InputTypeGuidConstants.UserStoryInputCommandTypeGuid)
        {
        }

        public Guid? WorkflowId { get; set; }
        public List<Guid?> UserStoryStatusIds { get; set; }
        public string UserStoryStatusIdsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkflowId = " + WorkflowId);
            stringBuilder.Append("UserStoryStatusIds = " + UserStoryStatusIds);
            stringBuilder.Append("UserStoryStatusIdsXml = " + UserStoryStatusIdsXml);
            return stringBuilder.ToString();
        }
    }
}
