using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class LanguageUpsertModel : InputModelBase
    {
        public LanguageUpsertModel() : base(InputTypeGuidConstants.LanguageInputCommandTypeGuid)
        {
        }

        public Guid? LanguageId { get; set; }
        public string LanguageName { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LanguageId = " + LanguageId);
            stringBuilder.Append(", LanguageName = " + LanguageName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
