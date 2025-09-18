using System;
using System.Text;

namespace Btrak.Models.CompanyStructureManagement
{
    public class CountryApiReturnModel
    {
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public string InActiveOn { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CountryId = " + CountryId);
            stringBuilder.Append(", CountryName = " + CountryName);
            stringBuilder.Append(", CountryCode = " + CountryCode);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", InActiveOn = " + InActiveOn);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
