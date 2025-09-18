using System;
using BTrak.Common;

namespace Btrak.Models.Notification
{
    public class NotificationSearchModel : SearchCriteriaInputModelBase
    {
        public NotificationSearchModel() : base(InputTypeGuidConstants.GetNotifications)
        {
        }
        public Guid? NotificationId { get; set; }
        public Guid? NotificationTypeId { get; set; }
        public string Summary { get; set; }
    }
}
