using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Chat
{
    public class MessageApiReturnModel
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
        public List<MessageReactions> MessageReactions=new List<MessageReactions>();
        public string ReportMessage { get; set; }
        public List<Guid?> TaggedMembersIds { get; set; }
        public string TaggedMembersIdsXml { get; set; }
        public List<MessageReactions> OverAllReactions = new List<MessageReactions>();


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ChannelId = " + ChannelId);
            stringBuilder.Append(", ChannelName = " + ChannelName);
            stringBuilder.Append(", SenderUserId = " + SenderUserId);
            stringBuilder.Append(", ReceiverUserId = " + ReceiverUserId);
            stringBuilder.Append(", MessageTypeId = " + MessageTypeId);
            stringBuilder.Append(", TextMessage = " + TextMessage);
            stringBuilder.Append(", ParentMessageId = " + ParentMessageId);
            stringBuilder.Append(", ThreadCount = " + ThreadCount);
            stringBuilder.Append(", MessageTimeSpan = " + MessageTimeSpan);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", MessageDateTime = " + MessageDateTime);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", LastReplyDateTime = " + LastReplyDateTime);
            stringBuilder.Append(", FilePath = " + FilePath);
            stringBuilder.Append(", FileType = " + FileType);
            stringBuilder.Append(", ReceiverName = " + ReceiverName);
            stringBuilder.Append(", ReceiverProfileImage = " + ReceiverProfileImage);
            stringBuilder.Append(", SenderName = " + SenderName);
            stringBuilder.Append(", SenderProfileImage = " + SenderProfileImage);
            stringBuilder.Append(", UnreadMessageCount = " + UnreadMessageCount);
            stringBuilder.Append(", IsEdited = " + IsEdited);
            stringBuilder.Append(", IsRead = " + IsRead);
            stringBuilder.Append(", IsPinned = " + IsPinned);
            stringBuilder.Append(", IsStarred = " + IsStarred);
            stringBuilder.Append(", IsRead = " + IsRead);
            stringBuilder.Append(", ReportMessage = " + ReportMessage);
            stringBuilder.Append(", PinnedByUserId = " + PinnedByUserId);
            stringBuilder.Append(", TaggedMembersIds = " + TaggedMembersIds);
            stringBuilder.Append(", TaggedMembersIdsXml = " + TaggedMembersIdsXml);
            return stringBuilder.ToString();
        }
    }
}
