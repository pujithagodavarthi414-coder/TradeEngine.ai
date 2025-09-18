using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WorkspaceSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public WorkspaceSearchCriteriaInputModel() : base(InputTypeGuidConstants.WorkspaceSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? WorkspaceId { get; set; }

        public bool? IsHidden { get; set; }

        public string WorkspaceName { get; set; }
        public Guid? MenuItemId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkspaceId = " + WorkspaceId);
            stringBuilder.Append("IsHidden = " + IsHidden);
            stringBuilder.Append("WorkspaceName = " + WorkspaceName);
            return stringBuilder.ToString();
        }
    }
}
