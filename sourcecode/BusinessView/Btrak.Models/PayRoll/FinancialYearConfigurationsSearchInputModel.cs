using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class FinancialYearConfigurationsSearchInputModel : SearchCriteriaInputModelBase
    {
        public FinancialYearConfigurationsSearchInputModel() : base(InputTypeGuidConstants.FinancialYearConfigurationsSearchInputCommandTypeGuid)
        {
        }

        public Guid? FinancialYearConfigurationsId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("FinancialYearConfigurationsId = " + FinancialYearConfigurationsId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
