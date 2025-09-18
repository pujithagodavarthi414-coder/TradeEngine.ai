using System;

namespace Btrak.Models.Chat
{
    public class SearchSharedorUnsharedchannelsOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? CompanyId { get; set; }
        public string ChannelName { get; set; }
        public bool IsDeleted { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }
        public Guid? CurrentOwnerShipId { get; set; }
    }
}
