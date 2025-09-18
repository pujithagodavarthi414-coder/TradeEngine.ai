using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class ArchiveUserStoryNotificationModel : NotificationBase
    {
        public Guid? UserStoryGuid { get; }
        public string UserStoryName { get; }
        public Guid? UserStoryOwnerId { get; }

        public ArchiveUserStoryNotificationModel(string summary,
            Guid? userStoryGuid,
            string userStoryName,Guid? userStoryOwnerId) : base(NotificationTypeConstants.UserStoryArchive, summary
        )
        {
            UserStoryGuid = userStoryGuid;
            UserStoryName = userStoryName;
            UserStoryOwnerId = userStoryOwnerId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.UserStoryArchive, UserStoryOwnerId));
        }
    }
}