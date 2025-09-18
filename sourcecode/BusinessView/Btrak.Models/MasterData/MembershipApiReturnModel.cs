using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class MembershipApiReturnModel
    {
        public Guid? MembershipId { get; set; }
        public string MemberShipName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("MembershipId = " + MembershipId);
            stringBuilder.Append(", MemberShipName = " + MemberShipName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
