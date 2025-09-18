using System;

namespace Btrak.Models.Chat
{
    public class MessengerAuditInputModel
    {
        public Guid? UserId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? PlatformId { get; set; }
        public string IpAddress { get; set; }
    }
}
