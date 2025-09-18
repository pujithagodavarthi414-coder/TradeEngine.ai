//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace Btrak.Models.Notification
//{
//    class NotificationModelForResignation
//    {
//    }
//}

using BTrak.Common;
using BTrak.Common.Constants;
using System;

namespace Btrak.Models.Notification
{
    public class NotificationModelForResignation : NotificationBase
    {
        public NotificationModelForResignation(string summary) : base(NotificationTypeConstants.ResignationNotification, summary)
        {
            Channels.Add(string.Format(NotificationChannelNamesConstants.ResignationNotification));
        }
    }
}
