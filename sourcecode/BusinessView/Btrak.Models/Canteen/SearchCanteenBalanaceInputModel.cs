using BTrak.Common;
using System;

namespace Btrak.Models.Canteen
{
    public class SearchCanteenBalanceInputModel : SearchCriteriaInputModelBase
    {
        public SearchCanteenBalanceInputModel() : base(InputTypeGuidConstants.CanteenBalanceSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public Guid? EntityId { get; set; }
    }
}
