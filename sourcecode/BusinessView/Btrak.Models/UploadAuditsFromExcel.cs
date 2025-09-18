using Btrak.Models.ComplianceAudit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class UploadAuditsFromExcel
    {
        public string SNo { get; set; }
        public string AuditName { get; set; }
        public string CategoryPath { get; set; }
        public List<CategoryForExport> CategoryForExport { get; set; }
    }
}
