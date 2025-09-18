using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Canteen
{
    public class CanteenFoodItemInputModel :InputModelBase
    {
        public CanteenFoodItemInputModel() : base(InputTypeGuidConstants.CanteenFoodItemInputCommandTypeGuid)
        {
        }

        public Guid? FoodItemId { get; set; }
        public string FoodItemName { get; set; }
        public Guid? BranchId { get; set; }
        public decimal Price { get; set; }
        public Guid? CurrencyId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Id = " + FoodItemId);
            stringBuilder.Append(", FoodItemName = " + FoodItemName);
            stringBuilder.Append(", Price = " + Price);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString(); 
        }
    }
}
