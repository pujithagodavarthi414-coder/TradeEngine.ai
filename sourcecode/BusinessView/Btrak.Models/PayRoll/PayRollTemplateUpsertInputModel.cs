using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollTemplateUpsertInputModel : InputModelBase
    {

        public PayRollTemplateUpsertInputModel() : base(InputTypeGuidConstants.PayRollTemplateInputCommandTypeGuid)
        {
        }

        public Guid? PayRollTemplateId { get; set; }
        public string PayRollName { get; set; }
        public string PayRollShortName { get; set; }
        public bool? IsRepeatInfinitly { get; set; }
        public bool? IslastWorkingDay { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? InfinitlyRunDate { get; set; }
        public Guid? FrequencyId { get; set; }
        public Guid? CurrencyId { get; set; }

        public int? JobId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",PayRollName = " + PayRollName);
            stringBuilder.Append(",PayRollShortName = " + PayRollShortName);
            stringBuilder.Append(",IsRepeatInfinitly = " + IsRepeatInfinitly);
            stringBuilder.Append(",IslastWorkingDay = " + IslastWorkingDay);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", InfinitlyRunDate = " + InfinitlyRunDate);
            stringBuilder.Append(", FrequencyId = " + FrequencyId);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            return stringBuilder.ToString();
        }
    }
}
