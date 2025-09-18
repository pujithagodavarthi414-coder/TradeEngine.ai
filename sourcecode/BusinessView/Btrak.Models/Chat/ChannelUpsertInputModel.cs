using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Chat
{
    public class  ChannelUpsertInputModel: InputModelBase
    {
        public ChannelUpsertInputModel() : base(InputTypeGuidConstants.ChannelUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ChannelId { get; set; }
        public string ChannelName { get; set; }
        public string ChannelImage { get; set; }
        public bool IsDeleted { get; set; }
        public List<ChannelMemberModel> ChannelMemberModel { get; set; }
        public string ChannelMemberXml { get; set; }
        public Guid? ProjectId { get; set; }
        public bool IsFromBackend { get; set; }
        public bool? IsFromProjectArchive { get; set; }
        public bool IsFromChannelImageUpdate { get; set; }
        public Guid? CurrentOwnerShipId { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ChannelId = " + ChannelId);
            stringBuilder.Append(", ChannelName = " + ChannelName);
            stringBuilder.Append(", ChannelImage = " + ChannelImage);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", ChannelMemberXml = " + ChannelMemberXml);
            stringBuilder.Append(", IsFromProjectArchive = " + IsFromProjectArchive);
            return stringBuilder.ToString();
        }
    }

    public class ChannelMemberModel
    {
        public Guid? ChannelMemberId { get; set; }
        public Guid? MemberUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsReadOnly { get; set; }
        public dynamic TimeStampBinary { get; set; }
    }
}
