using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.PayGradeRates
{
    public class PayGradeRatesSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public PayGradeRatesSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchPayGradeRates)
        {
        }
        public Guid? PayGradeRateId { get; set; }
        public Guid? PayGradeId { get; set; }
        public Guid? RateId { get; set; }
        public Guid? OperationsPerformedById { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PayGradeRateId = " + PayGradeRateId);
            stringBuilder.Append(", PayGradeId = " + PayGradeId);
            stringBuilder.Append(", RateId = " + RateId);
            stringBuilder.Append(", OperationsPerformedById = " + OperationsPerformedById);
            return stringBuilder.ToString();
        }
    }
}
