using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class SubmitTimeSheetNotification : NotificationBase
    {
        public Guid? NotificationAssignedByUserGuid { get; }
        public Guid? NotificationAssignedToUserGuid { get; }
        public string NotificationTitle { get; set; }
        public string NoficationHeader { get; set; }

        public SubmitTimeSheetNotification(string summary,
            Guid? notificationAssignedByUserGuid,
            Guid? notificationAssignedToUserGuid, string notificationTitle, string notificationHeader) : base(NotificationTypeConstants.SubmitTimeSheet, summary)
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            NotificationTitle = notificationTitle;
            NoficationHeader = notificationHeader;
            Channels.Add(string.Format(NotificationChannelNamesConstants.RosterDetails, notificationAssignedToUserGuid));
        }
    }

    public class SubmitTimesheetApproveNotification : NotificationBase
    {
        public Guid? NotificationAssignedByUserGuid { get; }
        public Guid? NotificationAssignedToUserGuid { get; }
        public string NotificationTitle { get; set; }
        public string NoficationHeader { get; set; }

        public SubmitTimesheetApproveNotification(string summary,
            Guid? notificationAssignedByUserGuid,
            Guid? notificationAssignedToUserGuid, string notificationTitle, string notificationHeader) : base(NotificationTypeConstants.TimesheetApproved, summary)
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            NotificationTitle = notificationTitle;
            NoficationHeader = notificationHeader;
            Channels.Add(string.Format(NotificationChannelNamesConstants.RosterDetails, notificationAssignedToUserGuid));
        }
    }

    public class SubmitTimesheetRejecteNotification : NotificationBase
    {
        public Guid? NotificationAssignedByUserGuid { get; }
        public Guid? NotificationAssignedToUserGuid { get; }
        public string NotificationTitle { get; set; }
        public string NoficationHeader { get; set; }

        public SubmitTimesheetRejecteNotification(string summary,
            Guid? notificationAssignedByUserGuid,
            Guid? notificationAssignedToUserGuid, string notificationTitle, string notificationHeader) : base(NotificationTypeConstants.TimesheetRejected, summary)
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            NotificationTitle = notificationTitle;
            NoficationHeader = notificationHeader;
            Channels.Add(string.Format(NotificationChannelNamesConstants.RosterDetails, notificationAssignedToUserGuid));
        }
    }
}
