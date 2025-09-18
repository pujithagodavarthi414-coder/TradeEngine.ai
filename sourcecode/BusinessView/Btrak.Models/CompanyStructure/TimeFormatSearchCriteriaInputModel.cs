using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyStructure
{
    public class TimeFormatSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public TimeFormatSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchTimeFormat)
        {
        }
        public Guid? TimeFormatId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", TimeFormatId   = " + TimeFormatId);
            return stringBuilder.ToString();
        }
    }
}
