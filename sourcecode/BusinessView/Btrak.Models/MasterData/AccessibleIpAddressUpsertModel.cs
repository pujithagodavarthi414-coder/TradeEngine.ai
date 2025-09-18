using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class AccessibleIpAddressUpsertModel : InputModelBase
    {
        public AccessibleIpAddressUpsertModel() : base(InputTypeGuidConstants.AccessisbleIpAdressesInputCommandTypeGuid)
        {
        }

        public Guid? IpAddressId { get; set; }
        public string LocationName { get; set; }
        public string IpAddress { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" IpAddressId= " + IpAddressId);
            stringBuilder.Append(" Name= " + LocationName);
            stringBuilder.Append(" IpAddress= " + IpAddress);
            stringBuilder.Append(" IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}