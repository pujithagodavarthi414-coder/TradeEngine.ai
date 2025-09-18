using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class QuestionTypeOptionsModel
    {
        public Guid? QuestionTypeOptionId { get; set; }
        public string QuestionTypeOptionName { get; set; }
        public int? QuestionTypeOptionOrder { get; set; }
        public float? QuestionTypeOptionScore { get; set; }
        public bool CanQuestionTypeOptionDeleted { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("QuestionTypeOptionId = " + QuestionTypeOptionId);
            stringBuilder.Append(", QuestionTypeOptionName = " + QuestionTypeOptionName);
            stringBuilder.Append(", QuestionTypeOptionOrder = " + QuestionTypeOptionOrder);
            stringBuilder.Append(", QuestionTypeOptionScore = " + QuestionTypeOptionScore);
            stringBuilder.Append(", CanQuestionTypeOptionDeleted = " + CanQuestionTypeOptionDeleted);
            return stringBuilder.ToString();
        }
    }
}
