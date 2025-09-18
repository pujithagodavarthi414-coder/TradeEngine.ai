using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class MoveAuditQuestionsToAuditCategoryApiInputModel
    {
        public List<Guid> QuestionIds { get; set; }
        public string AuditQuestionsXml { get; set; }
        public Guid? AuditCategoryId { get; set; }
        public Guid? ProjectId { get; set; }
        public bool IsCopy { get; set; }
        public bool IsArchived { get; set; }
    }
}
