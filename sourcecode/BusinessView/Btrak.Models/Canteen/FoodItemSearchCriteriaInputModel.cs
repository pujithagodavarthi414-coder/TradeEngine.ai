using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Canteen
{
    public class FoodItemSearchCriteriaInputModel :SearchCriteriaInputModelBase
    {
        public FoodItemSearchCriteriaInputModel() : base(InputTypeGuidConstants.FoodItemSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? FoodItemId { get; set; }

        public DateTime? DateFrom { get; set; }

        public DateTime? DateTo { get; set; }
        public Guid? EntityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", FoodItemId = " + FoodItemId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
