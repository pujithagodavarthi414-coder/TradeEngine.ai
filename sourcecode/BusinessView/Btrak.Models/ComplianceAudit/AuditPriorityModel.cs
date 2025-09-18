using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditPriorityModel
    {
        public Guid? PriorityId { get; set; }
        public String PriorityName { get; set; }
        public String Description { get; set; }
        public bool? IsArchive { get; set; }
        public byte[] TimeStamp { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("PriorityId = " + PriorityId);
            stringBuilder.Append("PriorityName = " + PriorityName);
            stringBuilder.Append("Description = " + Description);
            return stringBuilder.ToString();
        }
    }
}
