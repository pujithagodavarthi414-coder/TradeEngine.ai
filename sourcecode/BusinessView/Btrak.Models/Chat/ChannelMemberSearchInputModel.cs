using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Chat
{
    public class ChannelMemberSearchInputModel : InputModelBase
    {
        public ChannelMemberSearchInputModel() : base(InputTypeGuidConstants.ChannelMemberSearchInputCommandTypeGuid)
        {
            if(IsActive==null)
            {
                IsActive = true;
            }
        }

        public Guid? ChannelId { get; set; }
        public bool? IsActive { get; set; }
        public bool IsAddMemberToChannel { get; set; }
        public Guid? ProjectId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ChannelId = " + ChannelId);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", IsAddMemberToChannel = " + IsAddMemberToChannel);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            return stringBuilder.ToString();
        }
    }
}
