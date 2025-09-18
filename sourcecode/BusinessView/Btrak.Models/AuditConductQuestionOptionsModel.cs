using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class AuditConductQuestionOptionsModel
    {
        public Guid? AuditConductAnswerId { get; set; }
        public Guid? QuestionTypeOptionId { get; set; }
        public string QuestionTypeOptionName { get; set; }
        public bool? QuestionOptionResult { get; set; }
        public float? QuestionOptionScore { get; set; }
    }
}
