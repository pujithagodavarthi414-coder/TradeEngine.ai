using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class NotificationModelForBugTypeUserStory : NotificationBase
    {
        public Guid? UserStoryGuid { get; }
        public string UserStoryName { get; }
        public Guid? UserStoryOwnerId { get; }

        public NotificationModelForBugTypeUserStory(string summary,
            Guid? userStoryGuid,
            string userStoryName, Guid? userStoryOwnerId) : base(NotificationTypeConstants.UserStoryTypeAsBug, summary
        )
        {
            UserStoryGuid = userStoryGuid;
            UserStoryName = userStoryName;
            UserStoryOwnerId = userStoryOwnerId;
            Channels.Add(string.Format(NotificationChannelNamesConstants.BugTypeUserStory, UserStoryOwnerId));
        }
    }
}
