using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class UserStoryAssignedNotification : NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? UserStoryGuid { get; }
        public string UserStoryName { get; }

        public UserStoryAssignedNotification(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid notificationAssignedToUserGuid,
                                             Guid? userStoryGuid,
                                             string userStoryName) : base(NotificationTypeConstants.NewUserStoryAssigned, summary
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