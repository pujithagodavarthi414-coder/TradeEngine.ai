using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollBranchConfigurationUpsertInputModel : InputModelBase
    {
        public PayRollBranchConfigurationUpsertInputModel() : base(InputTypeGuidConstants.PayRollBranchConfigurationInputCommandTypeGuid)
        {
        }

        public Guid? PayRollBranchConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollBranchConfigurationId = " + PayRollBranchConfigurationId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",BranchId = " + BranchId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
