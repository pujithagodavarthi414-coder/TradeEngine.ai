using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class MainUseCaseSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public MainUseCaseSearchCriteriaInputModel() : base(InputTypeGuidConstants.MainUseCaseSearch)
        {
        }
        public Guid? MainUseCaseId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" MainUseCaseId  = " + MainUseCaseId);
            return stringBuilder.ToString();
        }
    }
}
