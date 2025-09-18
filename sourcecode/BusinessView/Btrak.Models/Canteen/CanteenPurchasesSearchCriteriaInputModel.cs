using System;
using BTrak.Common;

namespace Btrak.Models.Canteen
{
    public class CanteenPurchasesSearchCriteriaInputModel :SearchCriteriaInputModelBase
    {
        public CanteenPurchasesSearchCriteriaInputModel() : base(InputTypeGuidConstants.CanteenPurchasesSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? UserId { get; set; }
        public Guid? FoodItemId { get; set; }
        public DateTime? PurchasedDateTime { get; set; }
    }
}
