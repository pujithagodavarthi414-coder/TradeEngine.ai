using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class ContractPaySettingsUpsertInputModel : InputModelBase
    {
        public ContractPaySettingsUpsertInputModel() : base(InputTypeGuidConstants.ContractPaySettingsInputCommandTypeGuid)
        {
        }

        public Guid? ContractPaySettingsId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? ContractPayTypeId { get; set; }
        public bool IsToBePaid { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + ContractPaySettingsId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",ContractPayTypeId = " + ContractPayTypeId);
            stringBuilder.Append(",ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(",ActiveTo = " + ActiveTo);
            stringBuilder.Append(",IsToBePaid = " + IsToBePaid);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
