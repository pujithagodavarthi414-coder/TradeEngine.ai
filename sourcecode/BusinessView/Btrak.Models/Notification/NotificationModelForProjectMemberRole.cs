using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class NotificationModelForProjectMemberRole : NotificationBase
    {
        public string RoleGuid { get; }
        public string RoleName { get; }
        public Guid? ProjectGuid { get; }

        public NotificationModelForProjectMemberRole(string summary,
            string roleGuid,
            string roleName,Guid? projectId,Guid? projectMemberUserId) : base(NotificationTypeConstants.ProjectMemberRoleAdded, summary
        )
        {
            RoleGuid = roleGuid;
            RoleName = roleName;
            ProjectGuid = projectId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.ProjectMemberRole, projectMemberUserId));
        }
    }
}