using System;
using System.Text;

namespace Btrak.Models.SystemManagement
{
    public class SystemCountryApiReturnModel
    {
        public Guid? CountryId { get; set; }
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CountryId = " + CountryId);
            stringBuilder.Append(", CountryName = " + CountryName);
            stringBuilder.Append(", CountryCode = " + CountryCode);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
