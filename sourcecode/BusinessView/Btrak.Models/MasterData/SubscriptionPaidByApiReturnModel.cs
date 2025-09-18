using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class SubscriptionPaidByApiReturnModel
    {
        public Guid? SubscriptionPaidById { get; set; }
        public string SubscriptionPaidByName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SubscriptionPaidById = " + SubscriptionPaidById);
            stringBuilder.Append(", SubscriptionPaidByName = " + SubscriptionPaidByName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
