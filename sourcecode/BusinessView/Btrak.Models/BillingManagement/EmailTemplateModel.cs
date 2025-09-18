using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class EmailTemplateModel: SearchCriteriaInputModelBase
    {
        public EmailTemplateModel() : base(InputTypeGuidConstants.EmailTemplateInputCommandTypeGuid)
        {
        }
        public Guid? EmailTemplateId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? EmailTemplateReferenceId { get; set; }
        public string EmailTemplateName { get; set; }
        public string EmailSubject { get; set; }
        public string EmailTemplate { get; set; }
        public string HtmlTagName { get; set; }
        public string Description { get; set; }
    }
}
