using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class AdhocUserStoryUpdateNotificationModel : NotificationBase
    {
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }

        public AdhocUserStoryUpdateNotificationModel(string summary,
            Guid ownerUserId,
            Guid? userStoryGuid,
            string userStoryName) : base(NotificationTypeConstants.AdhocUserStoryUpdateNotificationTypeId, summary)
        {
            UserStoryId = userStoryGuid;
            UserStoryName = userStoryName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.UserStoryUpdateNotification, ownerUserId));
        }
    }
}
