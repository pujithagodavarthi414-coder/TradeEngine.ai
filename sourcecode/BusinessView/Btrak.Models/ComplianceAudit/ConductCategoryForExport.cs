using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
     public class ConductCategoryForExport
    {
        public string CategoryName { get; set; }

        public string ParentCategoryName { get; set; }

        public string Description { get; set; }

        public DateTime? CreatedDateTime { get; set; }

        public List<ConductQuestionsForExport> Questions { get; set; }
    }
}
