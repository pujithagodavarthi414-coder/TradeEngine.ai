using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class LeaveEncashmentSettingsSearchInputModel: SearchCriteriaInputModelBase
    {
        public LeaveEncashmentSettingsSearchInputModel() : base(InputTypeGuidConstants.LeaveEncashmentSettingsSearchInputCommandTypeGuid)
        {
        }

        public Guid? LeaveEncashmentSettingsId { get; set; }
        public Guid? PayRollComponentId { get; set; }
        public bool IsCtcType { get; set; }
        public decimal? Percetage { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("LeaveEncashmentSettingsId = " + LeaveEncashmentSettingsId);
            stringBuilder.Append(",PayRollComponentId = " + PayRollComponentId);
            stringBuilder.Append(",Percetage = " + Percetage);
            stringBuilder.Append(",IsCtcType = " + IsCtcType);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
