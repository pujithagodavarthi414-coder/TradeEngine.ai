using System;
using System.Collections.Generic;

namespace Btrak.Models.Chat
{
    public class MessageSpReturnModel
    {
        public Guid? Id { get; set; }
        public Guid? ChannelId { get; set; }
        public string ChannelName { get; set; }
        public Guid SenderUserId { get; set; }
        public Guid? ReceiverUserId { get; set; }
        public Guid MessageTypeId { get; set; }
        public string TextMessage { get; set; }
        public Guid? ParentMessageId { get; set; }
        public int ThreadCount { get; set; }
        public int MessageTimeSpan { get; set; }
        public bool? IsDeleted { get; set; }
        public DateTime MessageDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime LastReplyDateTime { get; set; }
        public string FilePath { get; set; }
        public string FileType { get; set; }
        public string ReceiverName { get; set; }
        public string ReceiverProfileImage { get; set; }
        public string SenderName { get; set; }
        public string SenderProfileImage { get; set; }
        public int UnreadMessageCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsEdited { get; set; }
        public bool? IsRead { get; set; }
        public bool? IsActivityMessage { get; set; }
        public bool? IsPinned { get; set; }
        public bool? IsStarred { get; set; }
        public Guid? PinnedByUserId { get; set; }
        public string MessageReactionModel { get; set; }
        public string ReportMessage { get; set; }
        public List<Guid?> TaggedMembersIds { get; set; }
        public string TaggedMembersIdsXml { get; set; }
    }
}
