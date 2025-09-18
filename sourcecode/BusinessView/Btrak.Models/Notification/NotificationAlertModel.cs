using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Notification
{
    public class NotificationAlertModel
    {
        public string NotificationType { get; set; }
        public string NotificationText { get; set; }
        public string NotifyToUsersJson { get; set; }
        public string NavigationUrl { get; set; }
    }
}
