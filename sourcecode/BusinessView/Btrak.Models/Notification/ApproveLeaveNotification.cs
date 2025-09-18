using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class ApproveLeaveNotification : NotificationBase
    {
        public ApproveLeaveNotification(string summary) : base(NotificationTypeConstants.ApproveLeaveNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.ApproveLeaveNotification));
        }
    }
}
