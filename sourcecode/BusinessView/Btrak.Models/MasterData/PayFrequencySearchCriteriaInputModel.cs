using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.MasterData
{
    public class PayFrequencySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public PayFrequencySearchCriteriaInputModel() : base(InputTypeGuidConstants.GetPayFrequency)
        {
        }
        public Guid? PayFrequencyId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayFrequencyId = " + PayFrequencyId);
            return stringBuilder.ToString();
        }
    }
}
