using BTrak.Common;
using System;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class UserStoryStatusChangeNotificationModel : NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid NotificationAssignedToUserGuid { get; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        
        public UserStoryStatusChangeNotificationModel(string summary, Guid notificationAssignedByUserGuid,
        Guid notificationAssignedToUserGuid,
            Guid? userStoryGuid,
        string userStoryName) : base(NotificationTypeConstants.UserStoryStatusChange, summary)
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            NotificationAssignedToUserGuid = notificationAssignedToUserGuid;
            UserStoryId = userStoryGuid;
            UserStoryName = userStoryName;

            Channels.Add(string.Format(NotificationChannelNamesConstants.UserStoryStatusTransition, notificationAssignedToUserGuid));
        }
    }
}