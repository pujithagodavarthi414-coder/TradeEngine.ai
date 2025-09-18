using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetAllNationalitiesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetAllNationalitiesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetAllNationalities)
        {
        }
        public Guid? NationalityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("NationalityId = " + NationalityId);
            return stringBuilder.ToString();
        }
    }
}
