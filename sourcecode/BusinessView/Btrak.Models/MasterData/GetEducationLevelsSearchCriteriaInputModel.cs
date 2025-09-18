using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetEducationLevelsSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetEducationLevelsSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetEducationLevels)
        {
        }
        public Guid? EducationLevelId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" EducationLevelId = " + EducationLevelId);
            return stringBuilder.ToString();
        }
    }
}
