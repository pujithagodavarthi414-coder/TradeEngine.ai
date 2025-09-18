using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Chat
{
    public class MuteOrStarContactModel
    {
        public Guid? ChannelId { get; set; }
        public Guid? UserId { get; set; }
        public bool IsMuted { get; set; }
        public bool IsStarred { get; set; }
        public bool IsLeave { get; set; }
    }
}
