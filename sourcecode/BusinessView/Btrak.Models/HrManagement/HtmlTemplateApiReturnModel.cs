using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class HtmlTemplateApiReturnModel
    {
        public Guid? HtmlTemplateId { get; set; }
        public string HtmlTemplateName { get; set; }
        public string HtmlTemplate { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
        public bool IsRoleBased { get; set; }
        public bool IsMailBased { get; set; }
        public bool IsEditable { get; set; }
        public bool IsConfigurable { get; set; }
        public bool IsMaster { get; set; }
        public List<Guid> SelectedRoleIds { get; set; }
        public List<string> MailUrls { get; set; }
        public string Roles { get; set; }
        public string Mails { get; set; }
        public string selectedRoleNames { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public string InActiveOn { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("HtmlTemplateId = " + HtmlTemplateId);
            stringBuilder.Append(", HtmlTemplateName = " + HtmlTemplateName);
            stringBuilder.Append(", HtmlTemplate = " + HtmlTemplate);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", InActiveOn = " + InActiveOn);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
