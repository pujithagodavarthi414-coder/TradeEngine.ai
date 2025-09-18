using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class MembershipSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public MembershipSearchCriteriaInputModel() : base(InputTypeGuidConstants.MembershipSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? MemberShipId { get; set; }
        public string MemberShipType { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MemberShipId = " + MemberShipId);
            stringBuilder.Append("MemberShipType = " + MemberShipType);
            stringBuilder.Append(", SearchText   = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
