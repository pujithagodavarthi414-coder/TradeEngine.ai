using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Canteen
{
    public class CanteenPurchaseOutputModel : InputModelBase
    {
        public CanteenPurchaseOutputModel() : base(InputTypeGuidConstants.CanteenPurchaseOutputModelCommandTypeGuid)
        {
        }
        public Guid? UserPurchasedCanteenFoodItemId { get; set; }
        public Guid? CanteenItemId { get; set; }
        public string CanteenItemName { get; set; }
        public decimal? Amount { get; set; }
        public int? Quantity { get; set; }
        public DateTime? PurchasedDateTime { get; set; }
        public Guid? PurchasedByUserId { get; set; }
        public string PurchasedByUserName { get; set; }
        public string PurchasedByProfileImage { get; set; }
        public int? TotalCount { get; set; }
        public float? Balance { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CanteenItemId = " + CanteenItemId);
            stringBuilder.Append(", CanteenItemName = " + CanteenItemName);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", Qunatity = " + Quantity);
            stringBuilder.Append(", PurchasedDateTime = " + PurchasedDateTime);
            stringBuilder.Append(", PurchasedByUserId = " + PurchasedByUserId);
            stringBuilder.Append(", PurchasedByUserName = " + PurchasedByUserName);
            stringBuilder.Append(", PurchasedByProfileImage = " + PurchasedByProfileImage);
            stringBuilder.Append(", Balance = " + Balance);
            return stringBuilder.ToString();
        }
    }
}
