using System;
using System.Text;

namespace Btrak.Models.Canteen
{
    public class FoodItemApiReturnModel
    {
        public Guid? FoodItemId { get; set; }
        public string FoodItemName { get; set; }
        public decimal Price { get; set; }
        public Guid CurrencyId { get; set; }
        public Guid? BranchId { get; set; }
        public string CurrencyName { get; set; }
        public DateTime? ItemAddedDate { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string CreatedByUserName { get; set; }
        public string TotalCount { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Id = " + FoodItemId);
            stringBuilder.Append(", FoodItemName = " + FoodItemName);
            stringBuilder.Append(", Price = " + Price);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", BranchId = " + BranchId);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", ItemAddedDate = " + ItemAddedDate);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedByUserName = " + CreatedByUserName);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
