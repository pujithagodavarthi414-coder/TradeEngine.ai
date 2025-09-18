using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class NotificationModelForProbationAssign : NotificationBase
    {
        public Guid? UserId { get; }
        public string UserName { get; }

        public NotificationModelForProbationAssign(string summary,
            Guid? userId,
            string userName) : base(NotificationTypeConstants.ProbationAssignNotification, summary
        )
        {
            UserId = userId;
            UserName = userName;
            Channels.Add(string.Format(NotificationChannelNamesConstants.ProbationAssignNotification, userId, userName));
        }
    }
}
