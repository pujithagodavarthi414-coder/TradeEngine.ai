using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditImpactModel
    {
        public Guid? ImpactId { get; set; }
        public String ImpactName { get; set; }
        public String Description { get; set; }
        public bool? IsArchive { get; set; }
        public byte[] TimeStamp { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ImpactId = " + ImpactId);
            stringBuilder.Append("ImpactName = " + ImpactName);
            stringBuilder.Append("Description = " + Description);
            return stringBuilder.ToString();
        }
    }
}
