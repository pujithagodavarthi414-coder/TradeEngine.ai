using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.CompanyStructure
{
    public class CompanySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public CompanySearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchCompany)
        {
        }

        public Guid? IndustryId { get; set; }
        public Guid? MainUseCaseId { get; set; }
        public string PhoneNumber { get; set; }
        public Guid? CountryId { get; set; }
        public Guid? TimeZoneId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? NumberFormatId { get; set; }
        public Guid? DateFormatId { get; set; }
        public Guid? TimeFormatId { get; set; }
        public int? TeamSize { get; set; }
        public bool? ForSuperUser { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyId   = " + CompanyId);
            stringBuilder.Append(", IndustryId  = " + IndustryId);
            stringBuilder.Append(", MainUseCaseId   = " + MainUseCaseId);
            stringBuilder.Append(", PhoneNumber  = " + PhoneNumber);
            stringBuilder.Append(", CountryId  = " + CountryId);
            stringBuilder.Append(", TimeZoneId   = " + TimeZoneId);
            stringBuilder.Append(", CurrencyId  = " + CurrencyId);
            stringBuilder.Append(", NumberFormatId  = " + NumberFormatId);
            stringBuilder.Append(", DateFormatId   = " + DateFormatId);
            stringBuilder.Append(", TimeFormatId  = " + TimeFormatId);
            stringBuilder.Append(", TeamSize  = " + TeamSize);
            return stringBuilder.ToString();
        }
    }
}
