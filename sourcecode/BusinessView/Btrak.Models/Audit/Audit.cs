using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Audit
{
    public class Audit
    {
        public Guid AuditId { get; set; }
        public string AuditName { get; set; }
        public Guid BranchId { get; set; }
        public string BranchName { get; set; }
        public string AuditDescription { get; set; }
    }
}
