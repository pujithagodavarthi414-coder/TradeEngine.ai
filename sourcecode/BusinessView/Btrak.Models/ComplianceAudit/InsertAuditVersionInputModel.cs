using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class InsertAuditVersionInputModel
    {
        public Guid? AuditId { get; set; }
        public string AuditVersionname { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AuditId = " + AuditId);
            stringBuilder.Append("AuditVersionname = " + AuditVersionname);
            return stringBuilder.ToString();
        }
    }
}
