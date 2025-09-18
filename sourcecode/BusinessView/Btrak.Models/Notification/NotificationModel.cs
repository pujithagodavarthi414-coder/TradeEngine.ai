using System;

namespace Btrak.Models.Notification
{
    public class NotificationModel
    {
        public Guid? NotificationId { get; set; }
        public Guid NotificationTypeId { get; set; }
        public string Summary { get; set; }
        public string NotificationJson { get; set; }
    }
}
