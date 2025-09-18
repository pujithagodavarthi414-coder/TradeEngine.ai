using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioCommon.Constants
{
    public class NotificationModel
    {
            public Guid? Id { get; set; }
            public string NotificationType { get; set; }
            public string Summary { get; set; }
            public string NavigationUrl { get; set; }
            public Guid? NotifyToUserId { get; set; }
            public DateTime? ReadTime { get; set; }
            public DateTime? CreatedDateTime { get; set; }
            public DateTime? UpdatedDateTime { get; set; }
            public Guid? CreatedByUserId { get; set; }
            public Guid? UpdatedByUserId { get; set; }
            public DateTime? InActiveDateTime { get; set; }
            public bool? IsArchived { get; set; }
    }

    public class NotificationReadModel
    {
        public List<Guid?> NotificationIds { get; set; }
        public DateTime? ReadTime { get; set; }
        public Guid? UserId { get; set; }
    }
}
