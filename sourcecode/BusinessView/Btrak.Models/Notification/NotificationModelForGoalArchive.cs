using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class NotificationModelForGoalArchive : NotificationBase
    {
        public Guid? GoalGuid { get; }
        public string GoalName { get; }

        public NotificationModelForGoalArchive(string summary,
            Guid? goalGuid, string goalName
            ) : base(NotificationTypeConstants.GoalReplan, summary
        )
        {
            GoalGuid = goalGuid;
            GoalName = goalName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.GoalArchive, GoalGuid));
        }
    }
}
