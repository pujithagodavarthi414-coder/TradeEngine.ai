using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Canteen
{
    public class CanteenCreditSearchInputModel : SearchCriteriaInputModelBase
    {
        public CanteenCreditSearchInputModel() : base(InputTypeGuidConstants.CanteenCreditSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public Guid? CanteenCreditId { get; set; }
        public Guid? EntityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", CanteenCreditId = " + CanteenCreditId);
            stringBuilder.Append(", IsArchived" + IsArchived);
            stringBuilder.Append(", SearchText" + SearchText);
            return base.ToString();
        }
    }
}
