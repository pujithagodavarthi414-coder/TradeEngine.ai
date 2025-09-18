using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollComponentUpsertInputModel : InputModelBase
    {

        public PayRollComponentUpsertInputModel() : base(InputTypeGuidConstants.CompanySettingsInputCommandTypeGuid)
        {
        }

        public Guid? PayRollComponentId { get; set; }
        public string ComponentName { get; set; }
        public bool IsDeduction { get; set; }
        public bool IsVariablePay { get; set; }
        public bool IsVisible { get; set; }
        public bool? IsArchived { get; set; }
        public decimal? EmployeeContributionPercentage { get; set; }
        public decimal? EmployerContributionPercentage { get; set; }
        public bool? RelatedToContributionPercentage { get; set; }
        public bool IsBands { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + PayRollComponentId);
            stringBuilder.Append(", ComponentName = " + ComponentName);
            stringBuilder.Append(", IsDeduction = " + IsDeduction);
            stringBuilder.Append(", IsVariablePay = " + IsVariablePay);        
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", IsBands = " + IsBands);
            stringBuilder.Append(", EmployeeContributionPercentage = " + EmployeeContributionPercentage);
            stringBuilder.Append(", EmployerContributionPercentage = " + EmployerContributionPercentage);
            stringBuilder.Append(", RelatedToContributionPercentage = " + RelatedToContributionPercentage);
            return stringBuilder.ToString();
        }
    }
}
