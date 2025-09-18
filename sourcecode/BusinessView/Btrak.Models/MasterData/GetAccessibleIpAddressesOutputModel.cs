using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class GetAccessibleIpAddressesOutputModel
    {
        public Guid? AccessisbleIpAdressesId { get; set; }
        public Guid? CompanyId { get; set; }
        public string LocationName { get; set; }
        public string IpAddress { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
                
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" AccessibleIpAddressesId = " + AccessisbleIpAdressesId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", Name = " + LocationName);
            stringBuilder.Append(", IpAddress = " + IpAddress);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
