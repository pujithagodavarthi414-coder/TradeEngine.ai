using System;

namespace Btrak.Models.Chat
{
    public class ChannelSpReturnModel
    {
        public Guid? Id { get; set; }
        public string ChannelName { get; set; }
        public string ChannelImage { get; set; }
        public bool IsDeleted { get; set; }

        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }

        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public int MessagesUnReadCount { get; set; }
        public Guid? CompanyId { get; set; }
    }
}
