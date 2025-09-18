using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class ReviewSubmittedByEmployeeNotification : NotificationBase
    {
        public Guid? UserId { get; }
        public ReviewSubmittedByEmployeeNotification(string summary, Guid? userId) : base(NotificationTypeConstants.ReviewSubmittedByEmployeeNotification, summary)
        {
            UserId = userId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.ReviewSubmittedByEmployeeNotification, userId));
        }
    }
}