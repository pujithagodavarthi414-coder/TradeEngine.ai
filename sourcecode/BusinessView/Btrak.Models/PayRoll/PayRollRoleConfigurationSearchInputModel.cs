using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class PayRollRoleConfigurationSearchInputModel : SearchCriteriaInputModelBase
    {
        public PayRollRoleConfigurationSearchInputModel() : base(InputTypeGuidConstants.PayRollRoleConfigurationSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollRoleConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? RoleId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollRoleConfigurationId = " + PayRollRoleConfigurationId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",RoleId = " + RoleId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(",SearchText = " + SearchText);
            return stringBuilder.ToString();
        }
    }
}
