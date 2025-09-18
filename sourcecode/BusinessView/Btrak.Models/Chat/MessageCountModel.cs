using System;

namespace Btrak.Models.Chat
{
    public class MessageCountModel
    {
        public Guid SenderId { get; set; }
        public Guid? ReceiverId { get; set; }
        public Guid? ChannelId { get; set; }
        public int MessageCount { get; set; }
    }
}
