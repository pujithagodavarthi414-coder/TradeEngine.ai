using BTrak.Common;

namespace Btrak.Models.FoodOrders
{
    public class FoodOrderSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public FoodOrderSearchCriteriaInputModel() : base(InputTypeGuidConstants.FoodOrderSearchCriteriaInputCommandTypeGuid)
        {
        }
    }
}
