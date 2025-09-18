using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class GetAccessibleIpAddressesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public GetAccessibleIpAddressesSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetAccessibleIpAddresses)
        {
        }

        public Guid? AccessibleIpAddressesId { get; set; }
        public string Name { get; set; }
        public string IpAddress { get; set; }
       

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" AccessibleIpAddressesId = " + AccessibleIpAddressesId);
            stringBuilder.Append(", Name = " + Name);
            stringBuilder.Append(", IpAddress = " + IpAddress);
            return stringBuilder.ToString();
        }
    }
}
