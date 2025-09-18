using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class NotificationModelForResignationApproval : NotificationBase
    {
        public NotificationModelForResignationApproval(string summary) : base(NotificationTypeConstants.ResignationApprovalNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.ResignationApprovalNotification));
        }
    }
}

