using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class PayRollTemplateConfigurationSearchInputModel : InputModelBase
    {

        public PayRollTemplateConfigurationSearchInputModel() : base(InputTypeGuidConstants.PayRollTemplateConfigurationSearchInputCommandTypeGuid)
        {
        }

        public Guid? PayRollTemplateConfigurationId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public string SearchText { get; set; }
        public bool? IsArchived { get; set; }
        


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PayRollTemplateConfigurationId = " + PayRollTemplateConfigurationId);
            stringBuilder.Append("PayRollTemplateId = " + PayRollTemplateId);
            stringBuilder.Append(",SearchText = " + SearchText);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
