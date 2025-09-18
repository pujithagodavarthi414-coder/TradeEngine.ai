using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class PayRollTemplateSearchInputModel : InputModelBase
    {

        public PayRollTemplateSearchInputModel() : base(InputTypeGuidConstants.PayRollTemplateSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollTemplateId { get; set; }
        public string SearchText { get; set; }
        public string PayRollTemplateName { get; set; }
        public bool? IsRepeatInfinitly { get; set; }
        public bool? IslastWorkingDay { get; set; }
        public bool? IsArchived { get; set; }
        public Guid? FrequencyId { get; set; }
        public string ComponentName { get; set; }
        public string TaxAllowanceTypeName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append("PayRollTemplateName = " + PayRollTemplateName);
            stringBuilder.Append(",SearchText = " + SearchText);
            stringBuilder.Append(",IsRepeatInfinitly = " + IsRepeatInfinitly);
            stringBuilder.Append(",IslastWorkingDay = " + IslastWorkingDay);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", FrequencyId = " + FrequencyId);
            return stringBuilder.ToString();
        }
    }
}
