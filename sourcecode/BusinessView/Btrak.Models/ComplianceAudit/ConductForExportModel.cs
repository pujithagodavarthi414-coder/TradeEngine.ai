using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
     public class ConductForExportModel
    {
        public string ConductName { get; set; }

        public string Description { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public List<ConductCategoryForExport> Categories { get; set; }
    }
}
