using System;
using System.Collections.Generic;

namespace Btrak.Models.Notification
{
    public class UserNotificationRead
    {
        public Guid? UserNotificationReadId { get; set; }
        public Guid? NotificationId { get; set; }
        public string NotificationIdXml { get; set; }
        public Guid? UserId { get; set; }
        public DateTime? ReadDateTime { get; set; }
        public Guid OperationsPerformedBy { get; set; }
        public List<Guid> NotificationsIds { get; set; }
    }
}