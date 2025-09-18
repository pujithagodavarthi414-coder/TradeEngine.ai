using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class ConfigureStatusReportNotification : NotificationBase
    {

        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? ReportConfigurationId { get; }
        public string ReportName { get; }

        public ConfigureStatusReportNotification(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid,
                                             Guid? reportConfigurationId,
                                             string reportName) : base(NotificationTypeConstants.NewStatusConfigurationAssigned, summary)
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            ReportConfigurationId = reportConfigurationId;
            ReportName = reportName;

            Channels.Add(string.Format(NotificationChannelNamesConstants.StatusConfigurationAssignments, notificationAssignedToUserGuid));
        }
    }
}
