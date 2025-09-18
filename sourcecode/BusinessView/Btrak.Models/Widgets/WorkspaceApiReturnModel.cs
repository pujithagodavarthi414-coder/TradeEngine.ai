using System;
using System.Text;

namespace Btrak.Models.Widgets
{
    public class WorkspaceApiReturnModel
    {
        public Guid? WorkspaceId { get; set; }

        public string WorkspaceName { get; set; }

        public string Description { get; set; }

        public string RoleIds { get; set; }

        public string EditRoleIds { get; set; }

        public string DeleteRoleIds { get; set; }

        public string DefaultDashboardRoleIds { get; set; }

        public string IsCustomizedFor { get; set; }

        public bool IsHidden { get; set; }

        public bool IsEditable { get; set; }

        public bool CanView { get; set; }

        public bool CanEdit { get; set; }

        public bool CanDelete { get; set; }

        public bool IsDefault { get; set; }

        public string RoleNames { get; set; }

        public string EditRoleNames { get; set; }

        public string DeleteRoleNames { get; set; }

        public string DefaultDashboardRolesNames { get; set; }

        public bool IsArchived { get; set; }

        public bool IsAppsInDraft { get; set; }

        public byte[] TimeStamp { get; set; }
        public bool? IsListView { get; set; }

        public Guid? ParentId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("WorkspaceId = " + WorkspaceId);
            stringBuilder.Append(", WorkspaceName = " + WorkspaceName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", IsEditable = " + IsEditable);
            stringBuilder.Append(", IsHidden = " + IsHidden);
            stringBuilder.Append(", CanView = " + CanView);
            stringBuilder.Append(", CanEdit = " + CanEdit);
            stringBuilder.Append(", CanDelete = " + CanDelete);
            stringBuilder.Append(", IsDefault = " + IsDefault);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", RoleNames = " + RoleNames);
            stringBuilder.Append(", EditRoleNames = " + EditRoleNames);
            stringBuilder.Append(", DeleteRoleNames = " + DeleteRoleNames);
            stringBuilder.Append(", DefaultDashboardRolesNames = " + DefaultDashboardRolesNames);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", ParentId = " + ParentId);
            return stringBuilder.ToString();
        }
    }
}
