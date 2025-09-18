using System;

namespace Btrak.Models.Chat
{
    public class MessageShareSpReturnModel
    {
        public Guid? MessageId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsChannel { get; set; }
        public Guid? ReceiverId { get; set; }
    }
}
