using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetCompetenciesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetCompetenciesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetCompetencies)
        {
        }
        public Guid? CompetencyId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CompetencyId = " + CompetencyId);
            return stringBuilder.ToString();
        }
    }
}
