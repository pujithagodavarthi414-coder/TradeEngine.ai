using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Chat
{
    public class MessageSearchInputModel : InputModelBase
    {
        public MessageSearchInputModel() : base(InputTypeGuidConstants.MessageSearchInputCommandTypeGuid)
        {
        }

        public Guid? MessageId { get; set; }
        public int? MessageCount { get; set; }
        public Guid? ChannelId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? IsArchived { get; set; }
        public bool IsPersonalChat { get; set; }
        public bool IsForSingleMessageDetails { get; set; }
        public Guid? ParentMessageId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string MobileVersionNumber { get; set; }
        public string WindowsVersionNumber { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ChannelId = " + ChannelId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", MessageId = " + MessageId);
            stringBuilder.Append(", MessageCount = " + MessageCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", IsPersonalChat = " + IsPersonalChat);
            stringBuilder.Append(", ParentMessageId = " + ParentMessageId);
            return stringBuilder.ToString();
        }
    }
}
