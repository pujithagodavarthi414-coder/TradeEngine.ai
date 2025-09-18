using System;

namespace Btrak.Models.Chat
{
    public class InduvidualMessageModel
    {
        public Guid? Id { get; set; }
        public Guid? ChannelId { get; set; }
        public Guid SenderUserId { get; set; }
        public Guid? ReceiverUserId { get; set; }
        public Guid MessageTypeId { get; set; }
        public string TextMessage { get; set; }
        public bool? IsDeleted { get; set; }
        public DateTime MessageDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string FilePath { get; set; }

        public string FileType { get; set; }

        public string ReceiverName
        { get; set; }

        public string ReceiverProfileImage
        { get; set; }

        public string SenderName
        { get; set; }

        public string SenderProfileImage
        { get; set; }

        public int UnreadMessageCount { get; set; }
        public string ChannelName { get; set; }
    }
}