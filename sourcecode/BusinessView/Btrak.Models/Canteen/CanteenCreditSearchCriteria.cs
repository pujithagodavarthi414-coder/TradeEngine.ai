using BTrak.Common;
using System;

namespace Btrak.Models.Canteen
{
    public class CanteenCreditSearchCriteria : SearchCriteriaInputModelBase
    {
        public CanteenCreditSearchCriteria() : base(InputTypeGuidConstants.CanteenCreditSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? CreditedTo { get; set; }
        public Guid? CreditedByUserId { get; set; }
        public DateTime? CreditedOn { get; set; }
    }
}
