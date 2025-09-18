using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class ReviewInvitationNotificationModel : NotificationBase
    {
        public Guid? UserId { get; }
        public ReviewInvitationNotificationModel(string summary, Guid? userId) : base(NotificationTypeConstants.ReviewInvitationNotification, summary)
        {
            UserId = userId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.ReviewInvitationNotificationModel, userId));
        }
    }
}