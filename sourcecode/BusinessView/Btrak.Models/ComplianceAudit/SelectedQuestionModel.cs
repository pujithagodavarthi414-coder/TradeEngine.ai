using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class SelectedQuestionModel
    {
        public Guid? AuditId { get; set; }

        public Guid? QuestionId { get; set; }

        public Guid? AuditCategoryId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AuditId = " + AuditId);
            stringBuilder.Append("QuestionId = " + QuestionId);
            stringBuilder.Append("AuditCategoryId = " + AuditCategoryId);
            return stringBuilder.ToString();
        }
    }
}
