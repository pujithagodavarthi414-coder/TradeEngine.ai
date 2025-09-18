using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class NotificationModelForResignationRejection : NotificationBase
    {
        public NotificationModelForResignationRejection(string summary) : base(NotificationTypeConstants.ResignationRejectionNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.ResignationRejectionNotification));
        }
    }
}

