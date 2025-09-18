using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
   public class PayRollTemplatesForEmployee
    {
        public Guid? EmployeeId { get; set; }
        public Guid? PayRollTemplateId { get; set; }
        public string PayRollTemplateName { get; set; }
    }
}
