using System;

namespace Btrak.Models.Chat
{
    public class RecentChannelConversationApiReturnModel
    {
        public Guid? ChannelId { get; set; }
        public string ChannelName { get; set; }
        public string ChannelProfileImage { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime LastMessageDateTime { get; set; }
        public int UnreadMessageCount { get; set; }
        public bool IsMuted { get; set; }
        public bool IsStarred { get; set; }
        public bool IsReadOnly { get; set; }

        public Guid CreatedByUserId { get; set; }

        public string CreatedByUserName { get; set; }

        public Guid? CurrentOwnerShipId { get; set; }

        public string CurrentOwnerName { get; set; }

        public DateTime CreatedDateTime { get; set; }
    }
}