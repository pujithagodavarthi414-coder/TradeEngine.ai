using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class PayRollRoleConfigurationUpsertInputModel : InputModelBase
    {

        public PayRollRoleConfigurationUpsertInputModel() : base(InputTypeGuidConstants.PayRollRoleConfigurationInputCommandTypeGuid)
        {
        }

        public Guid? PayRollRoleConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public Guid? RoleId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollRoleConfigurationId = " + PayRollRoleConfigurationId);
            stringBuilder.Append(",PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",RoleId = " + RoleId);
            stringBuilder.Append(",IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
