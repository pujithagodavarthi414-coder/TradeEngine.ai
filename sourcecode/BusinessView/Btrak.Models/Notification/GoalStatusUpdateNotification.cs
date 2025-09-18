using System;
using BTrak.Common;
using BTrak.Common.Constants;

namespace Btrak.Models.Notification
{
    public class GoalStatusUpdateNotification : NotificationBase
    {
        public Guid NotificationAssignedByUserGuid { get; }
        public Guid? GoalGuid { get; }
        public string GoalName { get; }
        public string OldColor { get; }
        public string NewColor { get; }

        public GoalStatusUpdateNotification(string summary,
                                             Guid notificationAssignedByUserGuid,
                                             Guid? goalGuid,
                                             string goalName,
                                             string oldColor,
                                             string newColor) : base(NotificationTypeConstants.GoalStatusUpdated, summary
            )                                
        {
            NotificationAssignedByUserGuid = notificationAssignedByUserGuid;
            GoalGuid = goalGuid;
            GoalName = goalName;
            OldColor = oldColor;
            NewColor = newColor;

            Channels.Add(string.Format(NotificationChannelNamesConstants.GoalStatusUpdate));
        }
    }
}