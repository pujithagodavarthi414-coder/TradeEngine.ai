using System;

namespace Btrak.Models.PayRoll
{
    public class TdsSettingsSearchOutputModel
    {
        public Guid? TdsSettingsId { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsTdsRequired { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
