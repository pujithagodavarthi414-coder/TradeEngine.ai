using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollBandsSearchInputModel : SearchCriteriaInputModelBase
    {
        public PayRollBandsSearchInputModel() : base(InputTypeGuidConstants.PayRollBandSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollBandId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollBandId = " + PayRollBandId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
