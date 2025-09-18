using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Chat
{
    public class ChannelSearchInputModel : InputModelBase
    {
        public ChannelSearchInputModel() : base(InputTypeGuidConstants.ChannelSearchInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public string ChannelName { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? ArchivedDateTime { get; set; }

        public Guid? ProjectId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? ChannelId { get; set; }
        public Guid? MemberUserId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", ChannelName = " + ChannelName);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            return stringBuilder.ToString();
        }
    }
}
