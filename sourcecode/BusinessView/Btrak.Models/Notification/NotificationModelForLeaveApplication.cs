using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class NotificationModelForLeaveApplication : NotificationBase
    {
        public NotificationModelForLeaveApplication(string summary) : base(NotificationTypeConstants.LeaveNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.LeaveNotification));
        }
    }
}
