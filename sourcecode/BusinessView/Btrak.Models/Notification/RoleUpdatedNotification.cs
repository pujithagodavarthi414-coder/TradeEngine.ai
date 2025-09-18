using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class RoleUpdatedNotification : NotificationBase
    {
        public Guid RoleGuid { get; }
        public string RoleName { get; }

        public RoleUpdatedNotification(string summary,
                                             Guid roleGuid,
                                             string roleName) : base(NotificationTypeConstants.RoleUpdated, summary
            )
        {
            RoleGuid = roleGuid;
            RoleName = roleName;
            RoleName = roleName;

            Channels.Add(string.Format(NotificationChannelNamesConstants.RoleUpdates, roleGuid));
        }
    }
}