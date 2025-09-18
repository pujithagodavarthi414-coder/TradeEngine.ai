using System;

namespace Btrak.Models.Chat
{
    public class LatestMessageSearchInputModel
    {
        public Guid ConversationId { get; set; }
        public bool IsChannel { get; set; }
        public Guid MessageId { get; set; }
        public string MobileVersionNumber { get; set; }
        public string WindowsVersionNumber { get; set; }
    }
}