using BTrak.Common;
using System;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class PayFrequencyUpsertModel : InputModelBase
    {
        public PayFrequencyUpsertModel() : base(InputTypeGuidConstants.PayFrequencyInputCommandTypeGuid)
        {
        }
          
        public Guid? PayFrequencyId { get; set; }
        [StringLength(50)]
        public string PayFrequencyName { get; set; }
        public bool? IsArchived { get; set; }
        public string CronExpression { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PayFrequencyId = " + PayFrequencyId);
            stringBuilder.Append(", PayFrequencyName = " + PayFrequencyName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CronExpression = " + CronExpression);
            return stringBuilder.ToString();
        }
    }
}
