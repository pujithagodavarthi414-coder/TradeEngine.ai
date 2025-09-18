using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class ConductAuditCategoryModel
    {
        public List<AuditCategoryApiReturnModel> AuditCategories { get; set; }
        public List<Guid?> ConductSelectedCategories { get; set; }
        public List<ConductSelectedQuestionModel> ConductSelectedQuestions { get; set; }
    }
}
