using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.FoodOrders
{
    public class ChangeFoodOrderStatusInputModel : InputModelBase
    {
        public ChangeFoodOrderStatusInputModel() : base(InputTypeGuidConstants.FoodOrderInputCommandTypeGuid)
        {
        }
        public Guid? FoodOrderId { get; set; }
        public bool? IsFoodOrderApproved { get; set; }
        public string RejectReason { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", FoodOrderId = " + FoodOrderId);
            stringBuilder.Append(", IsFoodOrderApproved = " + IsFoodOrderApproved);
            stringBuilder.Append(", RejectReason = " + RejectReason);
            return stringBuilder.ToString();
        }
    }
}
