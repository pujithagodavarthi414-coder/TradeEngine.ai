using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class SubscriptionPaidBySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public SubscriptionPaidBySearchCriteriaInputModel() : base(InputTypeGuidConstants.SubscriptionPaidBySearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? SubscriptionPaidById { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SubscriptionPaidById = " + SubscriptionPaidById);
            stringBuilder.Append(", SearchText   = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
