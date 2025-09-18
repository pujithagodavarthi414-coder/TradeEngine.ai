using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class ParkedUserStoryNotificationModel : NotificationBase
    {
        public Guid? UserStoryGuid { get; }
        public string UserStoryName { get; }
        public Guid? UserStoryOwnerId { get; }

        public ParkedUserStoryNotificationModel(string summary,
            Guid? userStoryGuid,
            string userStoryName, Guid? userStoryOwnerId) : base(NotificationTypeConstants.ParkUserStory, summary
        )
        {
            UserStoryGuid = userStoryGuid;
            UserStoryName = userStoryName;
            UserStoryOwnerId = userStoryOwnerId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.ParkUserStory, UserStoryOwnerId));
        }
    }
}
