using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollMaritalStatusConfigurationUpsertInputModel : InputModelBase
    {
        public PayRollMaritalStatusConfigurationUpsertInputModel() : base(InputTypeGuidConstants.PayRollMaritalStatusConfigurationInputCommandTypeGuid)
        {
        }

        public Guid? PayRollMaritalStatusConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? MaritalStatusId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollMaritalStatusConfigurationId = " + PayRollMaritalStatusConfigurationId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",MaritalStatusId = " + MaritalStatusId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
