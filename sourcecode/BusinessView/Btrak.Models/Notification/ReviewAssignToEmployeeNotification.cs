using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class ReviewAssignToEmployeeNotification : NotificationBase
    {
        public ReviewAssignToEmployeeNotification(string summary) : base(NotificationTypeConstants.ReviewAssignToEmployeeNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.ReviewAssignToEmployeeNotification));
        }
    }
}
