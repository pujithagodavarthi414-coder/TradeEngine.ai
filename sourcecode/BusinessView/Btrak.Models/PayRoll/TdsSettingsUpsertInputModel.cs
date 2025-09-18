using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class TdsSettingsUpsertInputModel : InputModelBase
    {
        public TdsSettingsUpsertInputModel() : base(InputTypeGuidConstants.TdsSettingsInputCommandTypeGuid)
        {
        }

        public Guid? TdsSettingsId { get; set; }
        public Guid? BranchId { get; set; }
        public bool IsTdsRequired { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + TdsSettingsId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",IsTdsRequired = " + IsTdsRequired);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
