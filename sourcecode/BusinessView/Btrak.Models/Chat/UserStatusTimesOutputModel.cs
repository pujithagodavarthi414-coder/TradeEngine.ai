using System;

namespace Btrak.Models.Chat
{
    public class UserStatusTimesOutputModel
    {
        public Guid StausId { get; set; }

        public Guid UserId { get; set; }

        public DateTime StatusFromTime { get; set; }

        public Guid PlatformId { get; set; }
    }
}
