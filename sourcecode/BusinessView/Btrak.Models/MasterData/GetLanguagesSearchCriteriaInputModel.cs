using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetLanguagesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetLanguagesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetLanguages)
        {
        }
        public Guid? LanguageId { get; set; }
        public string LanguageName { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LanguageId = " + LanguageId);
            stringBuilder.Append(", LanguageName = " + LanguageName);
            return stringBuilder.ToString();
        }
    }
}
