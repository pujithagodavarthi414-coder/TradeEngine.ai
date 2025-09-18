using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Chat
{
    public class MessageUpsertInputModel : InputModelBase
    {
        public MessageUpsertInputModel() : base(InputTypeGuidConstants.MessageUpsertInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid? ChannelId { get; set; }
        public Guid SenderUserId { get; set; }
        public Guid? ReceiverUserId { get; set; }
        public Guid? ParentMessageId { get; set; }
        public string TextMessage { get; set; }
        public bool? IsDeleted { get; set; }
        public DateTime MessageDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string MessageType { get; set; }

        public string FileType { get; set; }
        public string FilePath { get; set; }

        public string SenderName { get; set; }
        public string ReceiverName { get; set; }
        public string ChannelName { get; set; }
        public bool? IsActivityMessage { get; set; }
        public bool? IsPinned { get; set; }
        public bool? IsStarred { get; set; }
        public Guid? PinnedByUserId { get; set; }
        public Guid? ReactedByUserId { get; set; }
        public string ReportMessage { get; set; }
        public List<Guid?> TaggedMembersIds { get; set; }
        public string TaggedMembersIdsXml { get; set; }
        public bool IsFromBackend { get; set; }
        public DateTime? LastThreadMessageTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ChannelId = " + ChannelId);
            stringBuilder.Append(", SenderUserId = " + SenderUserId);
            stringBuilder.Append(", ReceiverUserId = " + ReceiverUserId);
            stringBuilder.Append(", ParentMessageId = " + ParentMessageId);
            stringBuilder.Append(", TextMessage = " + TextMessage);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", MessageDateTime = " + MessageDateTime);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", MessageType = " + MessageType);
            stringBuilder.Append(", FileType = " + FileType);
            stringBuilder.Append(", FilePath = " + FilePath);
            stringBuilder.Append(", SenderName = " + SenderName);
            stringBuilder.Append(", ReceiverName = " + ReceiverName);
            stringBuilder.Append(", ChannelName = " + ChannelName);
            stringBuilder.Append(", IsActivityMessage = " + IsActivityMessage);
            return stringBuilder.ToString();
        }
    }
}
