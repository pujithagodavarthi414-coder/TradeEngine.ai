using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class PerformanceReviewSubmittedByEmployeeNotification : NotificationBase
    {
        public Guid? UserId { get; }
        public PerformanceReviewSubmittedByEmployeeNotification(string summary, Guid? userId) : base(NotificationTypeConstants.PerformanceReviewSubmittedByEmployeeNotification, summary)
        {
            UserId = userId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.PerformanceReviewSubmittedByEmployeeNotification, userId));
        }
    }
}