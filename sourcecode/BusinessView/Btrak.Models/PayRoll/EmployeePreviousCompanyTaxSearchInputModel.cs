using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class EmployeePreviousCompanyTaxSearchInputModel: SearchCriteriaInputModelBase
    {
        public EmployeePreviousCompanyTaxSearchInputModel() : base(InputTypeGuidConstants.FinancialYearConfigurationsSearchInputCommandTypeGuid)
        {
        }

        public Guid? EmployeePreviousCompanyTaxId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EmployeePreviousCompanyTaxId = " + EmployeePreviousCompanyTaxId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
