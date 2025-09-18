using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class ContractTypeUpsertInputModel : InputModelBase
    {
        public ContractTypeUpsertInputModel() : base(InputTypeGuidConstants.ContractTypeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ContractTypeId { get; set; }
        public string ContractTypeName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ContractTypeId = " + ContractTypeId);
            stringBuilder.Append(", ContractTypeName = " + ContractTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
