using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class GenericActivityNotification : NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }

        public GenericActivityNotification(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid)
            : base(NotificationTypeConstants.GenericNotificationActivity, summary
            )
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;

            Channels.Add(string.Format(NotificationChannelNamesConstants.GenericNotificationActivity, notificationAssignedToUserGuid));
        }
    }
}