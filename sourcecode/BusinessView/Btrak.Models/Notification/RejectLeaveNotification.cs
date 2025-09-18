using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class RejectLeaveNotification : NotificationBase
    {
        public RejectLeaveNotification(string summary) : base(NotificationTypeConstants.RejectLeaveNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.RejectLeaveNotification));
        }
    }
}
