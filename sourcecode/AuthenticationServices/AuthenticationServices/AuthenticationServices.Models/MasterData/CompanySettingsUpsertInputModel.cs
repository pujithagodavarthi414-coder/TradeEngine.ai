using AuthenticationServices.Common;
using System;
using System.Text;

namespace AuthenticationServices.Models.MasterData
{
    public class CompanySettingsUpsertInputModel : InputModelBase
    {
        public CompanySettingsUpsertInputModel() : base(InputTypeGuidConstants.CompanySettingsInputCommandTypeGuid)
        {
        }

        public Guid? CompanySettingsId { get; set; }
        public string Key { get; set; }
        public string Value { get; set; }
        public string Description { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsVisible { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("   CompanySettingsId" + CompanySettingsId);
            stringBuilder.Append(", Key" + Key);
            stringBuilder.Append(", Value" + Value);
            stringBuilder.Append(", Description" + Description);
            stringBuilder.Append(", IsArchived" + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
