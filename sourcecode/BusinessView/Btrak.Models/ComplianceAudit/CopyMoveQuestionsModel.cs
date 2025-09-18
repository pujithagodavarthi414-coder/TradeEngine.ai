using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ComplianceAudit
{
    public class CopyMoveQuestionsModel
    {
        public Guid? AuditId { get; set; }

        public bool IsCopy { get; set; }

        public bool IsQuestionsOnly { get; set; }

        public List<Guid?> SelectedCategories { get; set; }

        public bool IsQuestionsWithCategories { get; set; }

        public Guid? AppendToCategoryId { get; set; }

        public bool IsAllParents { get; set; }

        public string SelectedCategoriesxml { get; set; }

        public List<SelectedQuestionModel> QuestionsList { get; set; }

        public string QuestionsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("AuditId = " + AuditId);
            stringBuilder.Append(", IsCopy = " + IsCopy);
            stringBuilder.Append(", IsQuestionsOnly = " + IsQuestionsOnly);
            stringBuilder.Append(", IsQuestionsWithCategories = " + IsQuestionsWithCategories);
            stringBuilder.Append(", IsCasesWithSectionsAndParentSections = " + IsAllParents);
            stringBuilder.Append(", QuestionsList = " + QuestionsList);
            return stringBuilder.ToString();
        }
    }
}
