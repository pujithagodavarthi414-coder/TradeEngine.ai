using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditConductMailNotificationModel
    {
        public string CreatedByUserName { get; set; }
        public Guid? ConductId { get; set; }
        public Guid? AuditId { get; set; }
        public string AuditConductName { get; set; }
        public string CreatedUserMail { get; set; }   
        public string SiteAddress { get; set; }
        public Guid UserId { get; set; }
        public Guid CompanyId { get; set; }
    }
}
