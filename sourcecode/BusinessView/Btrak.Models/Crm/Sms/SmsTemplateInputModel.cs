using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Crm.Sms
{
    public class SmsTemplateInputModel
    {
        public Guid? TemplateId { get; set; }
        public string TemplateName { get; set; }
        public string Template { get; set; }
        public bool IsActive { get; set; }
    }
}
