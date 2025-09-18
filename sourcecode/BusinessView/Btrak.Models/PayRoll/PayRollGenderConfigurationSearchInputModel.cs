using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollGenderConfigurationSearchInputModel : SearchCriteriaInputModelBase
    {
        public PayRollGenderConfigurationSearchInputModel() : base(InputTypeGuidConstants.PayRollGenderConfigurationSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollGenderConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? GenderId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollGenderConfigurationId = " + PayRollGenderConfigurationId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",GenderId = " + GenderId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
