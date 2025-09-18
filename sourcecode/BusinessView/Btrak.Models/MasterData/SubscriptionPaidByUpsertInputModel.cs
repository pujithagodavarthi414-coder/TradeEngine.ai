using System;
using System.ComponentModel.DataAnnotations;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class SubscriptionPaidByUpsertInputModel : InputModelBase
    {
        public SubscriptionPaidByUpsertInputModel() : base(InputTypeGuidConstants.SubscriptionPaidByUpsertInputCommandTypeGuid)
        {
        }

        public Guid? SubscriptionPaidById { get; set; }
        [StringLength(50)]
        public string SubscriptionPaidByName { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SubscriptionPaidById = " + SubscriptionPaidById);
            stringBuilder.Append(", SubscriptionPaidByName = " + SubscriptionPaidByName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}