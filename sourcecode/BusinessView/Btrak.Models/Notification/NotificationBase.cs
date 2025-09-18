using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace Btrak.Models.Notification
{
    public class NotificationBase
    {
        public Guid NotificationTypeGuid { get; }
        public string Summary { get; set; }
        public List<string> Channels { get; } = new List<string>();
        public DateTime CreatedDateTime { get; }
        public Guid? Id { get; set; }
        public string NotificationJson { get; set; }

        public NotificationBase(Guid notificationTypeGuid, string summary)
        {
            Id = Guid.NewGuid();
            NotificationTypeGuid = notificationTypeGuid;
            CreatedDateTime = DateTime.Now;
            Summary = summary;
        }

        public string ToPubNubNotificationString()
        {
            PubNubJsonPublish pubNubJsonPublish = new PubNubJsonPublish(Id,NotificationTypeGuid,
                Summary,
                CreatedDateTime,
                JsonConvert.SerializeObject(this)
            );

            return JsonConvert.SerializeObject(pubNubJsonPublish);
        }
    }
}