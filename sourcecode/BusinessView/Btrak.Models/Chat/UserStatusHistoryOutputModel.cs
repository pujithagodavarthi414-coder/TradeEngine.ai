using System;

namespace Btrak.Models.Chat
{
    public class UserStatusHistoryOutputModel
    {
        public string Status { get; set; }
        public string PlatformName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string IpAddress { get; set; }
    }
}