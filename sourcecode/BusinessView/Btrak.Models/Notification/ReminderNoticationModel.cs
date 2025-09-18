using BTrak.Common;
using BTrak.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Notification
{
    public class ReminderNoticationModel : NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? ReminderId { get; }
        public ReminderNoticationModel(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid,
                                             Guid? reminderId) : base(NotificationTypeConstants.ReminderNotificationTypeId, summary
            )
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            ReminderId = reminderId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.ReminderNotification, notificationAssignedToUserGuid));
        }
    }
}
