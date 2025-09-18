using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class NotificationModelForAutoTimeSheetSubmission : NotificationBase
    {
        public NotificationModelForAutoTimeSheetSubmission(string summary) : base(NotificationTypeConstants.AutoTimeSheetSubmissionNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.AutoTimeSheetSubmissionNotification));
        }
    }
}
