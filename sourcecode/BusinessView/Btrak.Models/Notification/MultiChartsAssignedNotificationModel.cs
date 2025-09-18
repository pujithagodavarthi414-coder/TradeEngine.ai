using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class MultiChartsAssignedNotification : NotificationBase
    {
        public Guid? NotificationAssignedByUserGuid { get; }
        public Guid? NotificationAssignedToUserGuid { get; }
        public Guid? CronExpressionId { get; }
        public string CronExpressionName { get; }

        public MultiChartsAssignedNotification(string summary,
                                             Guid? notificationAssignedByUserGuid,
                                             Guid? notificationAssignedToUserGuid,
                                             Guid? CronExpressionId,
                                             string CronExpressionName) : base(NotificationTypeConstants.NewMultiChartsScheduling, summary
            )
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            CronExpressionId = CronExpressionId;
            CronExpressionName = CronExpressionName;

            Channels.Add(string.Format(NotificationChannelNamesConstants.MultiChartsScheduling, notificationAssignedToUserGuid));
        }
    }
}