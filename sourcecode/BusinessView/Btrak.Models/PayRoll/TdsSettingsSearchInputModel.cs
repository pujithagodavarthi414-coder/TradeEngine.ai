using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class TdsSettingsSearchInputModel : SearchCriteriaInputModelBase
    {
        public TdsSettingsSearchInputModel() : base(InputTypeGuidConstants.TdsSettingsSearchInputCommandTypeGuid)
        {
        }

        public Guid? TdsSettingsId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CompanySettingsId = " + TdsSettingsId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
