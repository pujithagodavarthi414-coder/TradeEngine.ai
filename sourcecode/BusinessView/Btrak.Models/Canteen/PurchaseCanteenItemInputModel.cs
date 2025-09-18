using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Canteen
{
    public class PurchaseCanteenItemInputModel : InputModelBase
    {
        public PurchaseCanteenItemInputModel() : base(InputTypeGuidConstants.CanteenPurchasesSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? CanteenItemId { get; set; }
        public int? Quantity { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CanteenItemId = " + CanteenItemId);
            stringBuilder.Append(", Quantity = " + Quantity);
            return stringBuilder.ToString();
        }
    }
}
