using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class UserStoryUpdateNotificationModel : NotificationBase
    {
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }

        public UserStoryUpdateNotificationModel(string summary,
            Guid ownerUserId,
            Guid? userStoryGuid,
            string userStoryName) : base(NotificationTypeConstants.UserStoryUpdateNotificationTypeId, summary)
        {
            UserStoryId = userStoryGuid;
            UserStoryName = userStoryName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.UserStoryUpdateNotification, ownerUserId));
        }
    }
}
