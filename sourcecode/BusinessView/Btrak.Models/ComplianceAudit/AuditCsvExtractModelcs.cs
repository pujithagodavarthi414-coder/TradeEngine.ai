using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class AuditCsvExtractModelcs
    {
        public string AuditName { get; set; }
        public string CategoryHierarchy { get; set; }
        public string CategoryDescription { get; set; }
        public string Type { get; set; }
        public string IsMandatory { get; set; }
        public string Name { get; set; }
        //public string QuestionHint { get; set; }
        public string UseOriginalScrore { get; set; }
        public string Result { get; set; }
        public string Option { get; set; }
        public string Score { get; set; }
        public string Order { get; set; }
        public string QuestionDescription { get; set; }
    }
}
