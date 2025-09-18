using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class ContractPaySettingsSearchInputModel : SearchCriteriaInputModelBase
    {
        public ContractPaySettingsSearchInputModel() : base(InputTypeGuidConstants.ContractPaySettingsSearchInputCommandTypeGuid)
        {
        }

        public Guid? ContractPaySettingsId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + ContractPaySettingsId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
