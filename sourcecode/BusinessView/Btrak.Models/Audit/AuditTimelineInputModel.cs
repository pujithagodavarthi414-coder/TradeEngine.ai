using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Audit
{
    public class AuditTimelineInputModel
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public List<Guid> AuditIds { get; set; }
        public List<Guid> BranchIds { get; set; }
        public string AuditIdJSON { get; set; }
        public string BranchIdJSON { get; set; }
        public Guid? ProjectId { get; set; }
        public List<Guid?> BusinessUnitIds { get; set; }
        public string BusinessUnitIdsList { get; set; }
    }
}
