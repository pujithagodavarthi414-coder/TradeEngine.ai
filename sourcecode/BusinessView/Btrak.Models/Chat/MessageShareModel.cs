using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Chat
{
    public class MessageShareModel
    {
        public Guid? ShareMessageId { get; set; }
        public List<MessageMiniModel> Messages { get; set; }
        public string MessagesXml { get; set; }
    }

    public class MessageMiniModel
    {
        public Guid? MessageId { get; set; }
        public bool IsChannel { get; set; }
        public Guid? ReceiverId { get; set; }
        public DateTime MessageCreatedDateTime { get; set; }
    }
}
