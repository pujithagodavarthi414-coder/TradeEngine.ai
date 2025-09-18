using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Chat
{
    public class UnreadMessagesCountOutputModel
    {
        public int ChannelsUnreadMessagesCount { get; set; }
        public int UsersUnreadMessagesCount { get; set; }
        public int TotalCount => ChannelsUnreadMessagesCount + UsersUnreadMessagesCount;
    }
}
