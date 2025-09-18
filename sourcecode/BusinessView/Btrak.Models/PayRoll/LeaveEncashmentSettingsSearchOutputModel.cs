using System;

namespace Btrak.Models.PayRoll
{
    public class LeaveEncashmentSettingsSearchOutputModel
    {

        public Guid? LeaveEncashmentSettingsId { get; set; }
        public string PayRollComponentName { get; set; }
        public Guid? PayRollComponentId { get; set; }
        public bool? IsCtcType { get; set; }
        public bool? IsArchived { get; set; }
        public decimal? Percentage { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public decimal? Amount { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public int? Type { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public int? DependentType { get; set; }
        public decimal? Value { get; set; }
        public string ModifiedAmount { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
    }
}
