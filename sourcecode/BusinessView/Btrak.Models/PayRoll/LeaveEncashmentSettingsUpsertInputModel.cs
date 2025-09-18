using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class LeaveEncashmentSettingsUpsertInputModel : InputModelBase
    {
        public LeaveEncashmentSettingsUpsertInputModel() : base(InputTypeGuidConstants.LeaveEncashmentSettingsInputCommandTypeGuid)
        {
        }

        public Guid? LeaveEncashmentSettingsId { get; set; }
        public Guid? PayRollComponentId { get; set; }
        public Guid? BranchId { get; set; }
        public bool IsCtcType { get; set; }
        public decimal? Percentage { get; set; }
        public bool? IsArchived { get; set; }
        public decimal? Amount { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("LeaveEncashmentSettingsId = " + LeaveEncashmentSettingsId);
            stringBuilder.Append(",PayRollComponentId = " + PayRollComponentId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",Percentage = " + Percentage);
            stringBuilder.Append(",IsCtcType = " + IsCtcType);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            return stringBuilder.ToString();
        }
    }
}
