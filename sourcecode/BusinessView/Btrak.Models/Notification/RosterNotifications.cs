using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class RosterNotifications : NotificationBase
    {
        public Guid? NotificationAssignedByUserGuid { get; }
        public Guid? NotificationAssignedToUserGuid { get; }
        public string NotificationTitle { get; set; }
        public string NoficationHeader { get; set; }

        public RosterNotifications(string summary,
            Guid? notificationAssignedByUserGuid, 
            Guid? notificationAssignedToUserGuid,string notificationTitle,string notificationHeader) : base(NotificationTypeConstants.RosterApproved, summary)
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            NotificationTitle = notificationTitle;
            NoficationHeader = notificationHeader;
            Channels.Add(string.Format(NotificationChannelNamesConstants.RosterDetails, notificationAssignedToUserGuid));
        }
    }
}
