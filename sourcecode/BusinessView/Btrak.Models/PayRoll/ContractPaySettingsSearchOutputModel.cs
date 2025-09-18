using System;

namespace Btrak.Models.PayRoll
{
    public class ContractPaySettingsSearchOutputModel
    {
        public Guid? ContractPaySettingsId { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public Guid? ContractPayTypeId { get; set; }
        public string ContractPayTypeName { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsToBePaid { get; set; }
        public bool? IsToBeDeducted { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
    }
}
