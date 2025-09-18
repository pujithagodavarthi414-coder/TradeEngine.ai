using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollTemplateConfigurationUpsertInputModel : InputModelBase
    {
        public PayRollTemplateConfigurationUpsertInputModel() : base(InputTypeGuidConstants.PayRollTemplateConfigurationInputCommandTypeGuid)
        {
        }

        public Guid? PayRollTemplateConfigurationId { get; set; }
        public Guid PayRollComponentId { get; set; }
        public Guid PayRollTemplateId { get; set; }
        public bool IsPercentage { get; set; }
        public decimal? Amount { get; set; }
        public decimal? Percentagevalue { get; set; }
        public bool? IsCtcDependent { get; set; }
        public bool? IsRelatedToPT { get; set; }
        public string ComponentName { get; set; }
        public bool? IsArchived { get; set; }
        public List<Guid> PayRollComponentIds { get; set; }
        public string PayRollComponentXml { get; set; }
        public Guid? ComponentId { get; set; }
        public Guid? DependentPayRollComponentId { get; set; }
        public int? Order { get; set; }
        public bool? IsBands { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollTemplateConfigurationId = " + PayRollTemplateConfigurationId);
            stringBuilder.Append(",PayRollComponentId = " + PayRollComponentId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(", Ispercentage = " + IsPercentage);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", Percentagevalue = " + Percentagevalue);
            stringBuilder.Append(", IsCtcDependent = " + IsCtcDependent);
            stringBuilder.Append(", IsRelatedToPT = " + IsRelatedToPT);
            stringBuilder.Append(", ComponentName = " + ComponentName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsBands = " + IsBands);
            stringBuilder.Append(", PayRollComponentIds = " + PayRollComponentIds);
            stringBuilder.Append(",ComponentId = " + ComponentId);
            stringBuilder.Append(",DependentPayRollComponentId = " + DependentPayRollComponentId);
            stringBuilder.Append(",Order = " + Order);
            return stringBuilder.ToString();
        }
    }
}
