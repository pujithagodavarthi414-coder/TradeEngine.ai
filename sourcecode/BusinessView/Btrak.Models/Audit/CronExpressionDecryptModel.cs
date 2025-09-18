using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Audit
{
    public class CronExpressionDecryptModel
    {
        public Guid AuditId { get; set; }
        public string CronExpression { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }
}
