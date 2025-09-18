using System;
using System.Collections.Generic;

namespace Btrak.Models.Chat
{
    public class StarredMessagesApiReturnModel
    {
        public Guid MessageId { get; set; }

        public Guid? ParentMessageId { get; set; }

        public Guid? ChannelId { get; set; }

        public Guid SenderUserId { get; set; }

        public string ReactionsJson { get; set; }

        public List<Reactions> Reactions { get; set; }

        public DateTime MessageCreatedDateTime { get; set; }

        public string Message { get; set; }

        public string FilePath { get; set; }

        public List<Guid?> TaggedMembersIds { get; set; }

        public string TaggedMembersXml { get; set; }

        public int ReactionCount { get; set; }

        public byte[] TimeStamp { get; set; }

        public Guid? ReceiverUserId { get; set; }

        public DateTime StarredDateTime { get; set; }

        public int ThreadMessagesCount { get; set; }

        public bool? IsPinned { get; set; }
        public Guid? PinnedByUserId { get; set; }
    }

    public class Reactions
    {
        public string Reaction { get; set; }
    }
}
