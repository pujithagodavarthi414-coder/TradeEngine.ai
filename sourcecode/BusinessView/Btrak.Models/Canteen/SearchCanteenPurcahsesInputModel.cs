using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Canteen
{
    public class SearchCanteenPurcahsesInputModel : SearchCriteriaInputModelBase
    {
        public SearchCanteenPurcahsesInputModel() : base(InputTypeGuidConstants.CanteenPurchasesSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? EntityId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            return stringBuilder.ToString();
        }
    }
}
