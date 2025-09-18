using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
   public  class AuditRatingModel
    {
        public Guid? AuditRatingId { get; set; }
        public String AuditRatingName { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AuditRatingId = " + AuditRatingId);
            stringBuilder.Append("AuditRatingName = " + AuditRatingName);
            stringBuilder.Append("IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}