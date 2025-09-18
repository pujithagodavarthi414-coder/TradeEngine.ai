using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class EstimateItemsInputModel : InputModelBase
    {
        public EstimateItemsInputModel() : base(InputTypeGuidConstants.EstimateItemsInputCommandTypeGuid)
        {
        }

        public Guid? EstimateItemId { get; set; }
        public Guid? EstimateId { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public decimal Price { get; set; }
        public decimal Quantity { get; set; }
        public bool IsArchived { get; set; }
        public int Order { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EstimateItemId" + EstimateItemId);
            stringBuilder.Append("EstimateId" + EstimateId);
            stringBuilder.Append("ItemName" + ItemName);
            stringBuilder.Append("ItemDescription" + ItemDescription);
            stringBuilder.Append("Price" + Price);
            stringBuilder.Append("Quantity" + Quantity);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("Order" + Order);
            return base.ToString();
        }
    }
}
