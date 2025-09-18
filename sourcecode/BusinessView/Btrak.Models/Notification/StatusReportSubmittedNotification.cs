using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class StatusReportSubmittedNotification : NotificationBase
    {

        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? ReportId { get; }
        public string ReportName { get; }
        public string SubmittedBy { get; }

        public StatusReportSubmittedNotification(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid,
                                             Guid? reportId,
                                             string reportName,
                                             string submittedBy) : base(NotificationTypeConstants.NewStatusReportSumitted, summary)
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            ReportId = reportId;
            ReportName = reportName;
            SubmittedBy = submittedBy;

            Channels.Add(string.Format(NotificationChannelNamesConstants.StatusReportSubmitted, notificationAssignedToUserGuid));
        }
    }
}
