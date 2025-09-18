using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CompanyLocation
{
    public class CompanyLocationInputModel : InputModelBase
    {
        public CompanyLocationInputModel() : base(InputTypeGuidConstants.CompanyLocationInputCommandTypeGuid)
        {
        }

        public Guid? CompanyLocationId { get; set; }
        public string LocationName { get; set; }
        public string Address { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public bool? IsArchived { get; set; }
       
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyLocationId = " + CompanyLocationId);
            stringBuilder.Append(", LocationName = " + LocationName);
            stringBuilder.Append(", Address = " + Address);
            stringBuilder.Append(", Latitude = " + Latitude);
            stringBuilder.Append(", Longitude = " + Longitude);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
