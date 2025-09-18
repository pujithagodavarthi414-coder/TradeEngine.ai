using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace Btrak.Models.Chat
{
    [XmlRoot(ElementName = "MessageReactionModel")]
    public class MessageReactionModel
    {
        [XmlElement(ElementName = "MessageReactions")]
        public List<MessageReactions> MessageReactions { get; set; }
    }
    
    public class MessageReactions
    {
        public Guid? Id { get; set; }

        public string TextMessage { get; set; }

        public Guid? ParentMessageId { get; set; }

        public Guid? OriginalId { get; set; }

        public Guid? ReactedByUserId { get; set; }

        public int EmojiCount { get; set; }

        public DateTime? ReactedDateTime { get; set; }

        public List<Guid?> ReactedByUserIds =new List<Guid?>();
    }
}
