using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class CompanyStructureSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public CompanyStructureSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchCompanyStructure)
        {
        }
        public Guid? IndustryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", IndustryId  = " + IndustryId);
            return stringBuilder.ToString();
        }
    }
}
