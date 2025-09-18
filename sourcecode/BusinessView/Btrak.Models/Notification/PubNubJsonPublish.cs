using System;

namespace Btrak.Models.Notification
{
    public class PubNubJsonPublish
    {
        public PubNubJsonPublish(Guid? id, Guid notificationTypeGuid, string notificationSummary, DateTime notificationCreatedDateTime, string notification)
        {
            Id = id;
            NotificationTypeGuid = notificationTypeGuid;
            NotificationSummary = notificationSummary;
            NotificationCreatedDateTime = notificationCreatedDateTime;
            Notification = notification;
        }

        public Guid? Id { get; set; }
        public Guid NotificationTypeGuid { get; set; }
        public string NotificationSummary { get; set; }
        public DateTime NotificationCreatedDateTime { get; set; }
        public string Notification { get; set; }
    }
}