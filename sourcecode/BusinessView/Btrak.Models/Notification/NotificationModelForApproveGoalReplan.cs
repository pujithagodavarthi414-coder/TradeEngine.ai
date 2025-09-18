using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class NotificationModelForApproveGoalReplan : NotificationBase
    {
        public Guid? GoalGuid { get; }
        public string GoalName { get; }

        public NotificationModelForApproveGoalReplan(string summary,
            Guid? goalGuid,
            string goalName,
            Guid? goalResponsiblePersonId) : base(NotificationTypeConstants.GoalApprovedFromReplan, summary
        )
        {
            GoalGuid = goalGuid;
            GoalName = goalName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.GoalApprovedFromReplan, goalResponsiblePersonId));
        }
    }
}
