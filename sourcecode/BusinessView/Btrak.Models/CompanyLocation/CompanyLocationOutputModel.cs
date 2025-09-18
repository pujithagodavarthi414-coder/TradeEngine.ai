using System;
using System.Text;

namespace Btrak.Models.CompanyLocation
{
    public class CompanyLocationOutputModel 
    {
        public Guid? CompanyLocationId { get; set; }
        public string LocationName { get; set; }
        public string Address { get; set; }
        public decimal? Latitude { get; set; }
        public decimal? Longitude { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? OriginalId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public int? VersionNumber { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyLocationId = " + CompanyLocationId);
            stringBuilder.Append(", LocationName = " + LocationName);
            stringBuilder.Append(", Address = " + Address);
            stringBuilder.Append(", Latitude = " + Latitude);
            stringBuilder.Append(", Longitude = " + Longitude);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", OriginalId = " + OriginalId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", VersionNumber = " + VersionNumber);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
