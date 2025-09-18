using BTrak.Common;
using BTrak.Common.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Notification
{
    public class PerformanceNotificationModel: NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? PerformanceId { get; }
        public string ApprovedByUser { get; }
        public Guid? ApprovedBy { get; }
        public PerformanceNotificationModel(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid,
                                             Guid? performanceId,
                                             string approvedByUser,
                                             Guid? approvedBy) : base(NotificationTypeConstants.PerformanceNotificationTypeId, summary
            )
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            PerformanceId = performanceId;
            ApprovedByUser = ApprovedByUser;
            Channels.Add(string.Format(NotificationChannelNamesConstants.PerformanceNotification, notificationAssignedToUserGuid));
        }

    }
}
