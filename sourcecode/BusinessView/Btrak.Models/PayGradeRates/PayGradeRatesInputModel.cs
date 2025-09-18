using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.PayGradeRates
{
    public class PayGradeRatesInputModel : InputModelBase
    {
        public PayGradeRatesInputModel() : base(InputTypeGuidConstants.UpsertPayGradeRateInputCommandTypeGuid)
        {
        }
        
        public Guid? PayGradeId { get; set; }
        public List<PayGradeRateModel> PayGradeRateModel { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayGradeId = " + PayGradeId);
            stringBuilder.Append(", PayGradeRateModel = " + PayGradeRateModel);
            return stringBuilder.ToString();
        }
    }

    public class PayGradeRateModel
    {
        public Guid? PayGradeRateId { get; set; }
        public Guid? RateId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
    }
}

