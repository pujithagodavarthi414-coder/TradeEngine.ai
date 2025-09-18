using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollRunArchiveInputModel : InputModelBase
    {
        public PayRollRunArchiveInputModel() : base(InputTypeGuidConstants.RateTagConfigurationInputCommandTypeGuid)
        {
        }

        public Guid PayRollRunId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PayRollRunId = " + PayRollRunId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
