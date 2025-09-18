using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.CompanyLocation
{
    public class CompanyLocationInputSearchCriteriaModel : SearchCriteriaInputModelBase
    {
        public CompanyLocationInputSearchCriteriaModel() : base(InputTypeGuidConstants.CompanyLocationInputSearchCriteriaCommandTypeGuid)
        {
        }
        public Guid? CompanyLocationId { get; set; }
        public string LocationName { get; set; }
        public string Address { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyLocationId = " + CompanyLocationId);
            stringBuilder.Append(", LocationName = " + LocationName);
            stringBuilder.Append(", Address = " + Address);
            stringBuilder.Append(", Latitude = " + Latitude);
            stringBuilder.Append(", Longitude = " + Longitude);
            return stringBuilder.ToString();
        }
    }
}