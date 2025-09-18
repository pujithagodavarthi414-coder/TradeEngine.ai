using BTrak.Common;
using System;

namespace Btrak.Models.Canteen
{
    public class FoodItemSearchCriteria :SearchCriteriaInputModelBase
    {
        public FoodItemSearchCriteria() : base(InputTypeGuidConstants.FoodItemSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? FoodItemId { get; set; }
    }
}
