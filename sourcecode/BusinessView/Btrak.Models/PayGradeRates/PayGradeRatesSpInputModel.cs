using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.PayGradeRates
{
    public class PayGradeRatesSpInputModel : InputModelBase
    {
        public PayGradeRatesSpInputModel() : base(InputTypeGuidConstants.UpsertPayGradeRateInputCommandTypeGuid)
        {
        }
        public Guid? PayGradeId { get; set; }
        public string RateIds { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayGradeId = " + PayGradeId);
            stringBuilder.Append(", RateIds = " + RateIds);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}

