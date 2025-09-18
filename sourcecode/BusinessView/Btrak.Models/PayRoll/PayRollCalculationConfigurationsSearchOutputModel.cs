using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollCalculationConfigurationsSearchOutputModel
    {
        public Guid? PayRollCalculationConfigurationsId { get; set; }
        public Guid? PeriodTypeId { get; set; }
        public string PeriodTypeName { get; set; }
        public Guid? PayRollCalculationTypeId { get; set; }
        public string PayRollCalculationTypeName { get; set; }
        public Guid?  BranchId { get; set; }
        public string BranchName { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
    }
}
