using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class GetAuditVersionsOutputModel
    {
        public string AuditVersionName { get; set; }
        public Guid? AuditId { get; set; }
        public string CreatedByUserName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedByUserProfileImage { get; set; }
    }
}
