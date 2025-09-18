using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetLanguageFluenciesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetLanguageFluenciesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetLanguageFluencies)
        {
        }
        public Guid? LanguageFluencyId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LanguageFluencyId = " + LanguageFluencyId);
            return stringBuilder.ToString();
        }
    }
}
