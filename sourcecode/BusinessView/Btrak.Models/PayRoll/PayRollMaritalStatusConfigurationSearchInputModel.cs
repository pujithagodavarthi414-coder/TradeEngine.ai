using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollMaritalStatusConfigurationSearchInputModel : SearchCriteriaInputModelBase
    {
        public PayRollMaritalStatusConfigurationSearchInputModel() : base(InputTypeGuidConstants.PayRollMaritalStatusConfigurationSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollMaritalStatusConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? MaritalStatusId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollMaritalStatusConfigurationId = " + PayRollMaritalStatusConfigurationId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",MaritalStatusId = " + MaritalStatusId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
