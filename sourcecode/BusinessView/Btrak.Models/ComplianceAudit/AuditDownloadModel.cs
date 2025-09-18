using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditDownloadModel : InputModelBase
    {
        public AuditDownloadModel() : base(InputTypeGuidConstants.AuditComplianceInputModelCommandTypeGuid)
        {
        }

        public string AuditName { get; set; }

        public string Download { get; set; }

        public string ToMails { get; set; }
        public Guid? ProjectId { get; set; }
        public bool? IsForFilter { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" auditName = " + AuditName);
            stringBuilder.Append(", Download = " + Download);
            stringBuilder.Append(", ToMails = " + ToMails);

            return stringBuilder.ToString();
        }
    }

}
