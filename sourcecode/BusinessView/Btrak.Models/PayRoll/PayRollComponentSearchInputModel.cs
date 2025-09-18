using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollComponentSearchInputModel : SearchCriteriaInputModelBase
    {

        public PayRollComponentSearchInputModel() : base(InputTypeGuidConstants.PayRollComponentSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollComponentId { get; set; }
        public string ComponentName { get; set; }
        public bool? IsDeduction { get; set; }
        public bool? IsVariablePay { get; set; }
        public bool? IsVisible { get; set; }
        public bool? IsBands { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + PayRollComponentId);
            stringBuilder.Append(",ComponentName = " + ComponentName);
            stringBuilder.Append(",IsDeduction = " + IsDeduction);
            stringBuilder.Append(",IsVariablePay = " + IsVariablePay);
            stringBuilder.Append(",IsVisible = " + IsVisible);
            stringBuilder.Append(",IsBands = " + IsBands);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }

    }
}
