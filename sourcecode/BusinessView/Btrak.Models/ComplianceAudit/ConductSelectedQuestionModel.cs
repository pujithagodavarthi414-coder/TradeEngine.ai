using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class ConductSelectedQuestionModel
    {
        public Guid? QuestionId { get; set; }
        public Guid? AuditCategoryId { get; set; }
        public bool IsChecked { get; set; }
    }
}
