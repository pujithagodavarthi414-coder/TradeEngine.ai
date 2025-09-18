using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class PerformanceReviewInvitationNotificationModel : NotificationBase
    {
        public Guid? UserId { get; }
        public PerformanceReviewInvitationNotificationModel(string summary, Guid? userId) : base(NotificationTypeConstants.PerformanceReviewInvitationNotificationModel, summary)
        {
            UserId = userId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.PerformanceReviewInvitationNotificationModel, userId));
        }
    }
}