using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.FoodOrders
{
    public class FoodOrderManagementSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public FoodOrderManagementSearchCriteriaInputModel() : base(InputTypeGuidConstants.FoodOrderSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? FoodOrderId { get; set; }
        public Guid? StatusId { get; set; }
        public decimal? Amount { get; set; }
        public Guid? CurrencyId { get; set; }
        public DateTime? OrderDateTime { get; set; }
        public Guid? ClaimedByUserId { get; set; }
        public Guid? CommentId { get; set; }
        public DateTime? Date { get; set; }
        public bool? IsRecent { get; set; }
        public Guid? EntityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", FoodOrderId = " + FoodOrderId);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", OrderDateTime = " + OrderDateTime);
            stringBuilder.Append(", ClaimedByUserId = " + ClaimedByUserId);
            stringBuilder.Append(", CommentId = " + CommentId);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", IsRecent = " + IsRecent);
            return stringBuilder.ToString();
        }
    }
}