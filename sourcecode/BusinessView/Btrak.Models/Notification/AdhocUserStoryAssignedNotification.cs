using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class AdhocUserStoryAssignedNotification : NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? UserStoryGuid { get; }
        public string UserStoryName { get; }

        public AdhocUserStoryAssignedNotification(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid,
                                             Guid? userStoryGuid,
                                             string userStoryName) : base(NotificationTypeConstants.AdhocNewUserStoryAssigned, summary
            )
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            UserStoryGuid = userStoryGuid;
            UserStoryName = userStoryName;

            Channels.Add(string.Format(NotificationChannelNamesConstants.ChannelTaskAssignments, notificationAssignedToUserGuid));
        }
    }
}