using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class RateTagForSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public RateTagForSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetRateTagFor)
        {
        }
        public Guid? RateTagForId { get; set; }
        public Guid? RateTagForName { get; set; }
        public bool? IsAllowance { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateTagForId = " + RateTagForId);
            stringBuilder.Append(", RateTagForName = " + RateTagForName);
            stringBuilder.Append(", IsAllowance = " + IsAllowance);
            return stringBuilder.ToString();
        }
    }
}
