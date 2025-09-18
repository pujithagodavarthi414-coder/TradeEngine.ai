using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class NotificationModelForUserStoryComment : NotificationBase
    {
        public Guid? UserStoryGuid { get; }
        public string OwnerName { get; }
        public Guid? UserStoryOwnerId { get; }

        public NotificationModelForUserStoryComment(string summary,
            Guid? userStoryGuid,
            string userStoryName, Guid? userStoryOwnerId) : base(NotificationTypeConstants.PushNotificationForUserStoryComment, summary
        )
        {
            UserStoryGuid = userStoryGuid;
            OwnerName = userStoryName;
            UserStoryOwnerId = userStoryOwnerId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.UserStoryCommentNotification, UserStoryOwnerId));
        }
    }
}