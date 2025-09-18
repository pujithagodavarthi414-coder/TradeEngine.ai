using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class CompanySettingsSearchInputModel : SearchCriteriaInputModelBase
    {
        public CompanySettingsSearchInputModel() : base(InputTypeGuidConstants.CompanySettingsSearchInputCommandTypeGuid)
        {
        }

        public Guid? CompanySettingsId { get; set; }
        public string Key { get; set; }      
        public string Value { get; set; }
        public string Description { get; set; }
        public bool? IsSystemApp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + CompanySettingsId);
            stringBuilder.Append(",Key = " + Key);
            stringBuilder.Append(",Value = " + Value);
            stringBuilder.Append(",Description = " + Description);
            stringBuilder.Append(",SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
