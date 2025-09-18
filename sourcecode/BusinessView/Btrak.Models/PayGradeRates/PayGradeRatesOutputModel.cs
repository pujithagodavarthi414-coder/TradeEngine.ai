using System;
using System.Text;

namespace Btrak.Models.PayGradeRates
{
    public class PayGradeRatesOutputModel
    {
        public Guid? PayGradeRateId { get; set; }
        public Guid? PayGradeId { get; set; }
        public string PayGradeName { get; set; }
        public Guid? RateId { get; set; }
        public string Type { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PayGradeRateId = " + PayGradeRateId);
            stringBuilder.Append(", PayGradeId = " + PayGradeId);
            stringBuilder.Append(", PayGradeName = " + PayGradeName);
            stringBuilder.Append(", RateId = " + RateId);
            stringBuilder.Append(", Type = " + Type);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
