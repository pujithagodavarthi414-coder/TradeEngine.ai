using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class HtmlTemplateUpsertInputModel : InputModelBase
    {
        public HtmlTemplateUpsertInputModel() : base(InputTypeGuidConstants.DepartmentUpsertInputCommandTypeGuid)
        {
        }

        public Guid? HtmlTemplateId { get; set; }
        public string HtmlTemplateName { get; set; }
        public bool IsRoleBased { get; set; }
        public bool IsConfigurable { get; set; }
        public bool IsMailBased { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public List<string> MailUrls { get; set; }
        public string Mails { get; set; }
        public string Roles { get; set; }
        public string HtmlTemplate { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HtmlTemplateId = " + HtmlTemplateId);
            stringBuilder.Append(", HtmlTemplateName = " + HtmlTemplateName);
            stringBuilder.Append(", HtmlTemplate = " + HtmlTemplate);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}

