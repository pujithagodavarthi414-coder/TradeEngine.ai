using BTrak.Common;
using System;

namespace Btrak.Models.Canteen
{
    public class CanteenPurchasesSearchCriteria :SearchCriteriaInputModelBase
    {
        public CanteenPurchasesSearchCriteria() : base(InputTypeGuidConstants.CanteenPurchasesSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public Guid? FoodItemId { get; set; }
        public DateTime? PurchasedDateTime { get; set; }
    }
}
