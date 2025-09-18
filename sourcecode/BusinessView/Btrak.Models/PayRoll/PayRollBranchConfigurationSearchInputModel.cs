using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollBranchConfigurationSearchInputModel : SearchCriteriaInputModelBase
    {
        public PayRollBranchConfigurationSearchInputModel() : base(InputTypeGuidConstants.PayRollBranchConfigurationSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollBranchConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? BranchId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollBranchConfigurationId = " + PayRollBranchConfigurationId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
