using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Chat
{
    public class MessageReadReceiptInputModel
    {
        public Guid MessageId { get; set; }
        public Guid SenderuserId { get; set; }
        public DateTime MessageDateTime { get; set; }
        public bool IsChannel { get; set; }
    }

    public class UnReadMessagesInputModel
    {
        public int Type { get; set; }
        public List<Guid> ContactsOrChannelIds { get; set; }
    }
}
