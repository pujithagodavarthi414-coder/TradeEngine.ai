using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Crm.Sms
{
    public class SmsTemplateSearchTemplateInputModel : SearchCriteriaInputModelBase
    {
        public SmsTemplateSearchTemplateInputModel() : base(InputTypeGuidConstants.SmsTemplateSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? TemplateId { get; set; }
        public Guid? ReceiverId { get; set; }
        public string TemplateName { get; set; }
        public string Template { get; set; }
        public Guid? UserId { get; set; }

    }
}
