using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollCalculationConfigurationsUpsertInputModel : InputModelBase
    {
        public PayRollCalculationConfigurationsUpsertInputModel() : base(InputTypeGuidConstants.PayRollCalculationConfigurationsInputCommandTypeGuid)
        {
        }

        public Guid? PayRollCalculationConfigurationsId { get; set; }
        public Guid? PeriodTypeId { get; set; }
        public Guid? PayRollCalculationTypeId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollCalculationConfigurationsId = " + PayRollCalculationConfigurationsId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",PeriodTypeId = " + PeriodTypeId);
            stringBuilder.Append(",PayRollCalculationTypeId = " + PayRollCalculationTypeId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            return stringBuilder.ToString();
        }
    }
}
