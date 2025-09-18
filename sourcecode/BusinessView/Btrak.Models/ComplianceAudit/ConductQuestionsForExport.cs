using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class ConductQuestionsForExport
    {
        public string QuestionName { get; set; }
        public string QuestionDescription { get; set; }
        public string Result { get; set; }
        public DateTime? CreatedDateTime { get; set; }
    }
}
