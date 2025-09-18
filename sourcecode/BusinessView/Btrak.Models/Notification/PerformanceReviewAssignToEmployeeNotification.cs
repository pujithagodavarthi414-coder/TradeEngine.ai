using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class PerformanceReviewAssignToEmployeeNotification : NotificationBase
    {
        public PerformanceReviewAssignToEmployeeNotification(string summary) : base(NotificationTypeConstants.PerformanceReviewAssignToEmployeeNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.PerformanceReviewAssignToEmployeeNotification));
        }
    }
}