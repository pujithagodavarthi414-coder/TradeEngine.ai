using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class QuestionsForExport
    {
        public string Type { get; set; }
        public bool? IsOriginalScore { get; set; }
        public bool? lsMandatory { get; set; }
        public string Name { get; set; }
        public string QuestionDescription { get; set; }
        public float Score { get; set; }
        public string QuestionHint { get; set; }
        public string MasterQuestionTypeName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public List<QuestionOptionsForExport> QuestionOptions { get; set; }
    }
}
