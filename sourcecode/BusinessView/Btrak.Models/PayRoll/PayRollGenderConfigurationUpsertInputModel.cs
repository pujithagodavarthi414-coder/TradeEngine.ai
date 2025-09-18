using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class PayRollGenderConfigurationUpsertInputModel : InputModelBase
    {
        public PayRollGenderConfigurationUpsertInputModel() : base(InputTypeGuidConstants.PayRollGenderConfigurationInputCommandTypeGuid)
        {
        }

        public Guid? PayRollGenderConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? GenderId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollGenderConfigurationId = " + PayRollGenderConfigurationId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",GenderId = " + GenderId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
