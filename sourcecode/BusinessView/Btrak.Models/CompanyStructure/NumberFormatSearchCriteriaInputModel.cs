using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class NumberFormatSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public NumberFormatSearchCriteriaInputModel() : base(InputTypeGuidConstants.NumberFormatSearch)
        {
        }
        public Guid? NumberFormatId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" NumberFormatId  = " + NumberFormatId);
            return stringBuilder.ToString();
        }
    }
}
