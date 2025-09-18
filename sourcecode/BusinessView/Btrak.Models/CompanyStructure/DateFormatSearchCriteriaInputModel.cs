using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class DateFormatSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public DateFormatSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchDateFormat)
        {
        }
        public Guid? DateFormatId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", DateFormatId   = " + DateFormatId);
            return stringBuilder.ToString();
        }
    }
}
