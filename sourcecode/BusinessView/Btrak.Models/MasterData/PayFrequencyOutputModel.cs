using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class PayFrequencyOutputModel
    {
        public Guid? PayFrequencyId { get; set; }
        public Guid? CompanyId { get; set; }
        public string PayFrequencyName { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }
        public string CronExpression { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PayFrequencyId = " + PayFrequencyId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", PayFrequencyName = " + PayFrequencyName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CronExpression = " + CronExpression);
            return stringBuilder.ToString();
        }
    }
}
