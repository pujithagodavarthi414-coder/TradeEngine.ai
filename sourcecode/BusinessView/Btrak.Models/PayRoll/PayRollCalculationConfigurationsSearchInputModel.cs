using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollCalculationConfigurationsSearchInputModel : SearchCriteriaInputModelBase
    {
        public PayRollCalculationConfigurationsSearchInputModel() : base(InputTypeGuidConstants.PayRollCalculationConfigurationsSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollCalculationConfigurationsId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollCalculationConfigurationsId = " + PayRollCalculationConfigurationsId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
