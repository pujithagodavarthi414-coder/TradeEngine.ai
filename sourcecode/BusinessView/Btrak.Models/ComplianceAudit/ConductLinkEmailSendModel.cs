using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class ConductLinkEmailSendModel
    {
        public Guid? AuditId { get; set; }
        public Guid? ConductId { get; set; }
        public string ToMails { get; set; }
        public string ConductName { get; set; }
    }
}
