using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WorkspaceInputModel : InputModelBase
    {
        public WorkspaceInputModel() : base(InputTypeGuidConstants.WorkspaceUpsertInputCommandTypeGuid)
        {
        }
        public Guid? WorkspaceId { get; set; }
        public string WorkspaceName { get; set; }
        public string Description { get; set; }
        public string SelectedRoleIds { get; set; }
        public string EditRoleIds { get; set; }
        public string DeleteRoleIds { get; set; }
        public string RoleIdsXml { get; set; }
        public bool IsHidden { get; set; }
        public bool? IsArchived { get; set; }
        public string IsCustomizedFor { get; set; }
        public bool IsFromExport { get; set; }
        public bool? IsListView { get; set; }
        public Guid? parentId { get; set; }
        public Guid? MenuItemId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkspaceId = " + WorkspaceId);
            stringBuilder.Append(", WorkspaceName = " + WorkspaceName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsHidden = " + IsHidden);
            stringBuilder.Append(", SelectedRoleIds = " + SelectedRoleIds);
            stringBuilder.Append(", EditRoleIds = " + EditRoleIds);
            stringBuilder.Append(", DeleteRoleIds = " + DeleteRoleIds);
            stringBuilder.Append(", RoleIdsXml = " + RoleIdsXml);
            return stringBuilder.ToString();
        }
    }
}
