using AuthenticationServices.Common;
using System;
using System.Text;

namespace AuthenticationServices.Models.TimeZone
{
    public class TimeZoneInputModel : InputModelBase
    {
        public TimeZoneInputModel() : base(InputTypeGuidConstants.TimeZoneInputCommandTypeGuid)
        {
        }

        public Guid? TimeZoneId { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public string CountryCode { get; set; }
        public string CountryName { get; set; }
        public string TimeZone { get; set; }
        public string TimeZoneOffset { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            stringBuilder.Append(", TimeZoneName = " + TimeZoneName);
            stringBuilder.Append(", TimeZoneOffset = " + TimeZoneOffset);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
