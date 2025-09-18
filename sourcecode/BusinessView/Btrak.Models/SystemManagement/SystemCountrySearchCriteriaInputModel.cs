using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.SystemManagement
{
    public class SystemCountrySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public SystemCountrySearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchSystemCountriesCommandId)
        {
        }

        public Guid? CountryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CountryId = " + CountryId);
            stringBuilder.Append("SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}