using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class IndustryModuleSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public IndustryModuleSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchIndustryModule)
        {
        }
        public Guid? IndustryModuleId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", IndustryModuleId  = " + IndustryModuleId);
            return stringBuilder.ToString();
        }
    }
}
