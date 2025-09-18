using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class NotificationModelForGoalReplan : NotificationBase
    {
        public Guid? GoalGuid { get; }
        public string GoalName { get; }

        public NotificationModelForGoalReplan(string summary,
            Guid? GoalResponsibleGuid,
            string goalName,
            Guid? goalGuid) : base(NotificationTypeConstants.GoalReplan, summary
        )
        {
            GoalGuid = goalGuid;
            GoalName = goalName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.GoalReplan, GoalResponsibleGuid));
        }
    }
}
