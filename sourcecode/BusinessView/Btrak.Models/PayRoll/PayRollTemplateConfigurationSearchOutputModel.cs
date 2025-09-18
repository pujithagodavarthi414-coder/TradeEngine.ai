using System;

namespace Btrak.Models.PayRoll
{
    public class PayRollTemplateConfigurationSearchOutputModel
    {
        public Guid? PayRollTemplateConfigurationId { get; set; }
        public string PayRollComponentName { get; set; }
        public string PayRollTemplateName { get; set; }
        public Guid PayRollComponentId { get; set; }
        public Guid PayRollTemplateId { get; set; }
        public bool IsPercentage { get; set; }
        public decimal? Amount { get; set; }
        public decimal? Percentagevalue { get; set; }
        public bool? IsCtcDependent { get; set; }
        public bool? IsRelatedToPT { get; set; }
        public string ComponentName { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public int? Type { get; set; }
        public decimal? Value { get; set; }
        public int? DependentType { get; set; }
        public Guid? ComponentId { get; set; }
        public bool? IsDeduction { get; set; }
        public Guid? DependentPayRollComponentId { get; set; }
        public string DependentPayRollComponentName { get; set; }
        public int? Order { get; set; }
        public bool? RelatedToContributionPercentage { get; set; }
        public bool? IsBands { get; set; }
    }
}
